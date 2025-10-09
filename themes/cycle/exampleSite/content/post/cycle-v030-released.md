---
title: "cycle v0.3.0 released"
date: 2020-09-11T12:04:16-0400
lastmod: 2020-09-11T12:04:16-0400
slug: cycle-v030-released
excerpt: "Cycle version v0.3.0 is now available which features syntax highlighting via Chroma."
---

I just released [v0.3.0 of `cycle`](https://github.com/asimpson/cycle/releases/tag/v0.3.0).

This version uses [Chroma](https://github.com/alecthomas/chroma/) for syntax highlighting instead of [Pygments](https://pygments.org/). I never got Pygments running correctly in [Netlify's build](https://docs.netlify.com/configure-builds/get-started/) environment. Chroma requires no dependencies since it's distributed as a static binary and it's also faster due to being written in [golang](https://golang.org/).

This version also refactors the `main` function to accept an optional working directory arg. This allows me to build a site via the CL REPL. It also shortens the feedback loop to try out new features.
