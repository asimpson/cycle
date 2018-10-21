"Diminishing modes" in Emacs is a popular topic. It took me a while to understand the basic (and simple) rules around how to customize the display of the various mode names.

## What are modes

Modes in Emacs come in two flavors, major and minor modes. The [Emacs manual](https://www.gnu.org/software/emacs/manual/html_node/emacs/Modes.html#Modes) explains modes like this:

> Emacs contains many editing modes that alter its basic behavior in useful ways.

Major modes:

> \[...\] provide specialized facilities for working on a particular file type \[...\] Major modes are mutually exclusive; each buffer has one and only one major mode at any time.

Minor modes are:

> \[...\] optional features which you can turn on or off, not necessarily specific to a type of file or buffer. \[...\] Minor modes are independent of one another, and of the selected major mode.

## Customize the mode line

Modes are great, yet they [fill up the mode line](https://www.emacswiki.org/emacs/ModeLine). I only really want to know about a handful of minor modes and the major mode. On top of that I don't like how some modes name themselves (e.g. all caps, too long, etc.). Changing the display or completely hiding a mode is different for major and minor modes.

### Changing minor mode names

Minor mode names are stored in a list variable called `minor-mode-alist`. You can customize that directly or use the fantastic package [diminish](https://github.com/myrjola/diminish.el) as a wrapper around that functionality, like so:

`(diminish 'flyspell "spell")`

### Changing major mode names

Major mode names are not stored in a simple list variable. Yet, fear not\! In reading the source of the diminish package, I stumbled [across this comment](https://github.com/myrjola/diminish.el/blob/master/diminish.el#L98):

> To diminish a major mode, (setq mode-name "whatever") in the mode hook.

The variable `mode-name` couldn't be correct could it? Yes, yes it is. Here's an example of changing the mode name for the default `elisp-mode`:

`(add-hook 'emacs-lisp-mode-hook (λ () (setq mode-name "λ")))`

Now you have all the tools at your disposal to change every mode's name in your mode line.
