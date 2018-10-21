This week I wrote a [bash function](https://github.com/asimpson/dotfiles/blob/master/bash/functions#L10) that `curls` the [SendGrid API](https://sendgrid.com/pricing) and sends a [Boxcar](https://boxcar.io) notification. This is useful to chain to the end of long-running commands, e.g. [transcoding a video](https://github.com/donmelton/video_transcoding). When the command finishes I get a push notification on my phone.

If you're unfamiliar with the various ways to chain commands together in bash, [here's a cheatsheet](http://askubuntu.com/a/539293). One thing I didn't know is that you can *combine* the various operators like `long-running command || alert "failure!" && alert "success!"`.

Happy scripting.
