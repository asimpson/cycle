---
title: "Introducing Cycle"
date: 2019-04-05T23:05:17-0400
lastmod: 2019-04-05T23:05:17-0400
slug: introducing-cycle
excerpt: "Cycle is a half-baked static site-generator that I wrote to publish this here interweb page. Cycle is not really ready for anyone else to use but me at this point. However I wanted to outline my rationale for the various design decisions that inform how Cycle works today."
---

[Cycle](https://github.com/asimpson/cycle) is a half-baked static site-generator that I wrote to publish this here interweb page. Cycle is not really ready for anyone else to use but me at this point. However I wanted to outline my rationale for the various design decisions that inform how Cycle works today.


## Language choice

I wrote in my [previous post announcing](/writing/blog-rewrite) my re-write that I was considering Rust or Common Lisp because those languages allowed me to build a stand alone binary of my site builder. I got some feedback on Twitter that Common Lisp would actually be a good choice:

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">I’ve read your blog post and solved your problem. There are at least 3 markdown libraries for Common Lisp.<br><br>I’ve checked, one of them – <a href="https://t.co/UI04NyOjYd">https://t.co/UI04NyOjYd</a> has extension to parse GitHub-like code fences: <a href="https://t.co/KvKZr0RiYk">pic.twitter.com/KvKZr0RiYk</a></p>&mdash; svetlyak40wt (@svetlyak40wt) <a href="https://twitter.com/svetlyak40wt/status/1065550535703633920?ref_src=twsrc%5Etfw">November 22, 2018</a></blockquote>

I ended up going with Common Lisp and I really enjoyed the experience. Common Lisp has the best REPL I've ever used in any language. It's wonderful to use. Having a good REPL is a key component of not only creating new features but also fixing bugs. Once I had chosen the language it was time to figure out how I wanted my program to consume and build my site.


## Mimic Jekyll&#x2026;to a point

I spent some time understanding how [Jekyll](https://jekyllrb.com/) works to figure out which parts I wanted to emulate and which parts I wanted to leave behind or solve differently.


### JSON > YAML

Jekyll relies heavily on YAML for data files and inside every post. The decision to include it in every post has always bugged me about Jekyll so I wondered what a static site generator would look like if it used JSON instead of YAML. In my implementation every post is represented as a Markdown file and data for that post is represented as a separate JSON file. The directory structure looks like this:

    ./
    ├── README.md
    ├── posts
    │   ├── a-few-bash-tips.json
    │   ├── a-few-bash-tips.md

While this increases the amount of files needed to build the site, I find keeping the Markdown files as "vanilla" as possible worth the trade-off.


### The Good Parts

I copied Jekyll's directory and file structure pretty closely. The site is built from these source files into a directory called `site` that holds the entire site. Here's a breakdown of the required directories and files:

-   `public`: anything in `public` is copied over verbatim to `site`. This is the place to put assets like images, third-party JS etc.
-   `posts`: contains posts that are processed through templates and dropped into `site`. Cycle processes all the posts into a data structure that is then available globally inside Cycle for any other part of the build process to use.
-   `templates`: hold the various templates for pages and posts as well as templates for RSS and Sitemap.
-   `pages`: holds files that are either `.mustache` files or `.md` files. If a page file is a `.md` file then it gets processed with a generic `templates/page.mustache` template. The only supported `.mustache` file at the moment is the `archive.mustache` file which is passed the entire post data object to generate paginated archive pages.
-   `site.css` is a file in the root of the project. Any CSS in this file is inlined into the `<head>` of the built site.


## Easy to add new features and fix bugs

Another aspect I was hoping to solve with this re-write was to make it easier to add new features and fix bugs as they come up. Common Lisp's previously mentioned REPL helps in this area. [Slime is an Emacs extension](https://github.com/slime/slime) that integrates Common Lisp's REPL into Emacs along other functionality like debugger support. Having the ability to set breakpoints and execute portions of my program at will right inside my editor helps identify bugs. The expressiveness of Lisp also helps in ramping up on code that I wrote months ago. I've been using Cycle for a few months now and I've enjoyed that I don't feel overwhelmed when I have to look back at the code.


## Building binaries in Travis

One last thing about Common Lisp and it's stand-alone binaries. I got [Travis CI](https://travis-ci.com/) hooked up and [building macOS and Linux versions of cycle](https://github.com/asimpson/cycle/blob/master/.travis.yml) without too much struggle. Now whenever I tag a new release Travis builds the binaries and attaches them to the [Release in Github](https://github.com/asimpson/cycle/releases/tag/v0.2.1). Automating this build and release work has made the actual hosting and building of the site pretty painless.


## Netlify

I switched from AWS S3 to Netlify not because S3 was inadequate in anyway but more because I wanted an excuse to play with Netlify's features. I ended up writing a [`Makefile`](https://github.com/asimpson/blog/blob/master/Makefile) that Netlify can execute to download the latest version of Cycle and then build the site. Netlify is configured to run `make cycle && make` when a new post is pushed to the repo.


## Some Common Lisp helper functions

Over the course of getting a working version of Cycle out the door I wrote a few helper functions that remove some friction in some common tasks.


### String concat

The `concatenate` function in Common Lisp is a general purpose function that works over strings as well as lists and other data types. It's typically used like this: `(concatenate 'string "hello" "world")`. Notice that `concatenate` requires that the type of the values to be specified. I didn't like this so I wrote this:

```common-lisp
(defun concat (&rest strings)
  "Wrapper around the more cumbersome concatenate form."
  (let (result)
    (dolist (x strings)
      (setf result (concatenate 'string result x)))
    result))
```

`concat` takes any number of strings and uses the `dolist` macro to call `concatenate` on them. It's used like this: `(concat "hello" "world")`. Much better in my opinion.


### Write to file

Cycle writes a lot of files. That's pretty much it's main jam. I realized I was writing the same boilerplate to write files all over the place so I wrote a wrapper function:

```common-lisp
(defun write-file (contents file)
  "Write CONTENTS to FILE."
  (with-open-file (stream file
                      :direction :output
                      :if-exists :supersede)
    (write-sequence contents stream)))
```

Now I can write a file like this: `(write-file "Hello world" "./hello-world")`.


### String splitting

The last helper function I want to show is my wrapper around the [`UIOP:split-string`](https://common-lisp.net/project/asdf/uiop.html) function. Much like the `concat` function this mainly avoids extra typing:

```common-lisp
(defun split-string (string sep)
  "Wrapper around uiop:split-string to avoid keyword typing."
  (uiop:split-string string :separator sep))
```

Now I can split a string like this: `(split-string "Hello World" " ")`. Much easier.


## Never done

While I may be using Cycle to publish this very site it's not done and I don't think it ever will be. That's the beauty of software and specifically software written for an audience of me. I will always have new ideas and things I want to fix and Common Lisp provides some fairly unique and fun ways to keep iterating.
