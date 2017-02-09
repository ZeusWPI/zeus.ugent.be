---
title: Counting laps using bluetooth dongle detection on the 12 urenloop
banner: https://jaspervdj.be/images/2011-05-09-12-urenloop.jpg
created_at: 09-05-2011
time: 23-02-2016
location: Zeus kelder
---

<em>Crossposted from <a href="https://jaspervdj.be/posts/2011-05-09-12-urenloop.html">jaspervdj.be</a></em>

The <a href="https://www.12urenloop.be/">12 urenloop</a> is a yearly contest held at <a href="https://www.ugent.be/">Ghent University</a>. The student clubs compete in a 12-hour-long relay race to run as much laps as possible. Each of the 14 teams this year had a baton assigned, so they can only have one runner at any time.

<img alt="" src="https://jaspervdj.be/images/2011-05-09-12-urenloop.jpg" title="Just after the start" width="550" height="366" />

<!--more-->

This event is not all about the running — it’s become more of a festival, with lots of things to do and see (I hope I can convince you to check it out if you’re based in Ghent) — but I will focus on the running here, and more specifically: the system used to count the laps.

<h3>The manual way</h3>
Lap counting used to be done in a manual way — people worked in shifts, with two people counting laps at the same time. Simple touchscreens were used, so they basically just sat next to the circuit, looked at the runners that passed and touched the corresponding buttons on the screen.

Although pretty efficient, a completely automated system would be nice-to-have for several reasons:

<ul>
<li>less mistakes are possible (provided it’s a <em>good</em> system);</li>
<li>fewer people are needed (provided it doesn’t need constant monitoring);</li>
<li>the data can be used for several real-time visualisations.</li>
</ul>

So, <a href="https://zeus.ugent.be/">Zeus WPI</a>, the computer science club I am a committee member of, decided to take on this challenge.

<h3>The hardware</h3>
<h4>Bluetooth</h4>
We decided to attach bluetooth dongles to the relay batons. I’m now pretty confident this was a good choice. The other option was the more obvious <a href="https://en.wikipedia.org/wiki/Radio-frequency_identification">RFID</a>, but the main problem here was that RFID hardware is ridiculously expensive. Besides, we already had pretty awesome embedded devices we could use as bluetooth receivers.

<h4 id="gyrid">Gyrid</h4>
These bluetooth receivers were borrowed from the <a href="https://geoweb.ugent.be/cartogis/">CartoGIS</a>, a research group which (among other things) studies technology to track people on events (e.g. festivals) using bluetooth receivers.

<img alt="" src="https://jaspervdj.be/images/2011-05-09-gyrid-node.jpg" title="A Gyrid node" width="560" height="374" />

The receivers run a custom build of <a href="https://linux.voyage.hk/">Voyage Linux</a> created to run the <a href="https://github.com/Rulus/Gyrid">Gyrid</a> service. What does this mean for us? We get simple, robust nodes we can use as:

<ul>
<li>linux node: we can simply SSH to them and set them up</li>
<li>switch: to create a more complicated network setup (see later)</li>
<li>receiver: sending all received bluetooth data to a central computing node</li>
</ul>
Here is another picture of what’s inside of a node:

<img alt="" src="https://jaspervdj.be/images/2011-05-09-gyrid-node-inside.jpg" title="A Gyrid node (inside)" width="560" height="325" />

<h4 id="relay-batons">Relay batons</h4>
We built the relay batons using a simple design: a battery pack consisting of 4 standard AA batteries and connecting them to a bluetooth chip, put in a simple insulation pipe.

Some extensive tests on battery duration were also done, and it turns out even the cheapest batteries are good enough to keep a bluetooth chip in an idle state for more than 50 hours. We never actually set up a bluetooth connection between the receivers and the relay batons — we just detect them and use that as an approximate position.

<img alt="" src="https://jaspervdj.be/images/2011-05-09-relay-batons.jpg" title="Left: our sweatshop, right: a relay baton" width="560" height="373" />

<h4 id="network-setup">Network setup</h4>
The problem here was that we only could put cables <em>around</em> the circuit, we couldn’t cut right through to the other side of the circuit. This means the commonly used <a href="https://en.wikipedia.org/wiki/Star_network">Star network</a> was impossible (well, theoretically it was possible, but we would need <em>a lot</em> of cables).

