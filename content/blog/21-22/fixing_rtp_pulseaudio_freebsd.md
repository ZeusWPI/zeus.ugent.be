---
title: Fixing a bug in PulseAudio's RTP sink on FreeBSD
created_at: 09-06-2022
author: "Jasper Devreker"
---

To play music in the Zeus WPI space, we had a Linux machine
connected to the speakers running PulseAudio. PulseAudio was
configured to pass-through the audio it received from the Bluetooth
receiver. Since some of our members don't have a working Bluetooth implementation
on their device, we also used `module-native-protocol-tcp`: this enables you
to directly connect to the server and play your audio via PulseAudio's native
TCP protocol.

Unfortunately, this suffers from frequent stuttering when using it over Wi-Fi:
if a packet drops, all other packets can't be played until the dropped packet is retransmitted.
These drops got annoying after a while, so we also set up an RTP
(Real-time Transport Protocol) sink in PulseAudio.
RTP is a protocol for real-time delivery of audio (and video) over IP networks.
It uses UDP, so if a packet drops, the sink just considers that packet as lost and doesn't
have to wait until it eventually arrives after a short while. It then (probably, I haven't verified this) interpolates the missed packet so the missed packet is less noticeable.
This worked great while it lasted, but then the Linux machine running PulseAudio broke down
and we replaced it with a new machine running FreeBSD, thinking that since PulseAudio also
ran on FreeBSD, it would be easy to get running again.

The FreeBSD server for some reason did not play RTP streams anymore, so here our debugging
adventure begins.

I suspected networking issues, so I dumped the RTP packets arriving on the FreeBSD into a
pcap file with `tcpdump`:

```
$ tcpdump -i bce0 host 10.0.0.8 -T rtp -v -s 0 -w rtpdump.pcap
```

When opened in Wireshark, this showed the following (10.0.0.8 is the FreeBSD audio server, 10.0.42.1 is the machine steaming RTP):

![a network dump, RTP packets that get ICMP port unreachable responses](https://pics.zeus.gent/rtp_port_unreachable.png)

It became clear that the RTP packets were arriving on the host, but PulseAudio was not listening on that port. After reading up some more about how RDP works, there are apparently two parts to RTP streaming: the RTP stream itself, containing the audio; and 
at a regular interval an SAP/SDP (Session Announcement/Description Protocol) packet containing information about the RTP stream (the type, name, and importantly for us, the port). I then suspected that something went wrong with the SAP packets in PulseAudio, since there was no 'this port is closed' ICMP packet for the SAP packets. 

![a network dump, showing an SAP packet surrounded by RTP packets](https://pics.zeus.gent/sap_packet.png)

After some searching, I found the PulseAudio logs in `/var/log/messages`, and now the line
`pulseaudio[41410]: [(null)] sap.c: recvmsg() failed: size mismatch` made sense: receiving
the SAP message failed, so the port that's supposed to receive the RTP packets never gets
opened. After some searching for that error message in the PulseAudio codebase, this is 
the code that prints the errormessage:

```c
int pa_sap_recv(pa_sap_context *c, bool *goodbye) {
    struct msghdr m;
    struct iovec iov;
    int size;
    char *buf = NULL, *e;
    uint32_t header;
    unsigned six, ac, k;
    ssize_t r;

    pa_assert(c);
    pa_assert(goodbye);

    if (ioctl(c->fd, FIONREAD, &size) < 0) {
        pa_log_warn("FIONREAD failed: %s", pa_cstrerror(errno));
        goto fail;
    }

    buf = pa_xnew(char, (unsigned) size+1);
    buf[size] = 0;

    iov.iov_base = buf;
    iov.iov_len = (size_t) size;

    m.msg_name = NULL;
    m.msg_namelen = 0;
    m.msg_iov = &iov;
    m.msg_iovlen = 1;
    m.msg_control = NULL;
    m.msg_controllen = 0;
    m.msg_flags = 0;

    if ((r = recvmsg(c->fd, &m, 0)) != size) {
        pa_log_warn("recvmsg() failed: %s", r < 0 ? pa_cstrerror(errno) : "size mismatch");
        goto fail;
    }
...
```

Somehow, the size returned by `ioctl(c->fd, FIONREAD, &size)` and `recvmsg(c->fd, &m, 0)`
were not the same. I then wanted to insert some logging code to figure out what both functions returned, but to do that, I would need to recompile PulseAudio from source.
Luckily, this is [very easy on FreeBSD](https://docs.freebsd.org/en/books/handbook/ports/#ports-using-portsnap-method): you fetch the source code of every package, then `cd` into the directory your package is in and run `make`. It will then fetch the source, interactively ask you some questions about what features you want to compile and compile the package. The source and built binaries will then be in the `work/` subdirectory.
I had an issue where I edited the source and executed `make` again, but the code didn't recompile. Some nice people in the FreeBSD Discord told me to remove the `work/.build_done*` and `work/.stage_done*`, this worked.


A debug print showed that the `FIONREAD` ioctl returns 255 as the size of the next packet, but the `recvmesg` call only returns 207 bytes. The packet
trace also shows that the UDP packet is 207 bytes long, so somehow the `FIONREAD` ioctl
is not returning the size of the next packet. This code did work on Linux, so there must
be some differences in the ioctl on Linux and FreeBSD; and indeed:

- On Linux, the `FIONREAD` ioctl returns the size of the next datagram in the queue
- On FreeBSD (and other BSDs as well), it returns the size of the entire output buffer:    
  this count also includes the internal metadata and can include multiple datagrams.

The `FIONREAD` size reported will always be bigger than the size of the packet to be 
received with `recvmesg`, so for now, I commented out the `goto fail;` in the size 
checking code.
The SAP packets did get accepted and the RTP port was opened, but still no sound played. 
Worse yet, there were also no more error messages in the logs. Suspecting that something
similar might be happening in the RTP receiving code, I grepped for `FIONREAD` in the
PulseAudio codebase, and indeed, it was the same problem. Also commenting out the `goto fail:` check there fixed the issue: audio now finally played 🎉🎉.

I properly fixed this by removing the size checking code: the `FIONREAD` will then be a
lower bound for the size of the packet. For safety, I also added an upper bound of `1<<16`:
the contents of a UDP packet will never be bigger than that (the actual upper bound is a bit smaller, but I couldn't be arsed to figure it out).

I hope [my patch to fix PulseAudio's RTP source](https://gitlab.freedesktop.org/pulseaudio/pulseaudio/-/merge_requests/718) will get accepted, so that we can run the
packaged version of PulseAudio again instead of the binary built from the modified source.