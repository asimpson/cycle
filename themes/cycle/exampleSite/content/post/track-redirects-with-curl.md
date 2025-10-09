---
title: "Track redirects with curl"
date: 2019-10-22T13:25:50-04:00
lastmod: 2019-10-22T13:25:50-04:00
slug: track-redirects-with-curl
excerpt: "I made a bash alias that takes a URL as an arguement and runs it through curl resuting in the Headers from each redirect, the final URL, and the number of redirects printed to the console."
---

I was recently debugging some `.htaccess` redirects and wanted to know two things:

1. How was my URL changing as it went through the redirects?
2. How many redirects occurred?

I quickly got fed up with testing in the browser because of 301/302 redirect caching issues. With my limited `curl` knowledge I knew I could dump headers and that would show me the redirect code and the URL but figuring out how many hops occurred was frustrating.

I searched around and found this [*very* helpful post](https://www.chrislatta.org/articles/web/curl/track-redirects-curl-command-line) by  Chris Latta. The `curl` command from the post introduced me to the fact that `curl` has basic templating support! I read through `man curl` and noticed there were other built-in variables besides `url_effective`, like `num_redirects`! This was exactly what I wanted. Below is what I eventually ended up with:

```
curl -LSs -D - -o /dev/null -w 'Final URL: %{url_effective} \nNumber of Redirects: %{num_redirects} '
```

I added this to my dotfiles as an alias called `redirects`, here is a sample of what the output looks like:

```
❯ redirects "http://adamsimpson.net/uses"
HTTP/1.1 301 Moved Permanently
Cache-Control: public, max-age=0, must-revalidate
Content-Length: 44
Content-Type: text/plain
Date: Tue, 22 Oct 2019 17:39:10 GMT
Location: https://adamsimpson.net/uses
Age: 0
Connection: keep-alive
Server: Netlify
X-NF-Request-ID: de179b0f-db8b-401a-97ad-7ce523020763-108626

HTTP/2 200
cache-control: public, max-age=0, must-revalidate
content-type: text/html; charset=UTF-8
date: Tue, 22 Oct 2019 17:39:10 GMT
etag: "3f4bb560fd31e7328aedc7bc08a9c541-ssl"
strict-transport-security: max-age=31536000
age: 0
server: Netlify
x-nf-request-id: de179b0f-db8b-401a-97ad-7ce523020763-108794

Final URL: https://adamsimpson.net/uses
Number of Redirects: 1 %
```

`curl` might be one of the most important tools I have at my disposal for working with HTTP requests and I feel like I've only begun to scratch the surface of what it can do.
