Ok, this one is still piping hot in my `*scratch*` buffer so remember that before you criticize the rough edges. I've long wanted to quickly filter through the [popular links page](https://pinboard.in/popular) on [pinboard.in](https://pinboard.in) without jumping over to a browser. Ideally this page would have an RSS feed or API end point but alas it has neither. I love [pulling things into Emacs](https://github.com/asimpson/ivy-feedwrangler) (yay for text-based interfaces\!); so I set out to pull these links into Emacs and display them via [Ivy](https://github.com/abo-abo/swiper).

Feel free to skip ahead and [checkout the repo](https://github.com/asimpson/ivy-pinboard-popular) if you're so inclined.

## Steps

I `curl`ed the page down and pasted the HTML into a buffer in Emacs so I could start pulling things apart. My first attempt was to use the excellent [`elquery` library](https://github.com/AdamNiederer/elquery) but that was choking on the DOM structure and I never could quite pin down where (sorry Adam, I need to post an issue about that\!). My next attempt was to use a more "manual" scripting approach. Since Emacs possesses so many ways to manipulate buffer text I was sure there could be a programmatic way to do this (without doing a bunch of regexing which I'm terrible at and even more so in Emacs). The basic series of steps boiled down to this:

  - Use the new-to-me `keep-lines` function to trim everything out of the buffer *except* the popular links. I used the classname of the links (`bookmark_title`) to identify them.
  - Use `loop-for-each-line` to well loop over each line. Inside this loop I would need to pull out the `href` and the title of each anchor link.
  - I used `re-search-forward` to move from target to target to figure out the point boundaries for my href and my link text.

I ended up breaking this functionality out into it's own function since I used it more than once and it was cumbersome to type it all out.

``` language-elisp
    (defun re-capture-between(re-start re-end)
      "Return the string between two regexes."
      (let (start end)
        (setq start (re-search-forward re-start))
        (setq end (re-search-forward re-end))
        (buffer-substring-no-properties start end)))
```

  - The final step was dumping the `href` and the link text into a plist and `push` that into a larger collection I could pass onto `ivy-read` to generate my interface.

## Coding string

One gotcha I ran into is that my titles would occasionally contain odd character sequences like `\302`. Turns out those are punctuation and various text symbols. The solution is to run the title through `decode-coding-string` for `'utf-8` to generate the proper characters.

## ❤ Emacs

Emacs is so powerful for this type of text manipulation because you can interactively work each step of a program out in an actual buffer and then put those steps together into a function. Each potential solution I thought of was quickly trialed via `M:` and frequent looks at documentation. Hopefully this has been a helpful look into how I approach solving problems in Emacs. Thanks for reading\!
