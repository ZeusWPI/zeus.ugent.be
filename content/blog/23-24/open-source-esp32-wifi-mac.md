---
title: "Unveiling secrets of the ESP32: creating an open-source MAC Layer"
created_at: "2023-12-06"
description: "Reverse engineering the ESP32 Wi-Fi hardware registers"
author: "Jasper Devreker"
image: "https://pics.zeus.gent/rqJc7p6pSbb6FInNNyadKy2tZy2uWqDaFtuU5KPx.jpg" 
---

(This is part 1 of this series, part 2 is [here](https://zeus.ugent.be/blog/23-24/esp32-reverse-engineering-continued/))

The ESP32 is a popular microcontroller known in the maker community for its low price (~ €5) and useful features:  it has a dual-core CPU, built-in Wi-Fi and Bluetooth connectivity and 520 KB of RAM. It is also used commercially, in devices ranging from smart CO₂-meters to industrial automation controllers. Most of the software development kit that is used to program for the ESP32 [is open-source](https://github.com/espressif/esp-idf), except notably the wireless bits (Wi-Fi, Bluetooth, low-level RF functions): that functionality is distributed as precompiled libraries, that are then compiled into the firmware the developer writes.

A closed-source Wi-Fi implementation has several disadvantages compared to an open-source implementation though:

- You are dependent on the vendor (Espressif in this case) to add features; if you have a somewhat non-standard usecase, you might be out of luck. For example, standards-compliant mesh networking (IEEE 802.11s) is not supported on the ESP32; there is [a partially closed-source mesh networking implementation made by Espressif](https://docs.espressif.com/projects/esp-idf/en/stable/esp32/api-guides/esp-wifi-mesh.html), but this is rather limited: the mesh network has a tree topology, and uses NAT on the nodes connected to the root network, making it hard to connect from outside the mesh network to nodes in the mesh network. The protocol is also not documented, so it's not interoperable with other devices.
- It's hard to audit the security of the implementation: since there is no source code available, you have to resort to black-box fuzzing and reverse engineering to find security vulnerabilities.
- Additionally, an open-source implementation would make research into low-power Wi-Fi mesh networking more affordable; if each node only costs about €5, research involving hundreds of nodes can be affordable on a modest budget.

Espressif has an open issue in their esp32-wifi-lib repository, asking to open-source the MAC layer. In that issue, they confirmed in 2016 that open sourcing the upper MAC is on their roadmap, but as of 2023, nothing has been published yet. Having the source code would for example allow us to implement proper 802.11s-compliant mesh networking.


## Goals

The main goal of this project is to build a minimal replacement for Espressifs proprietary Wi-Fi binary blobs. We don't intend to be API-compatible with existing code that uses the Espressif ESP-IDF API, rather, we'd like to have a fully working, open source networking stack.

The rest of this section will contain information about how the network stack and Wi-Fi (the 802.11 standard) works, so if you're already familiar, you can skip it.

<%= figure 'https://pics.zeus.gent/vYXyQm2t9pJCzpDdWFvq9oWR2DACoUJoTsYf8qiz.jpg', 'OSI model of the network stack (the difference between application/presentation/session is a bit murky)' %>

Above, you can see a diagram showing the network stack. Computer networking is done with a network stack, where every layer in the stack has its own purpose; this design makes it easier to swap out layers and allows for separate development of layers. The layer at the bottom of the stack interacts with the physical world (for example, by using radiowaves or electric signals); every layer adds their own features. Wi-Fi (also known as the 802.11 standard by engineers) is implemented in the bottom two layers: the PHY layer (what the radio waveforms look like, ...) and the MAC layer (how we connect to an access point, what packets exist, how to send packets to local devices, ...).

On the ESP32, the PHY layer is implemented in hardware; most of the MAC layer is implemented in the proprietary blob. One notable exception to this separation is sending acknowlegement frame: if a device receives a frame, it should send a packet back to acknowledge that this packet was received correctly. This ACK packet needs to be sent within ~10 microseconds; it would be hard to get this timing correct in software.

There are 3 types of MAC frames:

- Management frames: mostly for managing the connection between the access point and station (client)
- Control frames: help with delivery of other types of frames (for example ACK, but also request-to-send and clear-to-send)
- Data frames: contain the data of the layers above the MAC layer 

## Previous work

Since it doesn't look like Espressif will release an open source MAC implementation anytime soon, we're on our own to create this. This is rather hard to do, because the hardware with which we send and receive 802.11 packets on the ESP32 is entirely undocumented. This means that we will need to reverse engineer the hardware; first we'll need to document what the hardware does, then we'll need to write our own code to correctly interact with it. In 2021, Uri Shaked did some very light reverse engineering of ESP32 Wi-Fi hardware, to mock this in his emulator. That way, programs for the ESP32 can be emulated instead of running them on real hardware. [Shaked gave a talk about this](https://www.youtube.com/watch?v=XmaT8bMssyQ), but only discussed very high level details about the hardware. Espressif has [their own fork of QEMU](https://github.com/espressif/qemu) (a popular, open-source emulator) that can also emulate the ESP32, but this fork does not support emulating the Wi-Fi hardware. In 2022, Martin Johnson added basic support for the Wi-Fi hardware to [their own fork of Espressif's QEMU](https://github.com/a159x36/qemu). The emulated ESP32 can connect to a virtual access point, or have a virtual client connect to it.

esp-idf (the SDK for the ESP32) has a function to transmit frames (`esp_wifi_80211_tx`), but this function only accepts certain types of frames; it does not allow sending most management frames, severely limiting the usefulness of this API to base an 802.11 MAC stack on. They also have a function (`esp_wifi_set_promiscuous_rx_cb`) to receive a callback on reception of a frame.

## Tools

Before we can start reverse engineering how the 802.11 PHY hardware works and how we interact with it, we first need to find or build tools that will help. We'll use 3 main approaches:

- Static reverse engineering: we have the compiled libraries that implement the Wi-Fi stack, so we can look at the compiled code and try to decompile it to human-readable code. From this more readable code, we then try to see what the hardware expects the software to do.
- Dynamic code analysis in an emulator: we can run the firmware in an emulator and inspect how it interacts with the virtual hardware. This has the advantage of having a lot of freedom to how we inspect the hardware, but the disadvantage that the emulator might not behave the same as real hardware. Since we'll need to write the emulated peripherals ourselves, this risk is real: there is no public datasheet for the Wi-Fi peripheral, so we have to guess how the hardware will behave from the code that interacts with it.
- Dynamic code analysis on real hardware: we can run the firmware on an actual ESP32, and debug it using a JTAG debugger. This allows us to place breakpoints, inspect the memory and registers, stop and resume the execution, ... The disadvantage is that the debugging capabilities are more limited compared to running in an emulator: we can only place 2 breakpoints, we cannot place watchpoints (breakpoints that trigger on memory reads/writes to a certain address), ... The big advantage compared to using an emulator is that we'll know for sure that the behaviour of the hardware is correct.

### Static analysis

For the static analysis, we use Ghidra, an open-source reverse engineering tool made by the NSA. Out of the box, Ghidra does not have support [yet](https://github.com/NationalSecurityAgency/ghidra/pull/5442) for Xtensa (the CPU architecture of the ESP32), but there is a [plugin that adds support](https://github.com/Ebiroll/ghidra-xtensa). The build tools used in the ESP32 SDK generate both an ELF file (a type of binary file that can contain metadata) and a flat binary file: using the ELF file has the benefit of automatically setting most function names.


### Dynamic analysis in emulator

We started off from Martin Johnsons's fork of Espressifs version of QEMU (a popular open-source emulator), and ported their changes to the latest version of Espressif's QEMU fork. The ESP32 talks to its peripherals via memory mapped IO: by reading from and writing to certain memory addresses, the peripherals provides information to the CPU and does things. To help in reverse engineering, we added log statements to the QEMU Wi-Fi peripherals that log every access to their memory ranges.

Additionally, we also implemented stack unwinding in QEMU; this is done for every memory access to a hardware peripheral related to Wi-Fi. That way, we can get a full stack trace for every peripheral access. Symbols are not stripped, so this is a very useful tool. However, to get stack unwinding properly working, we have to run QEMU in single step mode: QEMU has a JIT compiler that compiles sequences of emulated assembly instructions into optimized basic blocks. This greatly improves the execution speed, but since the CPU execution state is only guaranteed to be correct at the beginning of a basic block, if a peripheral memory access happens in the middle of such a basic block, the stack unwinding algorithm gives wrong results.

Running in single-step mode negates much of the benefit of the QEMU JIT compiler, causing the code to run much slower. This is not that big of a disadvantage, compared to the treasure trove of information the execution trace gives us.

Below is an example of a single memory access logged by QEMU: it's a write (`W`) to address `3ff46094` with value `00010005`, done by the function `ram_pbus_force_test`. The rest of the callstack is also logged, and translated to a symbol name if available.

```
W 3ff46094 00010005 ram_pbus_force_test 400044f4 set_rx_gain_cal_dc set_rx_gain_testchip_70 set_rx_gain_table bb_init register_chipv7_phy esp_phy_load_cal_and_init esp_phy_enable wifi_hw_start wifi_start_process ieee80211_ioctl_process ppTask vPortTaskWrapper
```

Finally, we also corrected the handling of MAC addresses (compared to Martin Johnsons version), so that a packet capture has correct MAC addresses in packets instead of hardcoded addresses.

### Dynamic analysis on real hardware

To dynamically analyze the firmware on real hardware, we use the JTAG hardware debugging interface. By connecting some jumper wires between the ESP32 and a JTAG debugger, we can debug the ESP32. We followed the steps described in [this GitHub repository](https://github.com/amirgon/ESP32-JTAG) to get our JTAG debugger (CJMCU-232H) working.

In additon to the JTAG debugger, we also connected a USB Wi-Fi dongle directly to the ESP32: the ESP32-WROOM-32U variant of the ESP32 has an antenna connector. We connect that antenna connector to a 60 dB attenuator (this weakens the signal by 60dB), then connect that to the antenna connector of the wireless dongle. That way we'll be able to only receive the packets coming from the ESP32, and the ESP32 will only receive packets sent by the wireless dongle.

This idea unfortunately did not entirely work: enough radio waves from outside access points leaked into the antenna connector that the wireless dongle also received their packets. We tried to build a low-cost faraday cage from a paint can to prevent this, but this only attenuated outside signals with an extra 10dB: this removed some APs, but not all of them. The current solution is definitely not ideal, so we've started work on building a better and larger faraday cage, from conducting fabric and with fiber-optic data communication.

<%= figure 'https://pics.zeus.gent/rqJc7p6pSbb6FInNNyadKy2tZy2uWqDaFtuU5KPx.jpg', 'Wi-Fi dongle connected to the ESP32, with two 30 dB attenuators in between' %>

<%= figure 'https://pics.zeus.gent/ttmZlo7MpEP6CDzzc5q0QX4iVrg3vlsVFUAB6LEU.jpg', 'Faraday cage made from a paint tin, with copper tape to close the hole for the USB connectors, and ferrite chokes to reduce the RF leaking in' %>

## Architecture

### SoftMAC vs HardMAC

SoftMAC (Software MAC) and HardMAC (Hardware MAC) refer to two different approaches for implementing the MAC layer for Wi-Fi. SoftMAC relies on software to manage MAC layer functions, which offers flexibility and ease of modification but can consume more power/CPU cycles. HardMAC, on the other hand, offloads MAC layer processing to dedicated hardware, reducing CPU usage and power consumption but limiting the ability to adapt to new features without hardware changes.

The ESP32 seems to use a SoftMAC approach: you can directly send and receive 802.11 frames (instead of with HardMAC, where you tell the hardware you want to connect to a certain AP, and it would then automatically craft the nescessary frames and send them). This is good news for our open source implementation, since there already exist open-source 802.11 MAC stacks for SoftMAC (for example, mac80211 in the Linux kernel).

### Peripherals

The Wi-Fi functionality is implemented via multiple hardware peripherals, each responsible for a separate part of the functionality. Through reverse engineering, the following peripherals were identified as 'used for Wi-Fi functionaliy' (these are memory addresses, through which the peripherals can be accessed):

- MAC peripherals, at 0x3ff73000 to 0x3ff73fff and at 0x3ff74000 to 0x3ff74fff
- RX control registers, at 0x3ff5c000 to 0x3ff5cfff
- baseband, at 0x3ff5d000 to 0x3ff5dfff
- `chipv7_phy` (?) at 3ff71000 to 3ff71fff
- `chipv7_wdev` (?) at 3ff75000 to 3ff75fff
- RF frontend, at 3ff45000 to 3ff45fff and 3ff46000 to 3ff46fff
- analog at 3ff4e000 to 3ff4efff (this is also used by the DAC connected to GPIO pins)

It should be noted that these peripherals are mirrored to another place in the address space:

> Peripherals accessed by the CPU via 0x3FF40000 ~ 0x3FF7FFFF address space (DPORT address) can also be accessed via 0x60000000 ~ 0x6003FFFF (AHB address). (0x3FF40000 + n) address and (0x60000000 + n) address access the same content, where n = 0 ~ 0x3FFFF.

### Lifecyle

By writing some minimal firmware that just sends packets in a loop and using the three reverse engineer strategies described earlier, a high level overview of the Wi-Fi hardware lifecycle for sending a packet was determined:

1. Calling `esp_wifi_start()`, this indirectly calls `esp_phy_enable()`
2. `esp_phy_enable()` is responsible for initializing the wifi hardware:
    1. Calibrate the PHY hardware: this tries to compensate imperfections of the hardware. According to the data sheet, this does, at least: I/Q phase matching; antenna matching; compensating carrier leakage, baseband nonlinearities, power amplifier nonlinearities and RF nonlinearities (I'm more of a software person than an electronic engineer, so I don't exactly know what these terms mean). This calibration can be stored to the non-volatile storage and to memory. This is used so we don't have to do a full calibration every time the ESP32 wakes up from modem sleep.
    2. Initialize the MAC peripherals: set RX MAC address filters, set the buffers where the packets will be received into, set the auto-ACKing policy, set the chips own MAC address.
    3. Set various physical radio properties (TX rate, frequency, TX power, ...)
    4. Set up the power management timer: if packets are not sent often enough, the modem power save timer kicks in and de-initializes part of the Wi-Fi hardware to save power.
3. Now, we're ready to send a packet:
    1. Wake up some Wi-Fi peripherals from deep sleep and restore their calibration, if we need to
    2. Set some metadata, related to the packet (likely the rate and other PHY settings)
    3. Create a DMA entry, consisting of the length of the packet and the address of the buffer containing the MAC data. The MAC Frame Checksum is automatically calculated by the hardware. DMA stands for Direct Memory Access: that means that we just tell the hardware the address and length of where our packet is, and the hardware will then read that memory and transmit the packet, all on its own.
    4. Write the lowest bits of the DMA entry into a hardware register, then enable it for transmission by setting a bit in the bitmask of that register.
    5. Once the packet is sent, interrupt 0 will fire to notify us how succesful the transmission was. We can react to collisions and timeouts (and probably also to ACKs received?). We also have to clear the interrupt bit that indicates a packet was sent.

### Implementing transmitting packets

As a (very limited) proof-of-concept, we wanted to send arbitrary 802.11 frames by directly using the memory mapped peripherals, so without using the SDK functions. As you can see in the lifecycle diagram above, before transmitting, we first need to initialize the wifi hardware. Unfortunately, this initialization is a lot more complex than sending packets: to intialize the hardware, about 50000 peripheral memory accesses are needed, compared to about 50 for transmitting a packet (including handling the interrupt). These are not exact numbers at all, but they give an idea about the complexity involved.

For the basic 'transmitting packets' proof-of-concept, we are currently still using the proprietary functions to initialize the wifi hardware. We encountered the issue that after initializing, the modem power save timer would kick in and de-initialize the wifi peripherals, preventing us from sending packets. To work around this, we send a single packet using the SDK and then immediately call the undocumented `pm_disconnected_stop()` function, which disables the modem power save mode timer. After this, we can send arbitrary packets by directly writing to the MAC peripheral addresses. For this PoC, we don't need to replace the interrupt handler for wifi events: the existing, proprietary handler will handle the 'packet was sent' interrupt just fine.

The [basic proof of concept](https://github.com/esp32-open-mac/esp32-open-mac) works, we can transmit arbitrary packets by directly writing and reading from memory addresses!

## Current roadmap

Now we can transmit packets, but we still have a lot of work ahead of us: this is the to-do list, in rough order of priorities

- ☑ Send packets
- ☐ Receive packets: to do this, we will need to do the following:
    - Set the RX policy (this filters packets based on MAC address) / enable promiscous mode to receive all packets
    - Set the memory address in which we want to receive the packet via DMA
    - Replace the wifi interrupt with our own interrupt; the code indicates that there might be some kind of wifi watchdog, we'll need to figure out how to pet it.
- ☐ Send ACK (acknowledgment) packets back if we receive a packet that is destined for us
- ☐ Implement changing the wifi channel, rate, transmit power, ...
- ☐ Combine our implementation with an existing open source 802.11 MAC stack, so the ESP32 can associate with access points
- ☐ Implement the hardware initialization (now done by `esp_phy_enable()`). This will be a hard undertaking, since all calibration routines will need to be implemented, but also has a high payoff: we'll then have a completely blob-free firmware for the ESP32.

And a list of possible future extensions that are not yet on the roadmap, but are useful to do anyways:

- ☐ Implement modem power saving: turning off the modem when not in use
- ☐ AMSDU, AMPDU, HT40, QoS
- ☐ Do the cryptography needed for WPA2 etc in hardware instead of in software
- ☐ Bluetooth
- ☐ Write SVD documentation for all reverse engineered registers. An SVD file is an XML file that describes the hardware features of a microcontroller, this makes it possible to automatically generate an API from the hardware description. Espressif already has an SVD file containing the documented hardware registers; we can document the undocumented registers and (automatically) merge them in.

## Code

All code and documentation is available in the [esp32-open-mac GitHub organisation](https://github.com/esp32-open-mac/). I think especially the QEMU fork can be useful for other reverse engineers because of the memory tracing feature.

## Update

Since the beginning of writing this blog post, receiving packets was also implemented. To accomplish this, we needed to implement the Wi-Fi MAC interrupt handler and manage the RX DMA buffers. This means that we now can send and receive packets using only open source code: the hardware initialization is still done with proprietary code, but after this setup is done, only open source code is used to send and receive packets, no more proprietary code is executed. The second part is [here](https://zeus.ugent.be/blog/23-24/esp32-reverse-engineering-continued/)

## Questions? Want to collaborate?

This is a sizeable project that could definitely use multiple contributors; I'd really like to collaborate with other people to create a fully functional, open-source Wi-Fi stack for the ESP32. If this sounds like something you'd like to work on, contact me via <a class="email" href="mailto:%7a%65%75%73%62%6c%6f%67%40%64%65%76%72%65%6b%65%72%2e%62&#101;">zeusblog@<span>not</span>devreker.be</a>, maybe we can have a weekly hacking session?

As far as I know, this is the first undertaking to build an open source 802.11 MAC for an affordable microcontroller. If you want to financially support this project, you can wire money via <https://zeus.ugent.be/contact/#payment-info>, please put "ESP32" in the transaction description, so our treasurer knows what the money is for. Please do not donate if you're a student or if you're not financially independent. If you're a company and would like to donate hardware (for example, a faraday cage or measuring equipment that might be useful), please contact me.

[This project](https://nlnet.nl/project/ESP32-opendrivers/) was funded through the [NGI0 Core Fund](https://nlnet.nl/core/), a fund established by NLnet with financial support from the European Commission's Next Generation Internet programme, under the aegis of DG Communications Networks, Content and Technology under grant agreement No 101092990.


Feel free to send me an email in case you have questions, you think something in this blog post could be worded better or you spotted a mistake.