Instead, <a href="https://twitter.com/jenstimmerman">Jens</a>, <a href="https://thinkjavache.be/">Pieter</a> and <a href="https://twitter.com/nudded">Toon</a> created an awesome ring-based network, in which each node also acts as a switch (using <a href="https://www.linuxfoundation.org/collaborate/workgroups/networking/bridge">bridging-utils</a>). Then, the <a href="https://en.wikipedia.org/wiki/Spanning_Tree_Protocol">Spanning Tree Protocol</a> is used to determine an optimal network layout, closing one link in the circle to create a tree.

This means we didn’t have to use <em>too much</em> cables, and still had the property that one link could go down (physically) without bringing down any nodes: in this case, another tree would be chosen. And if two contiguous links went down, we would only lose one node (obviously, the one in between those two links)!

<img alt="" src="https://jaspervdj.be/images/2011-05-09-ring.png" title="Ring-based network with spanning tree indicated" width="450" height="351" />

<h4 id="count-von-count">count-von-count</h4>

Now, I will elaborate on the software which interpolates the data received from the Gyrid nodes in order to count laps <sup><a href="#fn1" class="footnoteRef" id="fnref1">1</a></sup>. <code>count-von-count</code> is a robust system written in the <a href="https://haskell.org/">Haskell</a> programming language.

At this point, we have a central node which receives 4-tuples from the Gyrid nodes:

<pre><code>(Timestamp, Mac receiver, Mac relay baton, RSSI value)
</code></pre>
After some initial tests, we concluded the <a href="https://en.wikipedia.org/wiki/Received_signal_strength_indication">RSSI</a> value was not too useful for us. Later, we did use it to determine if a signal was strong enough (i.e. RSSI above a certain treshold), and then we discarded the RSSI value. This leaves us with a triplet:

<pre><code>(Timestamp, Mac receiver, Mac relay baton)
</code></pre>
We do the calculations separately for each team — only we work with relay batons instead of teams. This means that we get, for every team:

<pre><code>(Timestamp, Mac receiver)
</code></pre>
We also (<a href="https://bash.org/?5273">hopefully</a>) know the location of our Gyrid nodes, which means we can again map our data to something more simple:

<pre><code>(Timestamp, Position)
</code></pre>
This is something we can easily plot. Note that there are only a few possible positions, since we discarded the RSSI values because of reliability issues.

<img alt="" src="https://jaspervdj.be/images/2011-05-09-plot.png" title="Linear regression used" width="550" height="389" />

I’ve illustrated the plot further with a linear regression, which is also what <code>count-von-count</code> does. Based on this line, it can figure out the average speed and other values which are then used to “judge” laps. When <code>count-von-count</code> decides a relay baton has made a lap, it will make a REST request to <code>dr.beaker</code>.

<h3 id="dr.beaker">dr.beaker</h3>
<code>dr.beaker</code> is the scoreboard application. It’s implemented by <a href="https://twitter.com/blackskad">Thomas</a> as a <a href="https://en.wikipedia.org/wiki/Java_(programming_language)">Java</a> service that runs on top of <a href="https://glassfish.java.net/">GlassFish</a>. It provides features such as:

<ul>
<li>registering &amp; managing batons and teams</li>
<li>assigning batons to teams</li>
<li>a scoreboard</li>
<li>a history of the entire competition</li>
</ul>
and more.

<h2 id="conclusion">Conclusion</h2>
It’s a hardware problem.

When the contest started, both Gyrid, <code>count-von-count</code> and <code>dr.beaker</code> turned out to be quite reliable. However, our relay batons were breaking fast. This simply due to the simple, obvious fact that runners don’t treat your precious hardware with love — they need to be able to quickly pass them. Inevitably, batons will be thrown and dropped.

<img alt="" src="https://jaspervdj.be/images/2011-05-09-monitoring.jpg" title="Thomas & me monitoring the batons" width="550" height="366" />

Initially, we were able to swap the broken relay batons for the few spare ones we had, and then quickfix the broken ones using some duct tape. After about five hours, however, they really started breaking — at a rate that was hard to keep up with using quickfixing.

Hence, this is the main goal for next year: build reliable, solid relay batons. We need to be able to throw them down from a four-story building. Beth Dido needs to be able to use them as a dildo, and they should come out unharmed. Feel free to <a href="https://zeus.ugent.be/contact/">contact us</a> if you’re interested in making this happen!
