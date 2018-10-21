Frustration post incoming. If you'd like to skip my ranting, [watch this breakdancing bear](http://maxgif.com/8p). Otherwise, let's keep going.

Update: I've posted an [update below](#update).

### Stuck

I've never developed anything using [Dropbox's API](https://www.dropbox.com/developers/reference/api) or [oAuth](http://oauth.net/) before. I'm assuming I'm making a horrible, noobish mistake somewhere in here. There is no official PHP SDK for Dropbox API. There are a couple libraries floating around, but they looked like overkill for the simple app idea I'm working on.

My problem is that when I try to [request a token](https://www.dropbox.com/developers/reference/api#request-token) from Dropbox via PHP and cURL I get an 'Error 4xx'. I've looked at the oAuth specs for the proper parameters to send in the header of the request, and right now my request looks like:

``` 

[request_header] => POST /1/oauth/request_token HTTP/1.1
Host: api.dropbox.com
Accept: <em>/</em>
Authorization: OAuth oauth_consumer_key="CONSUMERKEY", oauth_nonce="1340748835", oauth_signature_method="PLAINTEXT", oauth_timestamp="1340748835", oauth_version="1.0", oauth_signature="CONSUMERSECRET%26"
Content-Length: -1
Content-Type: application/x-www-form-urlencoded
Expect: 100-continue
```

And this doesn't yield a token, just 'Error 4xx'.

Yet, when I paste in the full request in the address bar of Chrome:

`  https://api.dropbox.com/1/oauth/request_token?oauth_consumer_key=CONSUMERKEY&oauth_nonce=1340743892&oauth_signature_method=PLAINTEXT&oauth_timestamp=1340743892&oauth_version=1.0&oauth_signature=CONSUMERSECRET%26`

I get my token back no problem. So I'm assuming something is wrong with the format of my cURL request.

The reason I'm using PLAINTEXT as the method is because of [this post](http://forums.dropbox.com/topic.php?id=49346&replies=9#post-373358) in the Dropbox forums. And, like I said, just entering in the request directly works fine.

### Help

Any ideas? Let me know on Twitter [@a\_simpson](http://www.twitter.com/a_simpson). I'll be sure to update this post once I get this problem sorted. So far, the lack of documentation for all this has been frustrating.

### Update

Well I've sorted it out after sleeping on it, and breaking it all down again.

Turns out the cURL options array I was passing was incorrect. I was declaring CURLOPT\_POST =\> true after several other POST-reliant options such as CURLINFO\_HEADER\_OUT and CURLOPT\_POSTFIELDS. This mix-up was causing the request to error out. In retropect I should have realized that right away, oh well. Once I got the order straightened out, the request went through.

However, in my Googling to solve my problem I came across an [awesome post from Wez Furlong](http://wezfurlong.org/blog/2006/nov/http-post-from-php-without-curl/) detailing how to do HTTP requests in PHP without using cURL or any other library. I'll let you read it, but all I'll say is I switched to the solution he outlines, and I love it.
