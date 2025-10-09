---
title: "Blog rewrite"
date: 2018-11-20T23:01:04-05:00
lastmod: 2018-11-20T23:02:21-05:00
slug: blog-rewrite
excerpt: "I haven't posted here recently. That's largely because I did the classic \"Time to rewrite the blog, I'll post when it's done\" thing. Well it's not done, but I messed up by not sharing my thought process and reasoning for the re-write. So, I'm trying to rectify that now with some scant and scattered sentences."
---

I haven't posted here recently. That's largely because I did the classic "Time to rewrite the blog, I'll post when it's done" thing. Well it's not done, but I messed up by not sharing my thought process and reasoning for the re-write. So, I'm trying to rectify that now with some scant and scattered sentences.

## Current setup

The blog is currently built using a custom Node app that lives inside a few [AWS lambda functions](https://aws.amazon.com/lambda/).

To begin with I created my own auth system (insert eyeroll emoji I know) which works like this:

![Image depicting the AWS Lambda system that provides authentication for my blog.](/images/lambda-auth.png)

Once the user is authenticated they can create posts which looks like this:

![Image depicting the various stages of the AWS Lambda system that creates posts.](/images/lambda-blog.png)

### Benefits

The benefits of my current setup are:

1.  Entirely static.
2.  No server to maintain.
3.  Provides ability to post from my phone using the /admin interface in the browser.

### Drawbacks

The things pushing me to consider a re-write, are:

1.  Local development is *hard*. The site generation is very tightly coupled to Lambda. There is no local server option for /admin.
2.  Because of its disorganized nature it's getting harder to maintain and add features (high microservices :wave:).
3.  Fully reliant on AWS stack (Lambda, DynamoDB, Cognito, S3, CloudFront, Certificates, Route53).

## Where do I want to go?

I'm thinking of moving towards what I call "The Jekyll model": an engine to build the site. I could then combine that engine with the following functionality to fill in the gaps:

1.  Mobile publishing via SFTP of markdown files to a VPS/home server.
2.  [Use a file system watcher](https://en.wikipedia.org/wiki/Inotify) to trigger new builds when a new post is uploaded/changed.
3.  Built site is uploaded to Netlify, S3, or Github pages. Keep it static.

Going this route addresses all the Drawbacks but introduces a server to maintain. I'm OK with that change if I can iterate on design changes quicker than I can now, did I mention how painful that is currently? The one aspect of this I don't have solved completely is post metadata (remember currently I'm using SQLite as my DB). I'm not a huge fan of the front-matter + markdown file approach because I'd rather have my data in a more standard data structure, e.g. a JSON file per post or something. If I go with a JSON file per post then I need to create something to generate that file upon post creation or modification. The other option is to keep using SQLite I guess.

![Image outlining how a potential new system would work for the blog.](/images/new-process.png)

### The Engine

The above *should* work. I just need something that consumes markdown and can match my existing URL scheme. I've ping-ponged back and forth between the following options:

  - Common Lisp
    
    I initially thought I would build out the engine myself in Common Lisp (to get more experience in CL). Part of the draw of Common Lisp was that I could create an executable and send that to the server and not have to install a bunch of dependencies just to get it to run. However the lack of a markdown library that supports [code-fencing](https://help.github.com/articles/creating-and-highlighting-code-blocks/) (which I use extensively) has killed the idea (and my spirit).

  - Jekyll/Hugo/Gatsby
    
    I toyed with just using Jekyll/Hugo but I would have to convert *every* post to MD + front matter. That sounded like a pain. I've also thought about using GatsbyJS but that introduces a ton of new tech that my site doesn't need.

  - Node
    
    I don't really want to do Node again because:
    
    1.  I've done a *lot* of Node recently
    2.  Requires installing dependencies and language runtime on server.

  - Emacs
    
    This one is the craziest idea I've had. Use an [Emacs docker container](https://github.com/Silex/docker-emacs) + org-mode + [some command line magic](https://stackoverflow.com/a/48121525/2344737) to have Emacs with org-mode be responsible for publishing the HTML for my site.

  - Rust
    
    I'm currently considering upping my fledgling Rust game and writing my engine in Rust. I can then create a binary and ship that to a server. And yes, before anyone asks I already checked and there are several solid looking markdown crates (libraries).

## Now what?

I have no idea where this leaves me. This post has been a thinking/documentation exercise for me more than a post. I think I'll keep exploring the Rust option and see where that leads me.
