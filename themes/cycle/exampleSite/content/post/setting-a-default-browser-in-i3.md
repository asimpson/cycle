---
title: "Setting a default browser in i3"
date: 2020-09-11T00:01:05-0400
lastmod: 2020-09-11T00:01:05-0400
slug: setting-a-default-browser-in-i3
excerpt: "Using a desktop manager like GNOME makes setting default applications easy. However when using a tiling window manager like i3 setting a default application is opaque to the newbie such as myself."
---

## The problem
I've been using the excellent [qutebrowser](https://qutebrowser.org/) for a few weeks now and I really enjoy it's minimal approach to web browsing. I still reach for Firefox or Chrome for web development purposes but `qutebrowser` shines as a daily driver. An issue I ran into is I didn't know how to set `qutebrowser` as my default web browser when using [i3wm](https://i3wm.org/) (or any tiling window manager really).

## The Solution
Here's the solution if you don't care about the process of figuring it out:

```
xdg-settings set default-web-browser org.qutebrowser.qutebrowser.desktop
```

## The Yak
Thankfully there's an [issue on the qutebrowser repo](https://github.com/qutebrowser/qutebrowser/issues/22) where folks discussed this very thing. Let's pull the solution apart to gain some understanding of the systems at play here.

The first part of the solution in the issue thread is:

```
ls /usr/share/applications/ | grep qutebrowser
```

which lists all the files in `/usr/share/applications` and then greps that list for entries that contain the word `qutebrowser`. [The Arch Wiki entry on "Desktop entries"](https://wiki.archlinux.org/index.php/Desktop_entries) explains what the files inside `/usr/share/applications` are and why that directory is important.

> Desktop entries for applications, or .desktop files, are generally a combination of meta information resources and a shortcut of an application. These files usually reside in /usr/share/applications/ or /usr/local/share/applications/ for applications installed system-wide, or ~/.local/share/applications/ for user-specific applications.

So by looking for `qutebrowser` in `/usr/share/applications` we're looking for its `.desktop` file which is important for the next step.

Looking at the next part of the solution involves running a program called `xdg-settings`. What is that? The man page declares that `xdg-settings` is used to "get various settings from the desktop environment". OK, so it's a tool to get (and apparently set?) desktop environment settings. This seems like the right thing. Let's keep reading the man page.

Further on in the man page we find an example on how to set Chrome as the default web browser: `xdg-settings set default-web-browser google-chrome.desktop`. Notice the `.desktop` file at the end of the command? XDG uses that file name to figure out which app to use for certain file and link types like `text/html` or `x-scheme-handler/http`. Back to our specific case, we need the full name of the desktop file to pass to `xdg-settings` which is `org.qutebrowser.qutebrowser.desktop`. With this information we can change the default browser to `qutebrowser` by running:

```
xdg-settings set default-web-browser org.qutebrowser.qutebrowser.desktop
```

This tells the desktop environment to launch whatever process is defined in that `.desktop` file for "browser things".
