I've used a SOCKS proxy while on public WiFi ever since reading [Paul Stamatiou's article](http://paulstamatiou.com/how-to-surf-securely-with-ssh-tunnel) years ago. I recently took the time to automate the setup process.

Paul's article provides a good overview of what the heck a SOCKS proxy is and why it's beneficial, so I won't focus on any of that here. Just know that setting up a SOCKS proxy on a Mac is a multi-step process. This process led me to create [two bash functions](https://github.com/asimpson/dotfiles/blob/master/bash/functions#L10-L17); one to start it and another to shut it down.

    function tunnel_off {
      PID="$(ps aux | grep $1 | grep -v grep | awk '{print $2}')";
      kill ${PID} && networksetup -setsocksfirewallproxystate Wi-Fi off;
    }
    
    function tunnel {
      ssh -D 8080 -f -q -N $1 && networksetup -setsocksfirewallproxystate Wi-Fi on
    }

I do need to pass the ssh server name (configured in `~/.ssh/config`) I want to use, e.g. `tunnel vpn`.

The only setup is to manually configure which port I want to use for the SOCKS proxy, I set that in System Preferences under Network: ![](/images/socks-proxy-config.jpg)

The best part is the `networksetup -setsocksfirewallproxystate` [command](https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man8/networksetup.8.html). This command makes the whole thing go by toggling the proxy on and off.

For extra credit, I use the fantastic [TextBar](http://www.richsomerfield.com/apps/) utility to monitor if the ssh connection is active and [display the lightning emoji](https://github.com/asimpson/dotfiles/blob/master/tmux/tunnel-status.sh) in my menu bar if it is. I now know when the proxy is running or not by glancing up at the menubar.
