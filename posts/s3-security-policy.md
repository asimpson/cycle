I love S3, I use it with [Arq](http://www.haystacksoftware.com/arq/), I use it to host this site, backup configs on VPSs, and to transfer random files that are too big for e-mail.

As my S3 usage has grown I've started creating seperate AMI users for each task, e.g. a siteleaf user for this blog. It wasn't until tonight that I took the time to craft a better security policy for some of these users.

I struggled finding good policy examples until I stumbled across [this one](http://blogs.aws.amazon.com/security/post/Tx1P2T3LFXXCNB5/Writing-IAM-policies-Grant-access-to-user-specific-folders-in-an-Amazon-S3-bucke) over on the [AWS Security blog](http://blogs.aws.amazon.com/security/). I highly recommend reading it all the way through.

[Here's the basic policy I came up with](https://gist.github.com/asimpson/11335531). This policy restricts access to a single bucket, and allows access via the AWS cli.

Note: I had to move the policy to a [gist](https://gist.github.com/asimpson/11335531) as [prismjs](http://prismjs.com) was having a hard time with it.
