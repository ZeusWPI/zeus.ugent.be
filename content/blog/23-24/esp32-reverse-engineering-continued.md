---
title: "Unveiling secrets of the ESP32 part 2: reverse engineering RX"
created_at: '2023-12-06'
description: "Reverse engineering the ESP32 Wi-Fi receive registers and showing off a proof-of-concept"
author: "Jasper Devreker"
image: "https://pics.zeus.gent/rqJc7p6pSbb6FInNNyadKy2tZy2uWqDaFtuU5KPx.jpg" 
---

This is the second article in a series about reverse engineering the ESP32 Wi-Fi networking stack, with the goal of building our own open-source MAC layer. In the [previous article](https://zeus.ugent.be/blog/blog/23-24/open-source-esp32-wifi-mac/) in this series, we built static and dynamic analysis tools for reverse engineering. We also started reverse engineering the transmit path of sending packets, and concluded with a rough roadmap and a call for contributors.

In this part, we'll continue reverse engineering, starting with the 'receiving packets' functionality: last time, we succesfully transmitted packets. The goal of this part is to have both transmitting and receiving working. To prove that our setup is working, we'll try to connect to an access point and send some UDP packets to a computer also connected to the network.

# Receive functionality

As a short recap, the transmit functionality worked by:

1. Putting the packet you want to transmit in memory
2. Create a DMA (direct memory access) struct. This struct contains:
    - the address of the packet you want to transmit
    - the length and size of the packet (I haven't entirely figured out the difference, but one always seems to be 32 bigger than the other one)
    - the address of the next packet (we set this to NULL to transmit a single packet)
3. Write some other memory peripherals to configure the settings for the packet you're about to transmit
4. Write the address of the DMA struct to a memory mapped IO address
5. The hardware then automatically reads the DMA struct, and transmits the packet
6. After this is done, interrupt 0 will fire, telling us how succesful the transmission was

The receive functionality seems to use the same DMA struct, but in a slightly different way:

1. Set up a linked list of DMA structs, where the `next` field of the struct points to the next DMA struct in the linked list. The final DMA struct points to NULL. Every `address` field points to a buffer, and the lenght and size fields are set to the size of the buffer.
2. Write the address of the first DMA struct to a memory mapped IO address (`WIFI_BASE_RX_DSCR`). Now the setup is done, and we can receive packets.
3. When a packet is received by the hardware, it will put the packet into the address of the first available DMA struct. The `length` field will indicate the lenght of the packet; the `size` field will not be updated. The `has_data` field will be set to 1.
4. Interrupt 0 will fire to notify the processor that a packet was received. This interrupt will notify a non-interrupt task that a packet was received. We should avoid to do much processing in the interrupt, since we want to return as quickly as possible.
5. Outside of the interrupt, we can then look at the linked list of DMA structs to see which ones have their `has_data` bit set. The address buffers can then be passed up further in the Wi-Fi MAC stack. We want to avoid running out of DMA structs to receive packets into, so we have to extend the linked list. We could do it by just allocating a new DMA struct and space for a packet and putting it at the end of the DMA linked list, but this constant allocating and deallocating would be rather inefficient. Instead, we recycle existing DMA structs by resetting their fields and inserting them at the end of the linked list.

# Practicalities

Now we have a basic way to receive packets, but when we implemented this, no packets were received: this was likely because of the hardware MAC address filters: if you are a Wi-Fi device, there are a lot of packets flying in the air that you're not interested in. For example, if you're a station (for example, a phone) and are connected to an access point, you don't really care about the packets other access points are sending to their stations. To avoid the overhead in also having to process 'uninteresting' packets, most Wi-Fi devices have a hardware filter where you can set the MAC addresses of packets you want to receive. The hardware will then filter out the packets with different MAC addresses, and will only forward packets with matching MAC addresses to the software.

The ESP32 also seems to have this implemented, but luckily for us, the ESP32 also implements a sort of monitor mode (also known as promiscuous mode), where every packet that is receieved by the hardware is passed to the software. The ESP32 SDK has a call `esp_wifi_set_promiscuous(bool)` where you can enable or disable this feature. When we enabled this, we did start to receive packets. We'll eventually reverse engineer and implement hardware MAC address filtering as well, but for now, we'll just filter in software.

# Connecting to an access point

Now that we can send and receive working, you'd think that we'd be able to connect to an access point and start sending packets, right? Well, not entirely: since this is such a big project, we only implemented the bare minimum to proceed in every phase. This is the same approach Ladybird takes to build a novel browser:

> If you tried to build a browser one spec at a time, or even one feature at a time, you’d most likely run out of steam and lose interest altogether.
> So instead of that, we tend to focus on building “vertical slices” of functionality. This means setting practical, cross-cutting goals, such as “let’s get twitter.com/awesomekling to load”, “let’s get login working on discord.com”, and other similar objectives.

This approach is very motivating, but sometimes bites you in the ass when you have to figure out why something is not working.

## Step 1: using Scapy

Before we start with the undertaking of connecting the ESP32 to an access point, we'll first start by implementing connecting a regular USB Wi-Fi dongle to an access point by constructing and sending the packets ourselves to make sure we understand everything that's needed; and so we'll have a known-working reference implementation. We found [this blog post](https://wlan1nde.wordpress.com/2016/08/24/fake-a-wlan-connection-via-scapy/) about using Scapy, a Python packet manipulator library, for connecting to an open access point. We need 4 packets to set up the connection:

1. Authentication, from client to AP
2. Authentication, from AP to client
3. Association request, from client to AP
4. Association response, from AP to client

After that, if everything has gone well, we can send data frames from the client to the access point and they'll get accepted. We extended the blog post code a bit to also send data frames at the end of the connection setup, and verified that everything was working. For the data frames, we used UDP packets, because we can just construct the packet once, and then keep sending it; UDP is stateless, unlike TCP.

## Step 2: using the ESP32

We implemented this on the ESP32, by copying the packets from Scapy and hardcoding the packet contents in the C source code. To make sure we could discern the ESP32 from the scapy implementation, we replace the MAC address of the adapter we use for testing with an arbitrary MAC address (`01:23:45:67:89:ab`). When we then sent the packets, we saw that we received an ACK frame in response to our authentication, but we didn't receive an authentication answer back from the AP. Even stranger, the ACK was towards a different MAC address: `00:23:45:67:89:ab`.

Apparently, MAC addresses aren't just 6 arbitrary bytes with the first 3 bytes being vendor specific: the last bit of the first byte indicates if the packet is unicast or multicast. By using the `01:...` MAC address, we had sent multicast packets instead of unicast packets.

After fixing this by using a different MAC address, we started to receive frames back from the access point. Because we didn't implement sending ACKs back, we received every frame from the access point 4 times: since the access point didn't receive any ACKs back, it would assume the packet was not received correctly. At that point, that wasn't a problem: the AP would happily proceed with association request and response.

However, when we started to send data packets, we'd immediately started to receive disassociation frames from the AP as a reply to our data packets. The only difference between the (working) Scapy implementation and the current ESP32 implementation, was not sending ACKs back; so I guess implementing that is nescessary after all.

Sending ACK frames back in software is not as easy as it seems though: the ACK frame needs to be sent exactly one SIFS (Short Interframe Space) time period after the last symbol of the received frame. For 802.11b, such a SIFS is only 10 microseconds; the round-trip-time through the hardware and software is already more than 10 us, so we can't implement this in software. The proprietary network stack does send ACK frames back, so this must be implemented somehow. And indeed, sending ACKs is implemented in hardware: by writing to a memory-mapped IO address, you can configure a MAC address for which the hardware will automatically send back an ACK.

After also implementing this, we received our first packets on the computer that had netcat listening for UDP packets 🎉

<%= figure 'https://pics.zeus.gent/kLBUMHjakrlOWduaxWCEysk2FeDW3uAnKRNgcSuv.jpg', 'First succesfully received data packets sent by ESP32' %>

Since we now implement the interrupt ourselves, we can send and receive frames, without any proprietary code *running* (proprietary code is still used to initialize the hardware in the begin, but is not needed anymore after that).

The current way of hardcoding the contents of packets was appropriate for the proof-of-concept showing that we can connect to an AP and send packets, but is not useable for our eventual goal. We're searching for an open source implementation that handles the higher level functionality of the 802.11 MAC layer (constructing and parsing packets, knowing what packets to send when, ...). For the higher layers, we can use the existing lwIP TCP/IP-stack on the ESP32.

All code is available on the [esp32-open-mac GitHub organisation](https://github.com/esp32-open-mac/).

# Roadmap

- ☑ Send packets
- ☑ Receive packets
- ☑ Send ACK (acknowledgment) packets back if we receive a packet that is destined for us
- ☑ Implement hardware filtering based on MAC address so we don't receive as much packets
- ☐ Find or build an open source 802.11 MAC implementation to construct the packets we want to send. The Linux kernel has mac80211, but including the full Linux kernel does not seem to be feasible. This is not ESP32-specific; we'd ideally find an implemenation where you can pass your own TX and RX functions, and they do the rest.
- ☐ Implement changing the wifi channel, rate, transmit power, ...
- ☐ Implement the hardware initialization (now done by `esp_phy_enable()`). This will be a hard undertaking, since all calibration routines will need to be implemented, but also has a high payoff: we'll then have a completely blob-free firmware for the ESP32.
- ☐ Write SVD documentation for all reverse engineered registers. An SVD file is an XML file that describes the hardware features of a microcontroller, this makes it possible to automatically generate an API from the hardware description. Espressif already has an SVD file containing the documented hardware registers; we can document the undocumented registers and (automatically) merge them in.

The two hardest (but most important) tasks are implementing hardware initialization, and connecting our sending and receiving primitives to an open source 802.11 MAC stack.

## Bonus: Charlotte breaking everything

Charlotte playing music completely broke the setup: the music setup at our hackerspace works via RTP (Realtime Transport Protocol). Under the hood, RTP sends UDP packets containing the audio data to a multicast address; so these packets was also transmitted over the Wi-Fi. Because this was a lot of packets per second, the receive buffer was always full, and very few other packets could be received/ACKed. This made it clear that hardware filtering would need to be implemented sooner than later; reverse engineering turned out to be not as much work as expected.

The hardware filtering seems to have two 'slots', for every slot you can filter on a destination MAC address and on a BSSID (not sure if you can do both in each slot or you have to choose). By default, the hardware will not let any packets through. The hardware will only send an ACK frame back if the packet was let through via one of the filters and was copied into an RX DMA buffer: packets that were copied into an RX DMA buffer because of promiscuous mode will not result in an ACK frame getting sent.

## Questions? Want to collaborate?

This is a sizeable project that could definitely use multiple contributors; I'd really like to collaborate with other people to create a fully functional, open-source Wi-Fi stack for the ESP32. If this sounds like something you'd like to work on, contact me via <a class="email" href="mailto:%7a%65%75%73%62%6c%6f%67%40%64%65%76%72%65%6b%65%72%2e%62&#101;">zeusblog@<span>not</span>devreker.be</a>, maybe we can have a weekly hacking session?

As far as I know, this is the first undertaking to build an open source 802.11 MAC for an affordable microcontroller. If you want to financially support this project, you can wire money via https://zeus.ugent.be/contact/#payment-info, please put "ESP32" in the transaction description, so our treasurer knows what the money is for. Please do not donate if you're a student or if you're not financially independent. If you're a company and would like to donate hardware (for example, a faraday cage or measuring equipment that might be useful), please contact me.

[This project](https://nlnet.nl/project/ESP32-opendrivers/) was funded through the [NGI0 Core Fund](https://nlnet.nl/core/), a fund established by NLnet with financial support from the European Commission's Next Generation Internet programme, under the aegis of DG Communications Networks, Content and Technology under grant agreement No 101092990.

Feel free to send me an email in case you have questions, you think something in this blog post could be worded better or you spotted a mistake.

