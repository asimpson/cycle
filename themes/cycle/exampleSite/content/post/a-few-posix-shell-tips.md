---
title: "A few POSIX shell tips"
date: 2021-07-19T14:53:16-04:00
lastmod: 2021-07-19T14:53:16-04:00
slug: a-few-posix-shell-tips
excerpt: "I wrote down a few of my most used POSIX shell commands and features."
---

I was recently working on the [release build script](https://github.com/sparkbox/sb/commit/f9d2a0bc5339c4777e73432d9a8208b092a2e9ac) for [`sb`](https://github.com/sparkbox/sb) and decided I should document a few things I find myself looking up just about every time. One of the advantages of the POSIX shell (not bash, zsh, but Bourne shell, usually `/bin/sh` on most unix-y systems) is that it has [a specification](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/contents.html) however I'm usually frustrated trying to find the information I need.

<aside class="pa2 bg-light-gray">
`sb` is a tool I'm working on at [Sparkbox](https://sparkbox.com) to automate SSH authentication via SSH Certificates and Slack's ["Sign on with Slack"](https://api.slack.com/docs/sign-in-with-slack) feature.

You can check it out here: [https://github.com/sparkbox/sb](https://github.com/sparkbox/sb)
</aside>

I prefer the POSIX shell because it's _the default_ on most unix-y system. If I have to be sure if the shell is installed on the target system (like `bash` or `zsh`) I'd rather just use a higher-level scripting language like node or ruby where the same requirement exists.

## Arrays

Psych! There aren't any arrays. Bash has arrays but POSIX does not. If I need an array structure I can use a space-separated string (or another delimiter if you've set [`$IFS`](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_05_03)) as the data structure, e.g. `PLATFORMS="arm64-darwin amd64-linux amd64-darwin"`. Now I can loop over the variable using a for loop:

```sh
PLATFORMS="arm64-darwin amd64-linux amd64-darwin"

for PLATFORM in ${PLATFORMS}; do
  # GOOS=FOO GOARCH=BAR go build ...
done
```

Or I can take the lack of arrays as a signal I should stop writing a shell script and reach for a language that has the concept of arrays to solve my problem.

## Conditional "flags"

I often forget the various flags one can use in a conditional (aka test/if) statement. Here's the [documentation](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/test.html) and here are a few of my favorites:

- `-n` tests if the string is non-zero, e.g.

```sh
if [ -n "${UPLOAD_URL}" ]; then
    upload_file "${PLATFORM}"
fi
```

- `-z` the opposite of `-n`.
- `-f` tests if the pathname resolves to a file.

## Functions and args

- Functions must be declared before they are invoked.
- Functions look like:

```sh
someFunc() {
  echo "a func!"
}
```
- There is no syntax for functions accepting args instead they are mapped to `$n`. `$@` is all the args.

```sh
upload_file() {
    NAME=$1

    zip "${NAME}.zip" "${NAME}"
    curl -H "Accept: application/vnd.github.v3+json" \
         -H "Authorization: Bearer ${GITHUB_TOKEN}" \
         -H "Content-Type: application/zip" \
         --data-binary "@${NAME}.zip" \
         "${UPLOAD_URL}?name=${NAME}.zip"
}

upload_file "${PLATFORM}"
```

## Use shellcheck
This is just preference but I really love using [`shellcheck`](https://www.shellcheck.net/) to avoid any footguns and enforce a consistent style with my shell scripts. I typically invoke it like this: `shellcheck -o all script-name.sh`.
