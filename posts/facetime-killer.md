TLDR: I made an app, [VDCAssistant-Killer](https://github.com/asimpson/VDCAssistant-killer/releases), to restart the process that manages the Facetime camera on your Mac.

Anyone who uses a Cinema Display with their Macbook has undoubtedly noticed that occasionally the Cinema Display Facetime camera will not be available for use in Hangouts/Zoom/Facetime call. The only fix was to restart the machine which usually made me late (and is a terrible solution in 2017).

Since [I'm on video calls quite a bit](https://adamsimpson.net/writing/be-a-good-video-call-citizen) this quickly started to drive me batty. I jumped into a google deep dive and found out the culprit was the process that manages the Facetime cameras on a Mac, VDCAssistant.

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Ever have your Cinema Display Facetime camera stop working? `sudo killall VDCAssistant` should get it back 😓</p>&mdash; Adam Simpson (@a_simpson) <a href="https://twitter.com/a_simpson/status/796074967196639233?ref_src=twsrc%5Etfw">November 8, 2016</a></blockquote>

This command worked fine for anyone comfortable with the command line, but what about folks who would rather have a GUI to do this? So I made [VDCAssistant-Killer](https://github.com/asimpson/VDCAssistant-killer/releases) a menubar app that executes the exact shell command to restart the VDCAssistant process for you. You shouldn't have to restart the computer or even the video call program, the assistant should automatically restart and make all connected cameras available to you immediately.

A few other notes:

  - The app is all Swift.
  - It's incredibly easy to piece together a basic app with storyboards and some googling.
  - The actually shell command piece uses [AppleScript APIs to pop up the password dialog](https://github.com/asimpson/VDCAssistant-killer/blob/master/FaceTime%20Killer/Killer.swift#L13).
  - Emoji make great [stand-in icons](https://github.com/asimpson/VDCAssistant-killer/blob/master/FaceTime%20Killer/MenuController.swift#L26)
