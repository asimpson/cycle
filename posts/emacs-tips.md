[`evil-mode`](https://github.com/emacs-evil/evil) (vim for [emacs](https://www.gnu.org/software/emacs/)) is good but not perfect. There will be occasions where you will get dropped into regular 'ole emacs mode for some feature or plugin. The trick is to not panic remember a few basic movement keys that will get through in 90% of cases.

1.  `C-n` and `C-p` (`C` stands for the ctrl key) go down and up by line respectively.
2.  `M-f` (`M` stands for the alt key) and `M-b` will go forwards and backwards by word respectively.
3.  `C-g` is the universal emacs key for "STOP WHATEVER YOU'RE DOING".

There are a few other random things to keep in mind that will make life easier.

1.  `M-x` (remember, `M` stands for the alt key) allows you to execute just about any function, e.g. `kill-buffer`.
2.  `F1 f` will bring up documentation for any loaded function.
3.  `F1 v` will bring up documentation for any variable.
4.  `F1 k` will allow you to type a keybind and see what it's bound to.

## Scripting tips

A few helpful built-in functions to know to start making your own functions.

1.  `nth` is a [built-in](https://www.gnu.org/software/emacs/manual/html_node/elisp/List-Elements.html#List-Elements) which lets you pull a specific item from a list by it's index like so: `(nth 1 '("red", "blue"))`. Returns `"blue"`.

2.  `split-string` is another [built-in](https://www.gnu.org/software/emacs/manual/html_node/elisp/Creating-Strings.html#Creating-Strings) that splits a string given a separator and returns the results in a list. `(split-string "foo-bar" "-")`. Returns `("foo" "bar")`

3.  `concat` also a [built-in](https://www.gnu.org/software/emacs/manual/html_node/elisp/Creating-Strings.html#Creating-Strings), combines strings. `(concat "hello" "world")`. Returns `"helloworld"`.

4.  `null` also a built-in. Return t if OBJECT is nil, and return nil otherwise. `(null OBJECT)`.

I'll add to this post as I think of things that helped me out when I first started using emacs. You can also check out my [emacs config in my dotfiles](https://github.com/asimpson/dotfiles/tree/master/emacs) if you want to see how I have everything setup.
