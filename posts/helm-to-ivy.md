I started playing around with [Ivy](https://github.com/abo-abo/swiper) earlier today. I was motivated in part by reading through the author's blog, [oremacs](http://oremacs.com). I also love his swiper plugin and figured I had to give Ivy a try.

## Background

For the record I discovered [Helm](https://github.com/emacs-helm) about 20 minutes into my initial foray into emacs. I ❤ Helm. I support the project on [Patreon](https://www.patreon.com/emacshelm). It's great. I'm all about mastering my tools though and to do that I need to at least try other tools. Enter my attempt to switch to Ivy.

## Progress

This post isn't meant to be a finished product. I'm going to try and circle back occasionally as I use Ivy for the next couple days. A few notes on my experience so far:

  - I somehow had an old version of Ivy installed and when I went to install counsel I was getting weird errors. Deleting Ivy from my `elpa` directory manually cleared things up.
  - Wow, by default, Ivy feels much more sparse than Helm. The first thing I had to do was figure out the "buffers list" implementation and change my `C-=` binding from helm to ivy. It's definitely more spartan, but I don't *think* its a negative necessarily just a change.
  - Ivy is just a completion package, by itself it doesn't do a ton. That's why it comes with `counsel` and `swiper` these are the primary interfaces to the good stuff, e.g. `counsel-ag` searches your project with [Silver Searcher](https://github.com/ggreer/the_silver_searcher).
  - Previews are incredible\! Thanks to [this comment](https://www.reddit.com/r/emacs/comments/51lqn9/helm_or_ivy/d7d4420/) on reddit. With the `C-M-n` and `C-M-p` commands you cycle through any matches and you see the entire file in the buffer. Imagine searching for a keyword in a project and then getting to see all the glorious context as you pick through the matches without having to open every single file\!
  - ~~Not sure how to completely prevent a package from loading. I don't want `helm` to load while I play with Ivy. The `:disabled:` keyword in use-package doesn't really prevent it from being loaded, it just prevents the `use-package` form from being executed. I ended up relying on `git` and removed the lines from my .emacs and I `rm -rf` the helm package directories.~~ I looked at this again after sleeping on it. I defined two variables `simpson-evil` and `simpson-helm` and I check those values in my config to set up configurations depending on which packages is available. Easy enough.
  - I had a epiphany about how `use-package` works. `use-package` will auto load any package that has a `:bind`, `:mode`, `:command`, or `:init` keyword. If all you have is `:config` that package won't load itself. However adding `:defer 1` will load that package once emacs is idle for a second and then fire off the `:config` body. So far so good. `:disabled` comes into play even if you have a `:after` keyword because if you have `:after` combined with any of the "auto load" keywords above the package will try to do stuff.
