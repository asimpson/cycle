---
title: "Compose key and i3"
date: 2020-09-18T11:28:19-0400
lastmod: 2020-09-18T11:28:19-0400
slug: compose-key-and-i3
excerpt: "Here's how to bind the compose key to caps lock in i3wm."
---

The [compose key](https://en.wikipedia.org/wiki/Compose_key) on Linux and other systems enables you to enter symbols like ™ that don't have a dedicated key on most keyboards. GNOME makes this [easy to do via Gnome Tweaks](https://help.gnome.org/users/gnome-help/stable/tips-specialchars.html.en). However, using a window manager like i3 means there's no dedicated GUI for changing the hotkey for compose.

[This stackexchange answer](https://unix.stackexchange.com/a/195160/41593) sent me down the right path of adding the following config to `~/.Xmodmap` to bind Caps lock to compose:

```ini
.keysym 66 = Mode_switch
clear Lock
```

You can then enable the key map by running:

```shell
xmodmap ~/.Xmodmap
```

However, that config didn't work because `Mode_switch` wasn't the right name for the compose key (at least under Ubuntu/PopOS 20 for me). The [Arch Wiki states](https://wiki.archlinux.org/index.php/Xorg/Keyboard_configuration#Configuring_compose_key) that the name for the compose key is actually `Multi_key`. With this new name I was able to get Caps lock to act as the compose key by updating the config in `~/.Xmodmap` to:

```ini
keycode 66 = Multi_key
clear Lock
```

The final step is to set that mapping every time i3 runs by putting this inside your [i3 config file like so](https://github.com/asimpson/dotfiles/commit/c86e4216e09e940c2cf7126581e8e69b95fe1511):

```shell
exec --no-startup-id "xmodmap ~/.Xmodmap"
```
