---
title: "Getting started with Rofi"
date: 2020-05-28T13:35:15-04:00
lastmod: 2020-05-28T13:35:15-04:00
slug: getting-started-with-rofi
excerpt: "I've been using Rofi for about a year but didn't really understand how to write my own scripts for it until recently. In this post I explain what dmenu is and Rofi's implementation of it and also show how to change audio inputs on Linux via pactl."
---

[Rofi is a Linux app](https://github.com/davatorium/rofi) that is a:

> [..] window switcher, application launcher and dmenu replacement

I've been using Rofi for about a year but didn't really understand how to write my own scripts for it until recently.

## dmenu? Huh?
A key to my lack of apprecaition for Rofi's feature set was that I didn't understand why it billed itself as a "dmenu replacement". What the heck is [`dmenu`](https://tools.suckless.org/dmenu/)?

> dmenu is a fast and lightweight dynamic menu for X. **It reads arbitrary text from stdin, and creates a menu with one item for each line. The user can then select an item, through the arrow keys or typing a part of the name, and the line is printed to stdout**. (emphasis mine)

Essentially `dmenu` lets you create and present your own menu and then act once a menu item is selected by the user. One of my favorite applications of all time is [Alfred](https://www.alfredapp.com/workflows/), the infinitely customizable launcher utility for macOS. The best part about Alfred was [Workflows](https://www.alfredapp.com/workflows/) which (like dmenu) allow you to create custom menus and actions as part of the main launcher interface. How do we create a menu though?

## STDIN STDOUT
`dmenu` will display whatever comes in on `STDIN` as the menu, e.g. `echo "foo\nbar" | dmenu"` (if you have a Linux install available install `dmenu` and give that command a try). Each new line in `STDIN` becomes a new line in the `dmenu` menu. The previous command creates a menu with two options: `foo` and `bar`. Once the user hits enter on a menu item the value of the selected item gets sent to `STDOUT`. That's it. `dmenu` reads in from `STDIN` and prints out selections to `STDOUT`. `dmenu` is super handy to add to workflows and scripts to give them a bit of UI. You can squeeze `dmenu` anywhere you need feedback from the user, e.g.: `echo "Hello $(echo 'World\nPeople' | dmenu)"`. This prints a hello world message after the users chooses "World" or "People" from `dmenu`.

## Rofi + dmenu
Rofi adds `dmenu` capability _plus_ lots of other things like selecting open windows, running ssh commands etc. To enable `dmenu` mode in Rofi pass it as an option `-dmenu`. Let's port our previous example code snippet to Rofi: `echo "foo\nbar" | rofi -dmenu`. Easy enough! With the `dmenu` option Rofi becomes just as useful as Alfred and makes me think Alfred should gain a command line option to pop open Alfred from within scripts like dmenu or Rofi.

## My first script
The motivation to write this post came a couple weeks ago when I wrote my first real Rofi script. I use [Pop_OS!](https://pop.system76.com/) as my Linux distribution of choice for work and the defaults are _really good_. However when I want to change my audio output (headphones or external speakers) I've grown annoyed by having to manually mouse up to the menubar and select the desired output. I set out to write a Rofi script to handle changing the audio output. On Linux you can control everything related to the audio system via the `pactl` utility. The pieces of data I needed for my script were:

- A list of all available outputs to generate my Rofi menu
- A way to change to the selected output

`pactl list sinks` displays all active "sinks" or available outputs ("Sinks" is the Linux audio system term for outputs). We can customize this a bit further wih `pactl list short sinks` which will cram relevant sink information into one line each instead of multiple lines per sink. This makes parsing the output much easier.

Now that I had a list of available speakers/headphones on the system I needed to change to that output. This turned out to be a two step process because of how the audio system works:

1. `pactl move-sink-input INPUT SINK` moves anything currently playing to the specified speaker/headphone.
2. `pactl set-default-sink SINK` sets the specified speaker/headphones as the default output going forward, e.g. launching a video call or playing a video.

To accomplish #1 I needed to get the currently playing input which can be done via: `pactl list sink-inputs`. Again we can specify `short` to get the relevant information on a single line: `pactl list short sink-inputs`.

The finished script looks like this:

```shell
#!/bin/bash

source="$(pactl list short sinks | cut -f 2 | rofi -dpi 1 -dmenu -p "Change audio:")";
inputs="$(pactl list sink-inputs short | cut -f 1)";

for input in $inputs; do
  pactl move-sink-input "$input" "$source";
done

pactl set-default-sink "$source";
```

Upon invoking the script, Rofi presents me with a menu that contains all the available outputs. Once I select one the audio changes instantly.

<figure class="bg-orange pa2">
   <video muted loop playsinline controls preload="metadata" poster="/images/rofi-change-audio.jpg">
      <source src="/videos/rofi-change-audio.mp4" type="video/mp4">
      <source src="/videos/rofi-change-audio.webm" type="video/webm">
      <a href="/videos/rofi-change-audio.mp4">Download MP4</a>
   </video>
   <figcaption class="black-90 i">Video showing the change-audio script running via Rofi.</figcaption>
</figure>

## Conclusion
I find Rofi so useful that I have a system-wide hotkey that invokes Rofi as a general launcher like this: `rofi -combi-modi run,window,drun -show combi -modi combi -dpi 1`. The flags I'm using are documented under "Combi settings" in the Rofi manpage.

Rofi transforms otherwise vanilla shell scripts into poweful transient workflows that allow me to control aspects of my machine without leaving whatever I'm currently working on. It's become an essential part of my toolbox.
