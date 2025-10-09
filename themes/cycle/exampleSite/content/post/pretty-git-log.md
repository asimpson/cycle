---
title: "Pretty Git log"
date: 2012-07-18T03:01:14-04:00
lastmod: 2017-02-24T13:36:58-05:00
slug: pretty-git-log
excerpt: "Handy tip for pretty git logs.
"
---

![pretty git log via David DeSandro](/images/pretty-git.png)

Yesterday, [David DeSandro posted](http://dropshado.ws/post/27506212928/pretty-git-log) a handy little command-line alias to make git logs a bit "prettier".

`alias glog="git log --format='%Cgreen%h%Creset%C(cyan)%an%Creset - %s' --graph"`

Hat-Tip to [Mr. TJ Holowaychuk](http://tjholowaychuk.com/post/26904939933/git-extras-introduction-screencast) for the original idea.
