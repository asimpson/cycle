---
title: "A firewall in 8 lines"
date: 2021-03-31T11:18:24-04:00
lastmod: 2021-03-31T11:18:24-04:00
slug: 8-line-firewall
excerpt: "You only need about 8 lines in iptables to have a great home firewall."
---

Since 2017 my home router has been a [plain x86 box](https://ark.intel.com/content/www/us/en/ark/products/95597/intel-celeron-processor-j3355-2m-cache-up-to-2-5-ghz.html) running Alpine Linux. I never really think about it anymore. Recently, I was helping a relative set up their own Linux-based router and took the time to appreciate how little config is needed to setup a serviceable home router firewall using `iptables`. You can see my base rule-sets (port forwarding omitted) below:

```
-P INPUT DROP
-P FORWARD DROP
-P OUTPUT ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -i eth1 -j ACCEPT
-A INPUT -i eth0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A FORWARD -i eth1 -o eth0 -j ACCEPT
-A FORWARD -i eth0 -o eth1 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
```

The benefit of running a x86 box with Alpine (or any version of Linux) is that the box will receive a steady stream of security updates and upgraded kernels as Alpine Linux releases new versions. This is a much better situation to be in than relying on OS and security updates from a vendor like TPLink or Linksys.

If you have ideas for how to improve the config I listed above or want to chat more about home network stuff, send an email to my [public-inbox](https://lists.sr.ht/~asimpson/public-inbox).
