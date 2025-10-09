---
title: "IP Address Alfred Extension"
date: 2012-12-07T03:01:04-05:00
lastmod: 2015-03-21T19:45:37-04:00
slug: ip-address-alfred-extension
excerpt: "I enhance the previous IP bash function as an Alfred Extension
"
---

I have to admit, I am addicted to customizing my [bash](http://en.wikipedia.org/wiki/Bash_\(Unix_shell\)) experience. Yesterday, I came up with a little, one-off function that smooths over a point of friction in my workflow – working with my internal IP address.

During any project, I am often testing in virtual machines. On my development machine I have my [host file hacked](http://www.adamsimpson.net/a-few-bash-tips) to manage all the dev URLs. The friction point is constantly having to look up my IP address to test in VMs, or on other devices. This bash function simply parses out my IP address from the results of 'ifconfig' and copies that IP address to my clipboard. Now, instead of jumping into the Network pane to see my IP, or reading through ifconfig myself, I can simply type "ip", and jump back to my VM and paste in the address. The function also displays the IP address on the command line ready for easy typing into a mobile device.

`  function ip {   IP=$(ifconfig | grep 'inet 1' | cut -c 6- | awk 'NR==2 {print $1}')   echo $IP   echo $IP | pbcopy } `
