I was happily (I had just started obviously) browsing Twitter today when I saw this tweet from the esteemed [Wilfred Hughes](http://www.wilfred.me.uk):

> git-worktree allows you to have multiple branches checked out simultaneously\! [](%3Chttps://t.co/R3ExhMNf7E%3E)<https://t.co/R3ExhMNf7E>
> 
> — Wilfred Hughes (@<sub>wilfredh</sub>) [December 4, 2017](%3Chttps://twitter.com/_wilfredh/status/937827498196381697?ref_src=twsrc%5Etfw%3E)

Huh? What is `git-worktree`? A quick Google landed me on [the documentation](https://git-scm.com/docs/git-worktree) for `git-worktree`. The ;TLDR of `git-worktree` is that it breaks time and space and lets a user check out multiple branches *at the same time*. No more stash-checkout-stash-pop dance between branches and fixes\! The [example](https://git-scm.com/docs/git-worktree#_examples) in the documentation is really really good (except for the boss part, that's usually played by my short-attention span).

## Magit

After reading the documentation, my next thought was "Does [magit](https://magit.vc) support this?" Yep, [since last year](https://github.com/magit/magit/blob/94980fed2b87a2194c325702d1b70a58ca5738b7/lisp/magit-worktree.el)\! Let me take this moment to rave like a maniac, magit is amazing and everyone should be using it as their primary git client (irregardless of Emacs usage for text-editing). As the [documentation explains](https://emacsair.me/2016/05/19/magit-2.7/), to get worktree information in the standard magit status buffer the `magit-status-sections-hook` needs to be updated like so:

`(add-hook 'magit-status-sections-hook 'magit-insert-worktrees)`.

The actions for creating or checking out a worktree are (hiding) in the branches (`b`) popup. I don't know why I've never noticed them until now\!

`git-worktree` is another example of `git` not standing still. It's exceptional (even under-appreciated) software that continues to improve and that's something that doesn't get enough praise and attention.
