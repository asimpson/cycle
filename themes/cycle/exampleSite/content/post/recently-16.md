---
title: "Recently"
date: 2021-04-23T11:37:19-04:00
lastmod: 2021-04-23T11:37:19-04:00
slug: recently-16
excerpt: "A random assortment of links and miscellaneous updates on things."
---

I'm stealing the title format of this post from [Tom MacWright's](https://macwright.com/) Recently posts.

Here's a random assortment of links and miscellaneous updates on things.

## autofs
[autofs](https://help.ubuntu.com/community/Autofs) is a cool utility that watches a specific directory path and when a program tries to read or write to that path it mounts a filesystem at that location. I'm using this to auto mount my NAS via SMB for [mpd](https://www.musicpd.org). With autofs in place I can run mpd locally (in a ["satellite setup"](https://www.musicpd.org/doc/html/user.html#satellite-setup)) and have its `music_directory` point to a path managed by autofs.

One thing that was helpful getting the configuration right was testing autofs by running `automount -f -v` directly which puts it in the foreground and gives verbose output.

The two files I configured were `auto.master.d/foo.autofs` and `auto.foo`.

- **foo.autofs** contains one line: `/- /etc/auto.foo`
- **auto.foo** contains one line as well: `/foo -fstype=cifs,rw,credentials=/home/me/.foo-creds ://NAS.IP/foo`

## mailpreview updates
[mailpreview-cli](https://git.sr.ht/~asimpson/mailpreview-cli) is a little program I use multiple times a day to quickly see my unread email without moving from what I'm currently working on and without touching my mouse. I recently noticed it wasn't grabbing the body of a specific type of email. In the process of fixing that I also added proper unit tests for every format I currently parse through. Yay faster feedback loops!

## ffmpeg
I've been a fan of OBS for awhile now. I was recently doing a quick screen recording of my browser window and the browser window wasn't full-screen so there were black bars around the edges of the recording. I didn't love that but it's time to touch the "ffmpeg exists and is awesome" sign again.

[This superuser post](https://superuser.com/a/810524) has the answer which consists of two steps:

1. Get the crop parameters of the video from ffmpeg. ffmpeg will detect the black borders and report back the actual content coordinates.
`ffmpeg.exe -i '.\some-video.mkv' -vf cropdetect -f null -`
2. Re-encode and crop using the crop parameters to trim the borders.
`ffmpeg.exe -i '.\some-video.mkv' -vf crop=624:704:332:10 -c:a copy output.mp4`
3. Enjoy your pristine video.

## Links I've enjoyed

- [Docker without docker](https://fly.io/blog/docker-without-docker/)
Really anything on the fly.io blog is _gold_.
- [David Crawshaw: SQLite and Go](https://www.youtube.com/watch?v=RqubKSF3wig)(Talk)
- [DNSFS](https://blog.benjojo.co.uk/post/dns-filesystem-true-cloud-storage-dnsfs)
- [Writing Small CLI Programs in Common Lisp](https://stevelosh.com/blog/2021/03/small-common-lisp-cli-programs/)
- [My Dream of the Great Unbundling](https://www.wired.com/story/my-dream-of-the-great-unbundling/)

Fin
