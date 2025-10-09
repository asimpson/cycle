---
title: "Introducing oscar"
date: 2020-04-29T16:21:17-04:00
lastmod: 2020-04-29T16:21:17-04:00
slug: oscar
excerpt: "I've been working on oscar which is a small command-line utility written in Rust that polls the pbskids.org API for new episodes of any PBS show."
---

I've been working on a small command-line utility written in [Rust](https://www.rust-lang.org/ "Link to rust-lang website") called [`oscar`](https://github.com/asimpson/oscar). `oscar` polls the pbskids.org API for new episodes of any PBS show. If it finds an episode it hasn't seen before it downloads the episode to the specified directory.

I run `oscar` via the `cron` scheduler on my home server and over the past few months it's been largely invisible and maintenance-free. Whenever new episodes show up, `oscar` downloads them and my 3 year-old can stream it on any of the devices in the house via [Plex](https://www.plex.tv/) or [Infuse](https://firecore.com/infuse).


To get started I recommend pulling down the [latest release from Github](https://github.com/asimpson/oscar/releases "Link to Github release for oscar") (if it's not broken) or building locally via `cargo build --release`. To view the available shows run `oscar list`. Once you have found a show tell `oscar` to find episodes by invoking it with the `--show-slug` option and the destination directory option like: `oscar --show-slug SHOW_SLUG --output /path/to/video/folder`.
