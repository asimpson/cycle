So I've been working on a pet project today, getting my Raspberry Pi to be a dedicated screen-scraping machine.

I'm still in the middle of getting things working, so I'll be updating this post as I figure more stuff out. This post is intended to be a log for myself and hopefully a helpful resource for others.

## Boot Image

I'm using the [Raspbian Jessie image](https://www.raspberrypi.org/downloads/raspbian/) provided by Raspberry Pi. To create and backup my SD card images I'm using the excellent [ApplePi Baker](http://www.tweaking4all.com/hardware/raspberry-pi/macosx-apple-pi-baker/) app. It provides a GUI wrapper around some gnarly command line tools to flash images to the Raspberry Pi SD card.

## Installing Node

[This post](http://blog.wia.io/installing-node-js-v4-0-0-on-a-raspberry-pi/) by [Conall Laverty](https://twitter.com/ConallLaverty) shows exactly how to get node and npm up and running on a Pi. I tried using the `apt-get` manager like I do with a VPS and the Pi wasn't liking it.

## Installing CasperJS and Phantom

Another [helpful post](https://quaintproject.wordpress.com/2015/04/26/how-to-install-casperjs-on-the-raspberry-pi/) by [Alexander Bilz](http://alexbilz.com) shows how to get casperjs and a specialized version of phantomjs working on the Pi.

I've run into issues with the 1.9.8 version of phantom compared to the 2.0 version on my laptop. Finding a compiled binary of 2.0 has proven to be quite difficult. So I'm on hold for now until I can get a 2.0 version running.

## Troubleshooting

Since I'm using my Pi headless, I'm configuring everything over ssh. Sometimes this just doesn't work well. I've found VNC to be a nice solution in those cases. [This post](http://gettingstartedwithraspberrypi.tumblr.com/post/24142374137/setting-up-a-vnc-server) has simple instructions for getting a VNC server up and running on your Pi. I use [Chicken VNC](http://sourceforge.net/projects/chicken/) as the client on my Mac to connect to the Pi's server.

## Speed

The Pi is slow. *Really* slow. I've found adding some `casper.wait`s to my code have helped iron out some random errors.
