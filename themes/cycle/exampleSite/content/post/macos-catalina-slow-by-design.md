---
title: "macOS 10.15: Slow by Design"
date: 2020-05-28T21:22:03-04:00
lastmod: 2020-05-28T21:22:03-04:00
slug: macos-catalina-slow-by-design
excerpt: ""
link: "https://sigpipe.macromates.com/2020/macos-catalina-slow-by-design/"
---

A few days ago [Allan Odgaard](https://sigpipe.macromates.com/) wrote up the reasons for the frequent slowdowns he's experiencing in macOS Catalina and it's shocking:

> Apple has introduced notarization, setting aside the inconvenience this brings to us developers, it also results in a degraded user experience, as the first time a user runs a new executable, Apple delays execution while waiting for a reply from their server. This check for me takes close to a second.

> This is not just for files downloaded from the internet, nor is it only when you launch them via Finder, this is everything. So even if you write a one line shell script and run it in a terminal, you will get a delay!

> I am writing this post to call attention to what I consider a serious design problem with Apple’s most recent OS where it appears that low-level system API such as `exec` and `getxattr` now do synchronous network activity before returning to the caller.

[Marco Arment](https://marco.org/) hit the nail on the head with [his tweet summary of the post](https://twitter.com/marcoarment/status/1263855479668834304):

> The macOS security team needs to ask themselves hard questions about their implementation choices when very smart people are disabling huge parts of their OS security layer just to get reasonable performance from common tasks.
