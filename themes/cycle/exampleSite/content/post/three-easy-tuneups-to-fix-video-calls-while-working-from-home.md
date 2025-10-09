---
title: "Three easy tuneups to fix video calls while working from home"
date: 2020-03-17T16:59:34-04:00
lastmod: 2020-03-17T16:59:34-04:00
slug: three-easy-tuneups-to-fix-video-calls-while-working-from-home
excerpt: "In light of COVID-19 and lots of folks working from home, I've written down the three things I try to tune on my home network to deliver the best possible video call experience."
---

Thanks to the COVID-19 virus (aka the coronavirus) lots of folks are experiencing the joys and existential terror of working from home. There's many things to tackle when optimizing a work from home setup like:

-   Proper workspace ergonomics
-   Proper lighting for video calls
-   [Proper audio](/writing/atr2100) for video/audio calls
-   Picking up the dirty laundry/toys/pizza boxes that are visible in the background on video calls

These are all important but pale in comparison to this one: tuning your network for peak performance in video calls and remote screen sharing.


## Three problems

There is usually some combination of the following three problems going on when [Zoom](https://zoom.us/) pops up the dreaded "Your connection is unstable":

1.  Your internet speed is too slow
2.  You're Wifi signal is bad
3.  Your router/modem from the ISP is suffering from bufferbloat.


### Speed

The first one is *easy* to fix: speed. Zoom lists their [bandwidth requirements](https://support.zoom.us/hc/en-us/articles/201362023-System-Requirements-for-PC-Mac-and-Linux) and the highest requirement is `3.0 Mbps` (up/down) which is for sending 1080p video. For consumer broadband that is nothing, heck for DSL that's nothing. However, it's the first and easiest thing to check: do you have `3.0 Mbps+`? Head over to [fast.com](https://fast.com) and run a speed test.

### Wifi

The second one, wifi signal strength, is more difficult to nail down. I check two things: the connection bit rate and the connection frequency. Bit rate will tell you the speed of the connection; it should be above `3 Mbps` (honestly it should be above `100 Mbps` if you have ac wifi). I also *always* choose to connect to the `5Ghz` band if I can. `2.4Ghz` suffers from interference much more so than `5Ghz` and that interference will result in an unstable connection. An easy check to see if your Wifi is causing the problem, connect directly to the router with an Ethernet cord if you have one. If the problems goes away, it's the wifi if not keep reading. To view connection and bitrate on a Mac: Option + click on the WiFi icon and you'll be able to see the bit rate and connection frequency. On Linux `iwconfig` in the terminal will print the relevant info.

### Bufferbloat

A *very* long explanation (and solution) of bufferbloat can be found [here](https://apenwarr.ca/log/?m=201808). The gist of it is that most routers/modems are (mis-)configured out of the box to prioritize speed over everything else. The software will stuff as many packets as it can and then once it's full things start getting laggy. To see if you are suffering from bufferbloat head over to [fast.com](https://fast.com) again and click on the "Show more info" button after the test. You want the difference between "loaded" and "unloaded" to be as small as possible. If you see a difference over 100, e.g. 25 unloaded and 150 loaded, you are probably suffering from bufferbloat.

![](/images/fast-com-latency.png)

The solution here is to poke around in your modem/router admin interface and look for something like "QoS" or "Codel" settings. QoS stands for Quality of Service and it typically allows you to either setup device prioritization or better yet implement [`fq_codel`](https://www.bufferbloat.net/projects/codel/wiki/). The beauty of `fq_codel` is that it's pretty transparent to everyone on the network. Kiddos can stream Frozen 2 until their eyes bleed and your Zoom will never stutter. Device prioritization QoS works but other devices on the network feel the squeeze.

If you're modem/router doesn't have QoS settings then it's time to look into buying some new equipment (or yes flash your existing router with [OpenWRT](https://openwrt.org/) but that's outside the scope of this post). If you already have your own router/wifi, *that is separate from your modem*, then I'd recommend picking up a [Ubiquiti EdgeRouter X](https://www.ui.com/edgemax/edgerouter-x/) and placing that between your modem and your existing router/wifi. The EdgeRouter X has built-in support for [`fq_codel`](https://www.bufferbloat.net/projects/codel/wiki/) as a QoS setting. Adding QoS at any point in the chain between your computer and the public internet will fix bufferbloat as the traffic only needs to be shaped once.

![](/images/bufferbloat.png)

Addressing the three primary culprits for unstable connections should dramatically improve your conference call experience. Please reach out if you have questions or I was incorrect about anything. I'll  try to respond as quickly as I can.
