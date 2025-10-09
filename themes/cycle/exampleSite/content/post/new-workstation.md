---
title: "New workstation"
date: 2022-05-02T18:14:25
lastmod: 2022-05-02T18:14:25
slug: new-workstation
excerpt: "I detail my new workstation build featuring the Intel i5-12600k."
---

[New job](/writing/goodbye-sparkbox) means time for a new workstation.

## Some history
The first computer I ever purchased was the [12" Powerbook G4](https://everymac.com/systems/apple/powerbook_g4/specs/powerbook_g4_1.5_12.html). Since that Powerbook I've always had laptops as my main machines (desktop gaming PC not withstanding). Remote working the last few years has made me realize that the portability of a laptop is largely wasted since I only travel a handful of times a year and yet I live with the downsides of a laptop the rest of the time. So, last year I started thinking about a desktop machine for my primary workstation. A desktop is appealing for a handful of reasons:


- More powerful CPUs
- More expansion capabilities
- More durable

## The options
The [Mac Studio](https://www.apple.com/mac-studio/) was recently released to much fanfare and was really intriguing to me. However, when I started considering it I only had about a week to 10 days before my start date at [Grafana](https://grafana.com) and I couldn't wait the quoted 4-6 weeks delivery time for a Mac Studio with 32GB of RAM.

I was also pretty unwilling to leave my comfy [NixOS](https://nixos.org) install + [i3](https://i3wm.org/). [Michael Stapelberg's latest post](https://michael.stapelberg.ch/posts/2022-01-15-high-end-linux-pc/) about his new workstation proved timely and convinced me to give the new Intel Alder Lake CPUs a shot.

Apple's M1 family of chips deliver incredible performance per watt but I wasn't as concered about the power usage given this was a desktop machine not a laptop. I was however focused on at least matching the M1 chips in single-threaded performance since a good chunk of my development work (Node, build tools, etc) are still single-threaded. I ended up with the Intel i5-12600k and I really couldn't be happier. Here's the full parts list:

<table style="margin-bottom: 1rem;">
<thead>
<tr>
<th style="text-align: left;">Part</th>
<th>Price</th>
</tr>
</thead>
<tbody>
<tr>
<td><a href="https://www.amazon.com/Intel-i5-12600K-Desktop-Processor-Unlocked/dp/B09FX4D72T" rel="nofollow">i5-12600k</a></td>
<td>$278</td>
</tr>
<tr>
<td><a href="https://www.sliger.com/products/cases/cerberus/" rel="nofollow">Sliger Cerberus case</a></td>
<td>$285</td>
</tr>
<tr>
<td><a href="https://www.amazon.com/Noctua-NF-A14-PWM-Premium-Cooling/dp/B00CP6QLY6" rel="nofollow">140mm Noctua NF-A14 PWM</a></td>
<td>$21</td>
</tr>
<tr>
<td><a href="https://www.amazon.com/Noctua-NH-C14S-Premium-Cooler-NF-A14/dp/B00XUV3JTK" rel="nofollow">Noctua NH-C14S</a></td>
<td>$85</td>
</tr>
<tr>
<td><a href="https://www.amazon.com/Sabrent-Internal-Extreme-Performance-SB-ROCKET-NVMe4-1TB/dp/B07TLYWMYW" rel="nofollow">Sabrent 1TB Rocket NVMe</a></td>
<td>$130</td>
</tr>
<tr>
<td><a href="https://www.amazon.com/CORSAIR-SF600-Modular-Supply-Certified/dp/B01CGI5M24" rel="nofollow">Corsair SF600</a></td>
<td>$130</td>
</tr>
<tr>
<td><a href="https://www.amazon.com/ASUS-ROG-Z690-G-motherboard-Thunderbolt/dp/B09JRVXRJC" rel="nofollow">ASUS ROG Strix Z690-G</a></td>
<td>$350</td>
</tr>
<tr>
<td><a href="https://www.amazon.com/G-Skill-Trident-PC5-48000-CL36-36-36-96-F5-6000J3636F16GA2-TZ5K/dp/B09PTS2NMZ/" rel="nofollow">G.SKILL Trident Z5 Series 32GB DDR5</a></td>
<td>$330</td>
</tr>
</tbody>
</table>


## XMP issues
I ran into the same memory XMP issues that Michael mentions in his post so I disabled the XMP profile and the system passed the "[Coding Horror burn in tests](https://blog.codinghorror.com/is-your-computer-stable/)" with flying colors.

## Cooling
I mounted the 140mm fan to the bottom of the case as intake and the CPU cooler is of course positioned as intake as well. Hot air rises out the top of the case quite well. During the prime95 torture test the CPU never got over 78°C and I couldn't ever hear either fan. I run both fans in the "silent profile" in the BIOS and I use [Noctua's adapters](https://noctua.at/en/na-src7) to lower the voltage even more. Now the only fan I could hear during max load was the PSU fan which doesn't spin at all under low to medium loads but under high load it kicks on. Day to day it's hardly on so the system is dead quiet most of the time.

## Case
I absolutely love the Cerberus case. It's Mini-ATX but still super compact and fits on my desk quite well. All the panels are solid metal and the way all the panels pop off is really really nice. I opted for the handle mount on the top and the internal PSU moutning.

## Linux
NixOS [installed just fine](https://github.com/asimpson/dotfiles/blob/master/nixos/fin/configuration.nix). I'm runing the 5.17 kernel because Alder Lake needs a newer kernel for it's graphics and CPU scheduler (coming soon?). I have WiFi and Bluetooh disabled in the BIOS since everything is hard-wired to the machine.

## Verdict
This build has proven quite comfortable over the few weeks I've used it. I love that I have 2 free RAM slots if I ever feel the need for more RAM. I also love that I have 3 remaining Nvme slots on the motherboard for additional solid state storage in the future.
