[Manton Reece](http://www.manton.org) recently shared [his microblogging setup](http://www.manton.org/2015/06/microblogging-with-wordpress.html) with WordPress. I have a similar system that was inspired by [Jeremy Keith's example](https://adactio.com/journal/6826). Like Manton, I had to figure out the quickest way to create a new post. I eventually settled on SMS-to-post thanks ([once again](http://adamsimpson.net/writing/iphone-checker-with-capybara-and-twilio)) to [Twilio](http://twilio.com). SMS-to-post lets me text my Twilio number which sends the text to WordPress where it becomes a new "note". Publishing that "note" to Twitter is just a matter of hooking into the WordPress `publish_post` action and sending the post to Twitter via its API.

Here are a few other implementation notes:

  - I created a custom post type in WordPress called "Notes".
  - The [post status API](http://codex.wordpress.org/Post_Status_Transitions) makes this entire process smooth.
  - SMS-to-post has a few gotchas, the biggest one is that [SMS with emoji are limited to 70 characters](https://www.twilio.com/help/faq/sms/why-are-my-messages-with-unicode-being-split).
  - I don't have an RSS feed for my Notes...yet
  - I save the tweet ID of every post that gets posted to Twitter. I use that ID to pull in the favorite and retweet counts and display them next to each "note" in the WordPress dashboard.
  - Twilio needs an endpoint to POST incoming texts to WordPress. Creating custom endpoints is trivial thanks to [this great guide](http://coderrr.com/create-an-api-endpoint-in-wordpress/). I also recommend [the rewrite rules inspector plugin](https://wordpress.org/plugins/rewrite-rules-inspector/) for working with rewrite rules.
