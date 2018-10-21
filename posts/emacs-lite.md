I really dig Emacs. I think it's a one-of-kind computing experience. However, it's defaults are pretty rough and some of my favorites aspects of Emacs are third party packages.

I wondered if I could cram the "awesome Emacs" experience into 200 lines of configuration or less. [Turns out I could](https://github.com/asimpson/dotfiles/blob/master/emacs/emacs-lite.org). I only included what I consider (as someone who writes JS most days) "essential". I didn't re-bind any keys except for `M-x` and that has the same function with an [upgraded interface](https://adamsimpson.net/writing/helm-to-ivy). I didn't include `evil-mode` (Vim emulation) either, introducing Emacs *and* Vim keybinds to someone is a suicide mission.

To use this config copy and paste the config snippet [into one of three config file locations](https://www.gnu.org/software/emacs/manual/html_node/emacs/Init-File.html) (sooooo Emacs):

> Emacs looks for your init file using the filenames ~/.emacs, ~/.emacs.el, or ~/.emacs.d/init.el

Then boot up Emacs (I'm assuming you [already have it installed](https://www.gnu.org/software/emacs/)), there will be a bit of waiting the first time as packages are installed for you.

If you run into issues, hit me up via email, [github issue](https://github.com/asimpson/dotfiles/issues), [twitter](https://twitter.com/a_simpson), [micro.blog](https://micro.blog/simpson) etc. There's also a [reddit thread](https://www.reddit.com/r/emacs/comments/8cpkc3/emacs_lite_just_the_essentials_config_in_200_lines/) with some helpful discussion from the awesome `/r/emacs` community.
