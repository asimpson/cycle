Recently I released a [App.net to Twitter cross-posting app](https://github.com/asimpson/adn-crossposter) that runs via a single [Heroku](https://www.heroku.com/) worker dyno ([which means it's free, gracias Heroku](https://devcenter.heroku.com/articles/usage-and-billing#750-free-dyno-hours-per-app)).

### IFTTT Issues

For awhile I had been using [IFTTT](http://www.adamsimpson.net/ifttt) to crosspost any posts I made on App.net to Twitter, however there were two things I wasn't totally thrilled with.

First, IFTTT automatically converts any links in your App.net post to [bit.ly links](https://bitly.com/), which stinks as I want the links in my intended format and style. The other thing IFTTT did poorly was how it handled posts that were longer than 140 characters. Since App.net posts can be up to 256 characters, sometimes a post will be too long for Twitter, IFTTT would simply chop your post at the 140 character point and be done.

### Features

[ADN-Crossposter](https://github.com/asimpson/adn-crossposter) specifically addresses these two complaints.

First, it leaves links alone. The app simply pushes your post text to Twitter.

Second, the app checks the character count of the App.net post and if it's longer than 140 character it trims the post and adds a link to the App.net post, e.g. a read more link.

### Get the app

[Clone the app](https://github.com/asimpson/adn-crossposter). Add your ADN username to the `config.rb` file. You can also choose how to handle @replies as well.

### Twitter Setup

Since this is something that deals with Twitter there are a few steps involved in getting it up and running with their API. You will need to set up your own app within the [Twitter dev panel](https://dev.twitter.com/). Your Twitter app needs to have *read and write* access to your Twitter account for this to work. Once you have the app created you will need to copy the four OAuth keys into the `config.rb` file.

*You may need to regenerate your keys after changing your app from "Read" to "Read and Write".*

### Heroku Setup

Create a [Heroku app](https://www.heroku.com/) via the Heroku dashboard. Go back to your local git repo and add this Heroku app as a git remote.

### Launch

Run `git push HEROKU_REMOTE master` after committing all the necessary changes to the config.rb file. Heroku will detect what type of app it is automatically. Now set your process or worker dyno to 1 via the Heroku dashboard or the command line, `heroku ps:scale clock=1`

### Wrap Up

That's it. Whew. If for some reason the app isn't working, run `heroku logs` from the command line to see what the error was. If you still have issues, [create an issue on Github](https://github.com/asimpson/adn-crossposter) with any log message you can.
