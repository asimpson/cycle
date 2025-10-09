---
title: "A Fluid Userscript that adds Read it Later to Twitter"
date: 2013-03-24T03:00:43-04:00
lastmod: 2015-03-21T19:45:37-04:00
slug: a-fluid-userscript-that-adds-read-it-later-to-twitter
excerpt: "A simple Fluid userscript that adds a Read it Later button for Instapaper to any tweet containing a link
"
---

I use and love [Craig Mod's](http://craigmod.com/) [Twitter for Minimalists](http://craigmod.com/satellite/twitter_for_minimalists/). It is a great way to experience the Twitter web client without some of the cruft. However, the biggest thing I miss from third party apps like Tweetbot is the ability to send interesting links directly to my Instapaper account with one click.

Since Twitter for Minimalists runs inside a [Fluid](http://fluidapp.com/) instance I can set custom Userstyles (like Twitter for Minimalists) and Userscripts. I decided to write a Userscript that would parse through every tweet and determine if it had a link and - if it did - append a Send to Instapaper button to the bottom of the tweet. I was able to create the button using [Instapaper's iFrame Button API](http://www.instapaper.com/publishers). You can find the the finished code for the Read it Later Userscript [here](https://github.com/asimpson/send-to-instapaper-fluid).

Hope you find it useful\!
