---
title: "On Polybar bitmap fonts and Ubuntu"
date: 2020-11-06T10:15:09-05:00
lastmod: 2020-11-06T10:15:09-05:00
slug: polybar-fonts-and-ubuntu
excerpt: "Enable bitmap fonts on Ubuntu for an optimal polybar experience."
---

I use [polybar](https://polybar.github.io/) as my status bar in i3 and it's been going great for months now. However, I was recently grepping through the `syslog` trying to figure out why a browser crash happened and the log was filled with polybar spam that looked like this: `polybar|warn:  Dropping unmatched character`. So I started picking at solving the warning.

Turns out there's a [Github issue](https://github.com/polybar/polybar/issues/392#issuecomment-310778138) that contains the solution which is to enable bitmap fonts which I'll paste here for posterity:

``` shell
# "Un-disable" bitmap fonts
sudo rm /etc/fonts/conf.d/70-no-bitmaps.conf
# Clear the font cache
sudo fc-cache -f -v
```

Apparently Ubuntu disables bitmap fonts by default but polybar uses bitmap fonts for icon rendering. I also needed to install the [sijj icon font family](https://github.com/stark/siji) which was painless.
