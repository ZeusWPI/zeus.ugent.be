---
title: "Biometrics for all! Lockbot gains a new interface"
created_at: 21-12-2022
descriptionn: "Because why have one system that can fail, when you can have several"
author: "Tibo Ulens"
---

Every Zeus member needs to enter the Kelder at some point, so why not give them
ample choice for how they should do so. Inspired by Niko's addition of a
[Zeus-specific mode to Hydra](https://zeus.gent/blog/21-22/zeus_modus_hydra/)
which allowed the door to be unlocked using NFC and fueled by the incessant
desire to do anything that isn't studying brought on by the exam season, I
decided everyone's favourite door could do with yet another upgrade: a random
fingerprint sensor I found in the back of the electronics closet!

## Hardware

### The Sensor Itself

The fingerprint sensor I used is an
[R503 sensor](https://www.adafruit.com/product/4651) that was lying in the back
of one of our closets. It's a fairly simple product to use; all its
communication is done over serial and it has a finger detection pin that can be
used as an interrupt in whatever microcontroller you connect it to. It also has
a ring shaped LED surrounding the sensor which you can set to red, blue, or
purple, either constantly on or flashing, thus allowing for some very basic
user interaction.

Whenever you tell the sensor to scan a fingerprint, it takes a picture of
whatever is on the sensor and uses some fancy feature extraction code to get a
simplified representation of the fingerprint. It can then either store this
feature map in its internal flash memory, or it can attempt to find a match
with another, already stored, feature map to allow you to compare two
fingerprints.

### The Microcontroller

Seeing as the sensor would need to be able to communicate with
[lockbot](https://github.com/zeusWPI/lockbot) (the robot attached to our door
that (un)locks it) somehow, and because I wanted it to use Mattermost commands
to let users add or delete their fingerprint to or from the system, the
microcontroller controlling the sensor was going to have to have some form of
networking capability.

At the beginning of the project I was using an Arduino with an ethernet shield
we had laying around to power the whole thing. This worked fine, however there
was a strange bug where, whenever the sensor detected a fingerprint and
triggered an interrupt, the arduino would act as if it were continually
receiving new interrupts. <br/>
Fortunately for me however, the ethernet shield randomly broke one day, and I
ported the whole thing over to an ESP32 Wi-Fi connected microcontroller.
Somehow this managed to fix the interrupt bug and I dare not question why
for fear of my own sanity.

### The Revolutionary "Power" over """Ethernet""" Cable

Any electronics project needs power, and the fingerprint sensor is no
exception. Seeing as it was going to need to be mounted outside the Kelder, it
was going to require a cable to be threaded through a hole in the wall some
pipes were running through. But this posed a problem: we don't have any cables
that are long enough! But luckily, Jasper had a genius solution: just use power
over ethernet.

Many of you are probably familiar with Power over Ethernet or PoE, a very
useful concept that lets you use ethernet cables not just to transfer data, but
also to power whatever it is they are transmitting data to or from. However,
these systems usually run at 48V and use some fancy electronics wizardry to
ensure data integrity, so it would've been difficult to integrate into the
project. So, naturally, when I heard his suggestion I thought it was a little
overkill. But Jasper then informed me that he wasn't talking about any sort of
fancy standardised, tried and tested, system, he actually meant the
revolutionary "Power" over ""Ethernet"" "standard". An exceptionally simple
"standard" where you simple use half of the cables in an ethernet cable to
carry +5V and the other half to carry ground. That's it.

I was instantly sold.

### The case

Ever a lover of 3D printing, Jasper took it upon himself to design and print a
modernist, bespoke case for the electronics to accentuate its beautiful
circular lighting and cold, industrial mounting system (translator's note: a
grey box with holes in it).

## Software

### The ESP

As stated previously, I wanted users to be able to add and remove fingerprints
using Mattermost commands. To this end, the ESP microcontroller is running a
*very* basic webserver which can accept 3 commands:

 - Enroll - Used to let the issuer of the command add a new fingerprint with an
            alias of their choosing to make it easier to distinguish them
 - Delete - Used to let the issuer of the command delete any of their
            fingerprints by specifying its alias or to let admins delete any
			specific fingerprint
 - List - Used to let the issuer of the command see all of the fingerprints
          (aliases) they have or to let admins see all fingerprints

All interactions with the webserver are expected to contain a monotonically
increasing timestamp as well as an HMAC signature to prevent attacks, should
either of these be missing or incorrect the webserver will send a warning to
mattermore so that admins can be informed.

After successfully enrolling, deleting, or detecting a fingerprint the sensor
will send a message to mattermore to allow it to update its database containing
users and their fingerprint aliases, to open the door, or to notify the user
that their command succeeded.

### Mattermore

Using Mattermost commands for the sensor means using mattermore to handle them
correctly.

Mattermore was updated to include 2 new endpoints `/fingerprint` and
`/fingerprint_cb`, used to handle `/fingerprint` commands and and any callback
messages from the sensor, respectively.

The database was also updated to include a new 'Fingerprint' table used to
store which users have which fingerprints. This is needed as, whenever the
sensor detects a known fingerprint, it simply returns its internal ID, however
we want to know which user this fingerprint belongs to so we can print out a
nice message in ~kelder to ensure nobody opens the Kelder unnoticed.

## Using The Fingerprint Sensor

### Adding or enrolling a new fingerprint

You can add a new fingerprint to the system by using the command
`/fingerprint enroll {alias}` in Mattermost (don't ask me why I called it
enroll, I forgot).

Upon asking to enroll a new fingerprint the sensor will go into "enroll mode",
whereupon its LED will slowly blink blue. Once the sensor then detects a
finger, it will generate a feature map for it, succesfull completion of which
is indicated by the LED rapidly blinking blue. You must then place your finger
on the sensor again to make a second feature map so the sensor can ensure the
first one was accurate.

If both of these steps succeed the fingerprint will be stored and can be used
to open the door. <br/>
If any steps fail you will need to repeat the enroll command and try again.

### Deleting a fingerprint

You may delete any of your fingerprints by issuing the
`/fingerprint delete {alias}` command.

Admins may delete others' fingerprints and can do so using
`/fingerprint delete {user} {alias}`.

### Listing all your fingerprints

You can get an overview of the fingerprints you have enrolled using
`/fingerprint list`.

Admins will be able to see all fingerprints.

## A Note On Privacy

While the fingerprint sensor can export images of fingerprints, it can only do
so for whatever finger is currently on the sensor, not for fingerprint
feature maps it has stored internally. And even then, this feature is not even
implemented in the C library (smh adafruit).

The only data transmitted between the fingerprint sensor and the ESP is the
internal ID of whatever fingerprint it detects, or a simple status code to
indicate if an operation succeeded or failed. There is no way to get an image
of some users fingerprint from the sensor without writing some new code and
making them place their finger on it.
