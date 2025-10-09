---
title: "Recently"
date: 2020-10-27T23:30:46-0400
lastmod: 2020-10-27T23:30:46-0400
slug: recently-44
excerpt: "I've written a few small tools over the last couple months and I figured it's time I post about them."
---

I've published a few new projects in the last couple of months and I'm behind on announcing them, so I bundled them up together into this post. I'm stealing the title format of this post from [Tom MacWright's](https://macwright.com/) Recently posts.

One thing to note is that the source code for all these projects is stored on [sourcehut](https://sourcehut.org/). Sourcehut (or sr.ht) bills itself as "the hacker's forge". I highly recommend checking it out. It's also where I host [my public inbox](https://lists.sr.ht/~asimpson/public-inbox).

## hover-dns
Now that I have fiber internet at the house I've been hosting one-off services and apps on my own hardware at the house. This is great, however my residential connection is a typical dynamic IP not a static one. Instead of using a service like [DynamicDNS](https://account.dyn.com/) I decided to write some Rust (shocker) and leverage the "unofficial" Hover API. The result is: [hover-dns](https://git.sr.ht/~asimpson/hover-dns).

I have `hover-dns` running in a crontab for a few different domains to keep my domains pointed to the correct IP for my house. While I'm a little uncomfortable with how similar `npm` and `cargo` can feel, the [`trust-dns`](https://docs.rs/trust-dns-resolver) package is _excellent_. I was able to quickly read the source code to understand how to setup a `Resolver` for [opendns](https://www.opendns.com/). Also impressive is that `hover-dns ip` beats out `dig` in returning your public IP. I didn't expect that!

## podcastfilter
Speaking of hosting things at home, [podcastfilter.com](https://podcastfilter.com) is one of those things. [podcast-filter is a small Go project](https://git.sr.ht/~asimpson/podcast-filter) that allows you to filter a podcast feed by each episode's description and return a feed of just those episodes that match.

## mailpreview
The recent project I use the most day-to-day is [mailpreview-cli](https://git.sr.ht/~asimpson/mailpreview-cli). `mailpreview-cli` is very straight-forward, it accepts a Mail message and returns either the plain text version or the html version of that message. The reason I don't just pull the Mail message directly is because a Mail message can contain several versions of the message in different encodings (start here if you're curious: [RFC-822](https://tools.ietf.org/html/rfc822)). Instead of writing my own parser I grabbed the excellent [mailparse crate](https://docs.rs/mailparse/) and wrapped the behavior I wanted around it. On it's own `mailpreview-cli` isn't super fancy but I trigger it from `rofi` via a [shell script](https://github.com/asimpson/dotfiles/blob/master/linux/mail-preview) which allows me to browse (and then view) all my unread emails right from `rofi`. Shameless plug: I wrote a short post about [getting started with `rofi`](https://adamsimpson.net/writing/getting-started-with-rofi) if you're unfamiliar. `mailpreview-cli` could be used with [Alfred](https://www.alfredapp.com/) if you're on a Mac to accomplish the same thing as I'm doing with a shell script and `rofi`.

Fin
