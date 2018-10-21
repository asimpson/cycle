The title says it all. I completely forgot about [the Wordpress HTTP API](http://codex.wordpress.org/HTTP_API) until today, when I was working with HTTP requests in a plugin. I stumbled upon the [wp\_remote\_post](http://codex.wordpress.org/Function_API/wp_remote_post) function and it immediately replaced my custom HTTP function.

### Hidden Gem

One of the hidden gems in the [wp\_remote\_post](http://codex.wordpress.org/Function_API/wp_remote_post) function is in the optional arguments you can pass along, specifically the ["blocking" option](http://codex.wordpress.org/HTTP_API#Other_Arguments). This option allows you to block script execution while it waits for the response or allows the script to continue on. So simple\!
