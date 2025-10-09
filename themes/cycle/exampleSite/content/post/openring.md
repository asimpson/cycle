---
title: "Openring"
date: 2020-08-21T16:09:44-04:00
lastmod: 2020-08-21T16:09:44-04:00
slug: openring
excerpt: "I've added Drew DeVault's openring project to the blog."
---

I've added Drew DeVault's [openring project](https://git.sr.ht/~sircmpwn/openring) to the blog. `openring` is a nice utility (written in Golang) that parses RSS feeds and generates an HTML template file to include on your website. I love things that utilize RSS feeds and things that make indie sites better and `openring` does both! Thanks to Drew for the tool.

It was pretty easy to integrate into my build system. I added a new `Makefile` task that looks like this:

```make
openring.mustache:
	./bin/openring \
	-s https://drewdevault.com/feed.xml \
	-s https://fasterthanli.me/index.xml \
	-s https://endler.dev/rss.xml \
	-s https://inessential.com/xml/rss.xml \
	-s https://www.bryanbraun.com/rss.xml \
	< openring.html \
	> ./templates/partials/openring.mustache
```

I then added this new task as a dependency on my build/generate step and I was done.

You can view my [template file here](https://github.com/asimpson/blog/blob/master/openring.html).

I also added the `openring` binary directly to the repo. It's not pretty but it beats compiling the binary every time my site deploys (Note: I do pull down a new [`cycle`](https://github.com/asimpson/cycle) binary every time the site deploys but I can control that flow whereas I can't control where `openring` builds.)

For now I'm only displaying my `openring` on the home page of the blog but if folks think it would be useful on other pages (like this post page) shoot me a message in my public inbox (link below).
