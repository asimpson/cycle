---
title: "Heroku and SSH Keys"
date: 2012-09-21T03:01:00-04:00
lastmod: 2015-03-21T19:45:37-04:00
slug: heroku-and-ssh-keys
excerpt: "Quick solution to fixing Heroku SSH key errors using ssh config.
"
---

[Heroku](http://www.heroku.com/) rocks. I've been using it to host this blog (for free, mind you) for the last couple months. However, I've run into a problem where Heroku refuses to authorize a `git push heroku` by declaring `Permission denied (publickey)`. After messing around deleting, creating, and re-adding SSH keys, I found these [two](http://zylstra.wordpress.com/2008/08/29/overcome-herokus-permission-denied-publickey-problem/) [posts](http://eveningsamurai.wordpress.com/2011/07/13/herokus-permission-deniedpublickey-problem/) that solved the problem for me. Apparently Heroku fails if you point it to any kind of custom SSH key. Simply add Heroku to your SSH config file and specify the key to use, problem solved.
