---
title: A multi-program programmable LED strip
created_at: 14-11-2021
author: "Jasper Devreker"
---

## TL;DR

<video controls>
    <source src="https://zeus.ugent.be/zeuswpi/ledstrip.mp4"
            type="video/mp4">
</video>


## About

We recently bought some RGB LED strips to hang in the Zeus WPI space. Each of the LEDs (WS2812)
in these LED strips can be controlled individually. This makes it possible to display animations on
the LED strips. A popular open-source program to do this with is [WLED](https://github.com/Aircoookie/WLED):
a C++ program that runs on the popular ESP8266-family of microcontrollers.

We used WLED to drive our LED strip for a while. But we felt limited by
the API of WLED: WLED has the option to programatically set the animation or color, but it
didn't really have a proper way to set individual LEDs, let alone have multiple separate
programs take control of different parts of the LED strip. Our goal was to allow our
members to start write code that displayed various things on the LED strip; for example
the status of the CO₂-sensor or some scrolling morse when messages get sent to the space.

When talking about this with friends in Zeus, we got the idea to
host a basic programming workshop involving the LED strip on the freshman introduction
day: that way the new students could have a taste what Zeus is all about.

In the days leading up to the introduction day, we designed and programmed a program which would
split the LED strip into multiple segments and then hand control of each segment to a different Lua interpreter.
We chose Lua as the scripting language because it is easy to embed in C++ programs.

The initial basic structure of the program looks like this: ![An HTTP server controlling multiple LUA interpreters, which in turn control a WS2811 LED storage object](https://zeus.ugent.be/zeuswpi/basic-architecture-new.png)

Every rectangle in the diagram is a separate thread. When a user uploads new code to the HTTP server, the Lua interpreter is restarted with the new code. The Lua interpreters have [several functions](https://www.lua.org/pil/26.html) that allow them to interact with the LED strip and the outside world. Apart from these functions, they shouldn't be able to do any IO (at least if the sandbox works properly).

Here's some example Lua code that can run on the LED strip:


<pre><code>#!lua
function set_all_leds(red, green, blue)
  for idx=1,ledamount() do
    led(idx, red, green, blue) -- this will call native code
  end
end

while true do
  set_all_leds(255, 0, 0) -- red
  delay(1000)
  set_all_leds(0, 255, 0) -- green
  delay(1000)
end
</code></pre>

## Functionality

Users can select a segment of the LED strip to program via the web interface. They can then read and modify the Lua source code that is running on the segment.

### Hardware

The program runs on an old Raspberry Pi 1B we had laying around.

### Isolation

The Lua programs are isolated, both from the underlying host system as from each other. Programs call the function `led(index, red, green, blue)` where the index is relative to the start of the strip. Programs running on a segment can only set LEDs on the segment they are running on. For example; if there are 2 segments in a
60 LED LED strip, running `led(1, 255, 0, 0)` on the first segment will turn the first LED red. Running the same code on the second segment will turn the thirty-first led red.

### Input/output

The Lua programs can interact with the outside world via functions we add to the interpreter. In addition to the earlier discussed `led`-function, we also added a way to send messages to running programs.

- `led(index, red, green, blue)`: sets the led on relative `index` to `red`, `green`, `blue`
- `subscribe(topic)`: subscribes for messages with a certain `topic`
- `unsubscribe(topic)`: unsubscribes for messages with a certain `topic`
- `message = get_message(topic)`: gets a message from the queue with a certain `topic`. If there are no messages with that `topic`, `message` is nil.
- `delay(ms)`: waits `ms` milliseconds
- `waitframes(num)`: waits until `num` frames have rendered

### Refactor

After using the framework for a while, we noticed two big limitations:

- only Lua is supported as a language
- to develop both the framework and programs, you need the physical LED strip. Compiling the source code on the Pi takes about 10 minutes, so this is far from ideal. Also, when developing the framework, only one person can develop at a time.

We fixed this by leveraging object-oriented programming: instead of hardcoding every Lua detail, we abstract it into an abstract `Language` class. Every class that inherits `Language` will need to implement certain functions. That way, we can easily swap out Lua for another language and even have different segments run different programming languages.

To fix the problem that we need the hardware to develop the framework, we take a similar approach: we extract the code interacting with the LED strip hardware into a `LedstripLanguageBackend` class that inherits from a generic `LanguageBackend` class. Now it is possible to implement another subclass of `LanguageBackend` that is a drop-in replacement for `LedstripLanguageBackend`. An example of this could be a class that displays the status of the LEDs in a window.

![An HTTP server controlling Language objects each having a LanguageBackend, which can be a real LED strip or something else.](https://zeus.ugent.be/zeuswpi/architecture-refactored.png)

### Logging

If a program doesn't behave as you'd expect it, so called "printf-debugging" can be really useful, just as getting a stacktrace when your program crashes. To facilitate this, we also built a logger, so now it's possible to access the output and stacktraces of programs in the web interface.

## Review and feedback

The workshop on the new students' introduction day was a success: multiple first year students wrote some code that displayed animations. At the time of the introduction, logging didn't work yet, which resulted in some frustration because of the hidden state of programs that didn't do exactly what people thought they would do. It certainly didn't help that Lua, compared to other programming languages, takes different approaches to syntax and conventions (for example, Lua "arrays" start at index 1. Actually, arrays don't exist in Lua, everything is a map, arrays are maps from indices to values).

After the workshop, several people played with the LED strip in our space. We currently have a few programs running:

- A rainbow-colored morse messageing system
- An indication of the CO₂-concentration (pretty important during the coronavirus pandemic)
- A one-dimensional game of Pong (still in progress)

And there are several idea's:

- Displaying Zeus server health, one LED per system
- Displaying Mattermost "online"-status
- ...
