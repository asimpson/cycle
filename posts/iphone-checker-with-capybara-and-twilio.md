I got my gigantic iPhone 6+ last weekend, and not via the online Apple Store where my order had been sitting for a couple weeks and wasn't going to ship until Nov. 5th. Instead I got a friendly text message the minute the phone was available at my local Apple Store. With a few great tools it was incredibly easy to set this system up.

TL;DR: I set up a small Heroku app that uses [Capybara](https://github.com/jnicklas/capybara) to check Apple's website for availability and sends a text to my phone using the [Twilio service](https://www.twilio.com).

The entire process was pretty simple once I figured out a few Heroku oddities. The app hinges on the fact that Apple provides a "Check Availability" link during the ordering process. This link pops open a modal that take your zip code and checks nearby Apple stores for your product.

All I had to tell Capybara to do was visit the URL, click the check availability button, and enter my zip code. After that I loop through the store list and check the status message. If the phone is available I send myself a text with the store name, phone model, and link.

The toughest part of this project was figuring out how to tell Heroku where the [Phantomjs](http://phantomjs.org) executable was located. Capybara uses Phantomjs behind the scenes and without it the whole thing wouldn't work. I initially tried to use [the Phantomjs build pack](https://github.com/stomita/heroku-buildpack-phantomjs) but a weird thing with Heroku is that declaring a build pack seemingly removes the path for the Ruby executable. I then discovered the awesome [multi build pack](https://github.com/ddollar/heroku-buildpack-multi) tool. Once I created my `.buildpack` document I just had to tell Heroku to load the Phantomjs build pack *and* the Ruby build pack like this:

`https://github.com/stomita/heroku-buildpack-phantomjs.git  https://github.com/heroku/heroku-buildpack-ruby`

The last piece of the app uses [clockwork](https://github.com/tomykaira/clockwork) to kick off the scrape every 10 minutes. Clockwork is incredibly easy to setup and use. Specify the command in the `Procfile` and Heroku will understand exactly what to do.

The [code for the project can be found over at Github](https://github.com/asimpson/phone-checker). Reach out on [Twitter](https://twitter.com/a_simpson) or file an issue if you have any questions.
