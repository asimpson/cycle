It's not secret that I've become quite the Emacs fan over the past couple years. One of my favorite things about Emacs is the [Ivy package](https://github.com/abo-abo/swiper) (and counsel and swiper of course). In exploring what Ivy was capable of I had the idea [to write a small package](https://github.com/asimpson/ivy-feedwrangler) that used Ivy as the interface for my RSS service of choice, [Feedwrangler](http://feedwrangler.net). You can check out the repository [here](https://github.com/asimpson/ivy-feedwrangler) and [install the package via melpa](https://melpa.org/#/ivy-feedwrangler).

## What is Ivy?

Ivy is, according to it's [Github repo](https://github.com/abo-abo/swiper), a "a generic completion mechanism for Emacs." Quite simply Ivy is an interface for quickly working with lists of data whether that be:

  - fuzzy-finding commands
  - searching for files in a project
  - [interacting](https://github.com/ecraven/ivy-pass) with the [pass unix password manager](https://www.passwordstore.org)
  - [browsing lobste.rs](https://github.com/julienXX/ivy-lobsters)
  - or [searching youtube](https://github.com/squiter/ivy-youtube)

## Ivy-feedwrangler

Ivy makes manipulating and filtering lists super quick and easy. In fact, I'd say it's *the* quickest way to work with this kind of data. Working with my RSS feed is now lightning fast. Here are a few features of ivy-feedwrangler:

  - Mark individual posts as read or mark all as read
  - View text posts inside a buffer in Emacs, this supports [inline images](https://asimpson.github.io/ivy-feedwrangler/images/post-view.png)\!
  - Quickly filter through unread items since Ivy can handle regex out of the box
  - Uses [authinfo](https://www.emacswiki.org/emacs/GnusAuthinfo) to handle authentication which uses GPG to encrypt credentials.

The other big perk to using ivy-feedwrangler is that, unlike [elfeed](https://github.com/skeeto/elfeed) (*the* package for RSS in Emacs), it interacts directly with the [Feedwrangler API](https://feedwrangler.net/developers)\! That means I can read things in Emacs and that state is synced correctly to my phone and vice-versa.

So, if you have a Feedwrangler account, give ivy-feedwrangler a try and let me know what you think\!
