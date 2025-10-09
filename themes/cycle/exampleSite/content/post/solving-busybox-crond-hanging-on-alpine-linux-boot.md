---
title: "Solving busybox crond hanging on Alpine Linux boot"
date: 2019-05-05T14:13:02-0400
lastmod: 2019-05-05T14:13:02-0400
slug: solving-busybox-crond-hanging-on-alpine-linux-boot
excerpt: "How busybox crond hanging at startup sent me down a rabbit hole where I learned about entropy and Linux."
---

I recently clean installed [Alpine Linux 3.9.3](https://alpinelinux.org/posts/Alpine-3.9.0-released.html) on my home router (more to come on that in a future post) and ran into a weird bug. Once I successfully installed Alpine and rebooted, the system would start and then hang for over a half hour(!) with the message "Starting busybox crond...". I tried downgrading to 3.8.0 without any luck. I did some quick Googling and didn't find anything about busybox crond hanging.

Stumped I headed over to the [`#alpine-linux` IRC](https://www.alpinelinux.org/community/) and posted my situation there. A friendly user suggested it might have something to do with "entropy changes" and to switch the daemons in question to use `/dev/urandom`. I didn't feel like switching the daemons was going to be a good long-term solution but I was intrigued by the entropy angle. I looked it up and stumbled upon this reply to a [bug thread](http://lists.alpinelinux.org/alpine-user/0605.html) about "Startup hangs (aports: sshd?)":

>
> > Hello.
> >
> > After upgrading to [edge] i see a possibly endless hang upon
> > startup, which seems to be caused by PRNG init.
>
> Try add `random.trust_cpu=1` as boot option.
>
> See:
> <https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-4.19.y&id=39a8883a2b989d1d21bd8dd99f5557f0c5e89694>
>
> and:
> <https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-4.19.y&id=9b25436662d5fb4c66eb527ead53cab15f596ee0>
>
> -nc

Interesting. Entropy and boot time *are* related. Remember I had installed Alpine on a router: a *headless* PC without any I/O other than two Ethernet NICs and a SSD. Not much there for Linux to generate entropy with, especially since the default was to *not* trust my CPU.

I searched for entropy on the excellent Alpine wiki and found [this page](https://wiki.alpinelinux.org/wiki/Entropy_and_randomness). This lead me to [Haveged](https://wiki.alpinelinux.org/wiki/Entropy_and_randomness#Haveged). [Haveged](https://issihosts.com/haveged/) is a service that [generates additional entropy](https://opium.io/blog/haveged/). I stared it up, enabled it to run at boot, and I no longer had any hang time at boot!

I later found [this bug report](https://bugs.alpinelinux.org/issues/9960) that outlined my problem exactly. Turns out I was too focused on the `crond` aspect of my boot problem and not the general delay in booting. Oh well, TIL.
