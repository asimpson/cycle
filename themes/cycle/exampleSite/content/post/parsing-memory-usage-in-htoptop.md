---
title: "Parsing memory usage in htop/top"
date: 2015-10-04T09:06:46-04:00
lastmod: 2015-10-04T09:07:37-04:00
slug: parsing-memory-usage-in-htoptop
excerpt: "I've been trying to figure out how much memory a node app is using on my VPS, and I've found output from top or htop to be overwhelming."
---

I've been trying to figure out how much memory a node app is using on my VPS, and output from `top` or `htop` is fairly overwhelming. In searching around I found [Mugurel Sumanariu's post](http://mugurel.sumanariu.ro/linux/the-difference-among-virt-res-and-shr-in-top-output/) clearly explaining each column related to memory usage.

The column I should be paying attention to is `RES`, which

> \[..\] stands for the resident size, which is an accurate representation of how much actual physical memory a process is consuming. (This also corresponds directly to the %MEM column.)
