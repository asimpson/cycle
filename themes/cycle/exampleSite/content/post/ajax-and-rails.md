---
title: "Ajax and Rails"
date: 2019-01-28T11:25:49-05:00
lastmod: 2019-01-28T11:25:49-05:00
slug: ajax-and-rails
excerpt: "This is just a short post to save a few links and document that \"Server Javascript Responses\" in Rails are still useful in 2018/19."
---

This is just a short post to save a few links and document that "Server Javascript Responses" in Rails are still useful in 2018/19.

## Lifecycle of SJR

The basic idea behind Server Javascript Responses (SJR) is diagrammed below:

![img](https://adamsimpson.net/images/sjr.png)

SJR works like this:

1.  A User submits a form that has the Rails attribute `remote=true` on the form tag which makes the form submission happen via AJAX. See the [Rails guide](https://guides.rubyonrails.org/working_with_javascript_in_rails.html) for more information.

2.  The server receives the data payload and processes a response.

3.  The Response from the server is a blob of JS *not JSON* that usually comes from a matching `name.js.erb` template.

4.  The User's browser receives the JS blog and evals the JS to update the page.

## Links

1.  [DHH's original post](https://signalvnoise.com/posts/3697-server-generated-javascript-responses)
2.  [Medium post](https://m.patrikonrails.com/do-you-really-need-that-fancy-javascript-framework-e6f2531f8a38) about eschewing fancy front-end frameworks for SJR
3.  [Ajax calls the Rails way](https://m.patrikonrails.com/how-to-make-ajax-calls-the-rails-way-20174715d176)
