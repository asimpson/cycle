[Quick tip](http://aleksandarsavic.com/nginx-redirect-wwwexamplecom-requests-to-examplecom-or-vice-versa/) for rewriting www.example.com to example.com or vice versa in [Nginx](http://nginx.com/).

My conf file originally looked like:

` server { server_name  www.example.com example.com; }`

I had to create another server block, and move all the conf information to the new block. In my case I was rewriting www to non-www.

` server { server_name  www.example.com; //rewrite here; } server { server_name http://example.com; //all the server stuff goes in this block; }`

### Update

Instead of mucking around with rewriting, I should have just used return, like so:

` server { server_name  www.example.com; return 301 http://example.org$request_uri; }`

The lesson is, always check out [the official docs](http://nginx.org/en/docs/http/converting_rewrite_rules.html) before Google.
