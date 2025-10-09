---
title: "Format JSON in emacs"
date: 2017-05-23T14:11:28-04:00
lastmod: 2017-05-23T14:11:28-04:00
slug: format-json-in-emacs
excerpt: "I wrote an elisp function to yank JSON off my clipboard, prettify it."
---

I wrote an elisp function to yank JSON off my clipboard, prettify it, and then return it to my clipboard ready to be pasted wherever.

``` elisp
(defun simpson-pretty-json()
  "ideal for getting pretty JSON from JSON that is copied from a XHR request"
  (interactive)
  (with-temp-buffer
    (clipboard-yank)
    (json-pretty-print-buffer)
    (kill-new (buffer-string))
  )
)
```