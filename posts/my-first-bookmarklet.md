### Update

ESPN has wisely fixed this workaround as of 08/10. I'll leave the rest of the post up for posterity though.

### Original Post

It all started when I was doing my daily sports news catch-up, and clicked on a link that lead me to an [ESPN Insider article](http://www.espn.com/insider), only without the Insider paywall. I clicked on another Insider article and hit the paywall. I wondered if the Insider paywall simply checked the URL scheme, and didn't have any session or cookie security.

I compared the two links and noticed some minor differences, I decided to match the paywalled link to the structure of the non-paywalled link and it worked\! Now, I'm assuming ESPN knows this is one way around their Insider paywall, most paywalls seem to have holes (see NYT, WSJ, etc.).

Anyway, like any good geek, I went ahead and made my first ever bookmarklet to automate the URL matching. The code is below.

` javascript:(function(){ var pathArray = window.location.href; var newValue  = pathArray.split('&action='); var firstUrl  = newValue[0]+newValue[1]+newValue[1]; var secondUrl = firstUrl.split('login&'); var finalUrl  = firstUrl+'login%26'+secondUrl[2]; function readInsider() {   windowObjectReference = window.open(finalUrl, "_blank"); } readInsider(); })();`

You may have to hit the bookmarklet more than once for it to work. Despite the hacky nature of the code and skittish performance, the success of my quick little project has me thinking of how I can BOOKMARKLET ALL THE THINGS\!
