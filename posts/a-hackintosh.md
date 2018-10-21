## Taking the Hackintosh plunge

I built a PC (here's the [partslist](https://pcpartpicker.com/list/GvNtRG)) in May to replace my Xbox One (yay no more Live fees\!). And then last week with support for AMD GPUs in 10.12.6, I took the plunge and turned that PC into a Hackintosh. The process of getting a Hackintosh up and running wasn't really that much more difficult than setting up Arch Linux. In fact I'd say you could and probably should follow most of the [Arch Linux ideals](https://wiki.archlinux.org/index.php/System_maintenance) about knowing what and why you're updating as you maintain a Hackintosh.

Here's a few tips and things I learned along the way. I'd also recommend reading through the tips in [this reddit post](https://www.reddit.com/r/hackintosh/comments/4jgdny/tips_and_tricks_youve_learnt_living_the/d36pk9f/).

## Happy Path (Use Clover)

The ideal setup is to use [Clover](https://clover-wiki.zetam.org/Home) to add [ktext](http://hackintosher.com/blog/kext-files-macos/) and modify the `config.plist` in the `/EFI` partition. This leaves your actual macos install untouched. Avoid Unibeast and Multibeast, they try do too much and mask complexity. The truly "do-it-yourself" approach is outlined [here](https://eladnava.com/install-os-x-10-11-el-capitan-on-hackintosh-vanilla/). I ended up following a guide and using (and then modifying) their pre-made `/EFI` partition. Speaking of…

## Find a guide

I combined and followed these two guides:

  - <http://hackintosher.com/guides/guide-installing-macos-kabylake-hackintosh-sierra/>
  - <http://hackintosher.com/guides/updating-hackintosh-sierra-10-12-6/>

## Keep it simple

Solve one thing at a time. Google error messages.

## Use compatible parts

  - I'd recommend an Intel KabyLake CPU since it's the latest and greatest and it means you'll need a 200 series motherboard which is recommended anyway. AMD CPUs are not really supported.
  - While my build uses the Pentium G4560 I wouldn't recommend it as a great Hackintosh CPU. It works, but things would be smoother with an i5 or i7.
  - AMD GPUs (if you can find one at a decent price, damn you [Etherium](https://www.ethereum.org)) have great native support now in 10.12.6, e.g. Metal Support\!
  - Grab a WiFi/Bluetooth card from [osxwifi.com](http://www.osxwifi.com), genuine Apple parts which means things just work (I'm content with no Bluetooth and Ethernet for now)

## One OS per drive

Don't try to partition a drive and install macos and Windows on it. Keep all operating systems on their own boot drives and then boot into them using Clover.

## Disable hibernation if you're on a Pentium

You'll need to set two power management switches:

`sudo pmset -a hibernatemode 0`

`sudo pmset -a standby 0`

> To disable hibernation images completely, ensure hibernatemode standby and autopoweroff are all set to 0. ~ pmset man page

I didn't run into issues with `autopoweroff`.

## Disable automatic updates.

You can still update through the App Store but it's advised to wait and see if any ktexts or plist changes are needed before updating

That's it. Hopefully this post helps clarify the process to create a Hackintosh of your own.
