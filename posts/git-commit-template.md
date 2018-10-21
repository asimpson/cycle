[TL;DR how do I do this?](#add_your_own_template)

At work we've been moving toward [standardized Git commit messages](https://github.com/sparkbox/how_to/tree/master/style/git). By following the pattern, it's very easy to see what type of code is in a specific commit.

We use [Sprint.ly](https://sprint.ly/) and [Github](https://github.com/). Both of these services can perform actions based on what is in a commit message. [Github can close or reference an issue](https://github.com/blog/831-issues-2-0-the-next-generation) if I type `closes #144` at the end of my commit. [Sprint.ly can pull a commit message into a specific ticket](http://help.sprint.ly/knowledgebase/articles/108139-available-scm-vcs-commands) in much the same way.

The problem with all this, is remembering to actually do it in the heat of the moment, when I'm buried in code and trying to push stuff out the door. That's why I put together a [Git commit message template](http://git-scm.com/book/ch7-1.html). All [my template](https://github.com/asimpson/dotfiles/blob/master/git/gitmessage.txt) does is list the various flags and an example of how to reference a Sprint.ly ticket, but it shows this in my editor every time I commit. It's been incredibly useful.

### Add your own template

1.  Create a file to hold your template, e.g. `git-commit-template.txt`. Put in whatever you want to remember, just be sure to keep everything commented out (via \#) or it will be in the actual message.
2.  Run `git config --global commit.template /path/to/git-commit-template.txt` or edit `~/.gitconfig` and add `template = /path/to/.gitmessage.txt` under the `[commit]` block.
3.  Done.
