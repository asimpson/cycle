Whew, time to share something with the world I haven't really talked about online at all, my first and only (so far) iOS app. I did manage to find this tweet celebrating the launch (thanks to Twitter's advanced search):

> A few days ago I released my first iOS app, <https://t.co/JTSSQe5EEL>. I’m pretty proud of it. Shipping feels good.
> 
> — Adam Simpson (@a\_simpson) [March 13, 2014](https://twitter.com/a_simpson/status/444072396362772481)

Verse Recall was a Christmas gift to my Dad in 2013. He got a TestFlight beta, and it actually shipped in March. I'm pretty proud of it. The app was simple. It let you look up a Bible verse, save it locally to the device and schedule a local notification with the text of the verse. The goal was to help memorize verses.

When I started I didn't know Obj-C (no Swift at the time), had never used Xcode, and had no real clue where to start. Despite all that I shipped it and I'm proud of the 30-odd copies I sold ($0.99 big money\!). I never would have made it without these awesome tools:

  - [FMDB](https://github.com/ccgus/fmdb)
  - [AFNetworking](https://github.com/AFNetworking/AFNetworking)
  - [Cocoa Pods](https://cocoapods.org)

A few days ago I let my Apple Developer account "expire" therefore removing Verse Recall from the App Store. I've gone back and forth the last couple months on wether to renew again. There's more I'd like to do with it, bugs I'd like to fix and features I'd like to add (like maybe port it to React Native?\!), but I never spent the time to do those things for whatever reason. It works fine for now and my Dad still uses it so I'm content. If and when it breaks with an iOS update, I'll either update it and side-load the fix onto my Dad's phone or we'll let it die.

This morning I moved the current state of the project from my private Bitbucket repo to [Github](https://github.com/asimpson/verse-recall). I wanted to share the entire project history because the commits are hilarious to read (they range from rage to despair and back again), but I foolishly committed API keys and the like that were too difficult to clean out of Git's history. I doubt the code will be that useful to anyone at this point, but I like having it out there so I can point to it as a thing I did.

So ends Verse Recall, I'm proud of it and I learned a ton making it. In my mind it was a raging success.
