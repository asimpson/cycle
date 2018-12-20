I've migrated my apps off [Heroku](https://www.heroku.com/) and won't be using the service for personal apps going forward. Why? Let me back up a bit and explain what was so great about Heroku.

## Haiku? Ha-who?

Heroku is a "hosting as a service" company. They try to take away the pain of deploying and managing web applications. They actually do this quite well, it's a great service. The "secret sauce" that made Heroku so good was it's free pricing tier. The free tier essentially allowed a single web or a single "worker" process to run 24/7. There was enough processing power to run apps or processes for a small number of users, perfect for apps like my [six plus checker](/writing/iphone-checker-with-capybara-and-twilio) or [youtuberss app](http://ytrss.co).

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Ever tried subscribing to a <a href="https://twitter.com/YouTube?ref_src=twsrc%5Etfw">@YouTube</a> channel via RSS? It&#39;s way difficult/impossible, so I made this.<br><br>📢 Introducing <a href="http://t.co/PueJLtWd3u">http://t.co/PueJLtWd3u</a></p>&mdash; Adam Simpson (@a_simpson) <a href="https://twitter.com/a_simpson/status/615897507592278018?ref_src=twsrc%5Etfw">June 30, 2015</a></blockquote>

If apps grew popular enough they would hit processing limits and I could go in and scale the app up to meet demand. Scaling an app also meant that I was no longer in the free tier and would begin paying Heroku for the additional resources. It really was an ideal setup (from my perspective as a developer).

## Sadness

Sadly, Heroku [announced a few months ago](https://blog.heroku.com/archives/2015/5/7/new-dyno-types-public-beta) a pretty big shift in their pricing. The free tier would no longer run 24/7 as a single process:

> Every app using free dynos can include not just a free web, but also one free worker, and free usage of heroku run and Heroku Scheduler. Free dynos can run up to *eighteen hours a day, but have to “sleep” for at least the remaining six*. That’s eighteen hours each of serving traffic, running a background worker, and scheduled processes

I totally get they are trying to offer *more* of their platform in "demo mode" but I think it's the wrong move. To be clear, I'm not griping about a free lunch going away. I'm griping because the new pricing:

1.  Is harder to understand and manage. Seriously, I'm supposed to monitor my app in 18 hour increments?
2.  Doesn't incentivize developers to try out new apps that could potentially become paying applications.

Re: \#2, The very impressive [emojitracker](http://emojitracker.com) [was built on Heroku's platform](https://medium.com/@mroth/how-i-built-emojitracker-179cfd8238ac). Matthew Rothenberg, the project's developer, recounts how Heroku let him easily scale to meet demand:

> I did this manually. That first evening I needed a break from intense computer usage all day, so I actually spent the evening in a bar across the street from my apartment with some friends, having a drink while passively monitoring these charts on some iPhones sitting on the table. Whenever it looked like something was spiking, I used the Nezumi Heroku client to scale up instances from my phone directly. I didn’t even have to put down my drink\!

This is awesome. It illustrates the ideal scenario: no money up front to try something out and a natural path to scaling it up if it takes off. Simple, it was.

## Where to now?

I tweeted yesterday:

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Slowly migrating my apps away from Heroku. The new free tier restrictions are such a bummer.</p>&mdash; Adam Simpson (@a_simpson) <a href="https://twitter.com/a_simpson/status/650737554183094272?ref_src=twsrc%5Etfw">October 4, 2015</a></blockquote>

I've now finished moving my node apps over to [Chunkhost](https://chunkhost.com/r/46012). With Chunkhost I get 1GB of RAM for under $5/month by paying yearly and via bitcoin (I use [Coinbase](https://www.coinbase.com/join/526d7fc9d296a258e800005c) to purchase and manage Bitcoins). In comparison, Digital Ocean offers 512MB of RAM for $5/month. With the extra overhead from Chunkhost, I can easily host multiple apps on the same box. Plus, I've found that the two node apps I have running are both only using \~50MB of RAM\!

## Sysadmin

Yes, with Chunkhost I have to play as sysadmin and keep the VPS running. However I'm in total agreement with this [quote from Marco Arment](http://www.marco.org/2014/03/27/web-hosting-for-app-developers):

> Modern Linux server administration is much easier than you think. If you can write a halfway decent app, you can manage a Linux VPS in your sleep.

He's exactly right, managing a VPS isn't beyond the abilities of anyone who can write an app and put it on Heroku. I've found [Ansible](http://www.ansible.com/get-started) + [Bitbucket private repos](http://bitbucket.org) + [PM2](http://pm2.keymetrics.io) a great deployment and management combo; one that I'll write more about later. It took some effort to set up, but now I can launch new apps in minutes.

Heroku's new pricing has forced me to branch out and figure out how to host, manage, and deploy my apps. Perhaps the pricing change wasn't *all* bad after all.
