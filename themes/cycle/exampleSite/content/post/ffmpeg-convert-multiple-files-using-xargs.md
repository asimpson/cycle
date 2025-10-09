---
title: "FFMPEG: Convert multiple files using xargs"
date: 2020-06-04T14:43:26-04:00
lastmod: 2020-06-04T14:43:26-04:00
slug: ffmpeg-convert-multiple-files-using-xargs
excerpt: ""
link: "https://webcache.googleusercontent.com/search?q=cache:53fkpNAjK8UJ:https://www.joshcurry.co.uk/posts/ffmpeg-convert-multiple-files-using-xargs+&cd=1&hl=en&ct=clnk&gl=us"
---

I stumbled [upon this post](https://www.joshcurry.co.uk/posts/ffmpeg-convert-multiple-files-using-xargs/) ([Google cache link](https://webcache.googleusercontent.com/search?q=cache:53fkpNAjK8UJ:https://www.joshcurry.co.uk/posts/ffmpeg-convert-multiple-files-using-xargs+&cd=1&hl=en&ct=clnk&gl=us)) when I was trying to process multiple files via `xargs`.

> `ls *.webm | xargs -I % ffmpeg -i % %.m4a`

> The key part of this one-liner is xargs `-i %`. This means that each line of STDIN passed to xargs is put into a variable and can be referenced as `%`. Hence, the following text which specifies `ffmpeg -i x.webm x.m4a` to make it convert.
