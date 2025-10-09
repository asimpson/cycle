---
title: "Clear explanation of Rust’s module system"
date: 2020-07-19T23:52:26-04:00
lastmod: 2020-07-19T23:52:26-04:00
slug: rust-module-system
excerpt: ""
link: "http://www.sheshbabu.com/posts/rust-module-system/"
---

This is a _great_ explanation of Rust's module system. I wish I had this clear of a picture when I was using modules for the first time in creating [`oscar`](https://github.com/asimpson/oscar).

The big takeaway and deviation from `npm` is this:

> We need to explicitly build the module tree in Rust, there’s no implicit mapping to file system.
