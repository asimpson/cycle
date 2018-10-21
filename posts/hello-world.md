I'm proud, nervous, and a little surprised that adamsimpson.net is finally live\! It has been a long time in the making, and I'm relieved to have it up. Now the fun begins.

### A Little About Me

To sum me up, I'll bust out the 'ol bullet points.

  - I work for a [small web shop](http://www.fewloosescrews.com), based in Pennsylvania (though I live in Ohio) and do anything from front-end development and design to "social media" and copy-writing.
  - I am twenty-five years old and married to the greatest gal there is.
  - I graduated from [college](http://www.cedarville.edu) with a degree in English Lit (the web is made of words, so this works, right? right?).
  - I love: the interwebs, design, development, David Foster Wallace, C.S. Lewis, Don DeLillo, and Jimmy Eat World.
  - I dislike: most vegetables, Windows (not the ones in buildings), Jane Austen, bad drivers, and when the blinds in our apartment are open at night, it just skeeves me out.

### About This Site

Still here uh? Brave. Very brave. You have leveled up +1 in patience.

Anyway, my vision for this site is a place where I can share the things I'm learning as I do my job, so lots of nerdy posts about front-end development stuff, design stuff, and writing stuff. I'll probably also throw in observations on the latest tech gadgetry. I may also do more general posts regarding general creative work or whatever else strikes my fancy.

### Technical Bits

This site is powered by [Jekyll](http://jekyllrb.com/), a static-site generator. Jekyll is fantastic for a number of reasons, but I love it because I give it text files, and it gives me my site.

I've modified my Jekyll install a bit. I added [Steven Romej's permalink changes](https://github.com/azsromej/jekyll/commit/4b039b2804bc34382add7462f4e0f47c255e2151) to stop Jekyll from creating 'post-name-as-a-folder-\>index.html' to 'post-name-as-a-file.html'. I also adopted the pagination changes from [Dane Harrigan's fork](https://github.com/daneharrigan/jekyll).

Jekyll is running on top of a [Linode 512](http://www.linode.com/?r=a4bf52b7804eb5bb3add85d3caeeee5f1d84cf67) running Unbuntu and [Nginx](http://nginx.com/). I added one line to my Nginx conf file to support better permalinks thanks to [this great post](http://www.allampersandall.com/2012/06/nginx-rewrite-remove-html). I just used the one line, `try_files  $uri.html  $uri/ 404.html;`.

My posting process is simple and straightforward, all I need is Dropbox and a text editor. Usually this means I am using [iA Writer](http://www.iawriter.com/), which happily melds the two requirements (and works on my iPhone, iPad, or Mac). I simply write a post and save it in my posts folder in Dropbox. Dropbox takes care of syncing it to the Linode which has Dropbox and a shared copy of my site folder. When a new post is synced up, Jekyll builds my site with the new data and it's done, the post is live.

Now I owe [Ted Kulp](http://tedkulp.com/2011/05/22/automating-jekyll-builds/) and [Tyler Hall](http://clickontyler.com/blog/2011/11/publishing-your-blog-with-dropbox-and-jekyll/) a beer for their posts that got me going with this Dropbox to Jekyll setup. I followed Mr. Kulp's idea and had [incron](http://inotify.aiken.cz/?section=incron&page=doc&lang=en) fire a little bash script when a new post came in from Dropbox.

The other obvious benefit to having my site in Dropbox is that my site is automatically backed up.

### Hardware

And now, the infamous, what-do-I-use-at-my-desk section.

Well, I currently use a 15" MacBook Pro circa 2009. I connect it to an old 20" Dell LCD at my desk, and also use a Apple Wireless Keyboard, and Magic Mouse.

I also have an iPhone 4, iPad 2, and a Kindle.

Overall, I'm happy with my current setup, though I do plan on picking up an SSD + 8GB of RAM in the near future.

### Software

As I already mentioned, I use [iA Writer](http://www.iawriter.com/) to write this site, and also for any writing needs for work. I also use [Simplenote](http://simplenoteapp.com/) & [NValt](http://brettterpstra.com/project/nvalt/) for quick thoughts and to-do lists on the go.

I use Fireworks and Photoshop for any design related work. I use a combination of [Transmit](http://panic.com/transmit/) and [Sublime Text 2](http://www.sublimetext.com/2) for my FTPing and coding needs. Terminal is usually open for Git, or server tomfoolery.

Finally, for my browsers I use Safari & [Chrome Canary](https://tools.google.com/dlpage/chromesxs) for browsing and development respectively.

### The End

I hope this wall of text isn't too intimidating and that you learned a little bit about me and what makes this site tick. Just a word of warning, the look and feel of this site may change from time to time. I love to tinker, so consider it a constant work in progress. Thanks for reading.

Stick around and enjoy the ride with me\!

\-Adam
