Here are a few custom little functions and aliases that I use everyday, these are all pretty straightforward, you can tweak any of these to fit your specific workflow.

![The Bash Brothers](/images/bash-bros.gif)

### MAMP Virtual Hosts

It's a pain to set up virtual hosts, which is why I wrote a bash script to automate that horrible process. Here is the script, I'll explain how it works below (or check out the [Gist](https://gist.github.com/3989062)):

```
    #!/bin/bash
    RED="\033[0;31m"
    YELLOW="\033[33m"
    REDBG="\033[0;41m"
    WHITE="\033[1;37m"
    NC="\033[0m"</p>

mkdir -p /Applications/MAMP/Library/vhosts;
mkdir -p /Applications/MAMP/Library/vhosts/domains;

if [ "$1" = "create" ] || [ "$1" = "add" ]; then
 # Ask for document root
  echo -e "${RED}Enter the document root (relative to 'htdocs'):${NC}";
  read documentRoot;

  # Ask for domain name
  echo -e "${RED}Enter local domain: (eg. local.com):${NC}";
  read domain;

   # Ask for port number
  echo -e "${RED}Enter MAMP Port Nubmer:${NC}";
  read port;

  # Add vhost
  touch /Applications/MAMP/Library/vhosts/domains/$domain;

  echo "<VirtualHost *:$port>
    DocumentRoot "/Applications/MAMP/htdocs/$documentRoot"
    ServerName $domain
    <Directory "/Applications/MAMP/htdocs/$documentRoot">
        Options All
        AllowOverride All
        Order allow,deny
        Allow from all
    </Directory>
</VirtualHost>" >> /Applications/MAMP/Library/vhosts/domains/$domain;

  echo "127.0.0.1 $domain" >> /etc/hosts;

  # Restart MAMP
  /Applications/MAMP/bin/apache2/bin/apachectl restart;

  echo -e "Finished. ${REDBG}${WHITE}$domain:$port${NC} has been copied to your clipboard.";
  echo "$domain:$port" | pbcopy;
fi

if [ "$1" = "remove" ] || [ "$1" = "delete" ]; then
    echo -e "${RED}Here are the current custom local domains:${NC}"
    for file in /Applications/MAMP/Library/vhosts/domains/*
    do
      if [ -f "$file" ];then
       echo -e "${YELLOW}${file##/*/}${NC}"
      fi
    done
    echo -e "${RED}Enter the site name you wish to remove:${NC}"
    read siteName;

    sed -i.bak "/$siteName/d" /etc/hosts;
    rm /Applications/MAMP/Library/vhosts/domains/$siteName;

    echo -e "${YELLOW}$siteName removed."
    fi
```

The script is set up to work with each web project being stored in a directory under htdocs in the MAMP folder. If you want to use a different folder structure, simply change the paths in the script to reflect your particular workflow.

The script asks for three pieces of info, the domain you want, the directory name, and the MAMP port number. The script creates a new directory called 'vhosts' and a sub directory called 'vhosts/domains'. Each file in 'domains' is a single domain, which makes this all easier to manage. The script then modifies your etc/hosts file with the new domain information. Finally, the script restarts MAMP apache and copies the new domain address to your clipboard.

The last piece to this puzzle is the function that fires this script off.

```
    function vhost {
      sudo ~/.dotfiles/osx/mamp_vh.sh $1
    }
```

Just specify the path to the script and you are set.

### Jump to project directory

Another pain point is jumping to a specific project directory quickly, and without a lot of path typing. I wrote a function that lists all the folders in my htdocs directory and lets me select the one I want to go to.

    function ht {
      local BLUE="\033[0;34m"
      local RED="\033[0;31m"
      local WHITE="\033[0;37m"
      local NC="\033[0m"
      echo -e "${BLUE}Projects:${WHITE}"
        for file in /Applications/MAMP/htdocs/*
        do
          if [ -d "$file" ];then
           echo ${file##/*/}
          fi
        done
      echo -e "${RED}Which Project?${NC}"
      read dir;
      cd /Applications/MAMP/htdocs/$dir
    }

Again, simply change the paths in the script to adapt this to your workflow.

### Colored History Grep

One little alias that I snagged from the numerous dotfile repos on Github is the 'h' alias which simply shortcuts the 'history' command. I love this little command, but I found myself typing out `h | grep keyword` to get a list of commands specific to a keyword. I shortened this up and added color highlighting:

    function hg {
      history | grep --color=auto $1
    }

Simply pass the function the term you are looking for. Remember you can execute previous functions by typing `!999` (999 being the number of the command).

### Keep tweaking and hacking

Hopefully these little utilities were useful in someway, feel free to comment or offer advice by reaching out on [twitter](http://twitter.com/a_simpson) or [adn](http://alpha.app.net/a_simpson).

### Update

I forgot to mention that I have two documents, one called "functions" and the other "aliases", which I source at the top of my .bash\_profile like this (You can see all my dotfiles over on [Github](https://github.com/asimpson/dotfiles)):

    . /.dotfiles/bash/functions
    . /.dotfiles/bash/aliases

Sourcing these files makes the functions and aliases inside them available on the command line. To use any of the functions or aliases in this post you have to source them to your bash, then you can simply type the alias or function name plus any arguments:

```
  vhost create
  hg term
  ht
```

Thanks to [Jack McDade](https://twitter.com/jackmcdade/status/270926210798854145) for the advice to include some examples.
