---
title: The importance of subnets
banner: https://zeus.ugent.be/~blackskad/blog/wp-includes/images/smilies/icon_smile.gif
created_at: 17-12-2008
time: 23-02-2016
location: Zeus kelder
---

_(Bericht overgenomen van [Blackskad's blog](https://zeus.ugent.be/~blackskad/blog/))_

When I became an active member of zeus, we inherited a little network. It contained some desktops and several servers. They all had an ip in the subnet 10.1.1.0/24, and were connected to the internet using a single IP. (well, not completely true, there was a spare gateway. But that didn’t make any difference.)

We had a problem though: we couldn’t reach our webserver from internal clients using the normal url. When we wanted to surf to <https://zeus.ugent.be>, it just hang on “connecting to server”.

Well, tcpdump and wireshark to the rescue! Using those tools, we noticed this problem:

~~~
client= 10.1.1.10
webserver= 10.1.1.248
external ip= 157.193.55.238
~~~

~~~
10.1.1.10 -> ACK     -> 157.193.55.238
10.1.1.10 -> ACK     -> 10.1.1.248
10.1.1.10 <- SYN/ACK <- 10.1.1.248
10.1.1.10 -> RST     -> 10.1.1.248
~~~

So what happened? The gateway at 157.193.55.238 notices that the traffic has to be send to the webserver. So it forwards the packets, but doesn’t apply address translations. Then the webserver answers to the client directly, instead of going throught the gateway. As the client doesn’t expect any answer from 10.1.1.248 but from 157.193.55.238, it sends a reset to the webserver.

After being unable to come up with a solution using iptables, we decided to use a more radical tactic: change a part of the network layout. The whole network is still located in the 10.1.1.0/24 subnet, but we’ve split it up in two: the clients in 10.1.1.0/25 and servers in 10.1.1.128/25 Using this setup, the gateway applies it’s address translation correctly, and we are able to surf to the website internally without problems! ![:)](https://zeus.ugent.be/~blackskad/blog/wp-includes/images/smilies/icon_smile.gif)

While fixing this, we’ve set up a “new” gateway. During the years, both the iptables, the dns-rules and the dhcp-config gathered a lot of cruft - so we got rid of that too. Yay for clean configs ![:)](https://zeus.ugent.be/~blackskad/blog/wp-includes/images/smilies/icon_smile.gif)
