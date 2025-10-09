---
title: "Better scripting with gh"
date: 2023-07-22T11:33:16-0400
lastmod: 2023-07-22T11:49:30-0400
slug: better-scripting-with-gh
excerpt: "I've become a big fan of the <a href=\"https://cli.github.com/\">gh</a> CLI tool from Github. It has eliminated the need for me to manage developer tokens for my scripts."
---

I've become a big fan of the [gh](https://cli.github.com/) CLI tool from Github. It has eliminated the need for me to manage developer tokens for my scripts. Instead of using `curl` with a Github token and the Github API, I can simply use `gh`. What's even better is that in more advanced situations where there isn't a valid subcommand for what I want to script, I can use the [`gh api`](https://cli.github.com/manual/gh_api) escape hatch to do `curl`-style HTTP requests to the API without messing with authentication or even pagination. Here are two recent scripts I wrote that highlight the power and convenience of `gh`.

## PR Kudos

I created this script to help me give better kudos to folks in our retro meeting. When I provide a Github team name as an argument, it displays all PRs from members of that team. What I really like is that it only shows PRs from the last two weeks, which gives me a nice overview of recent activity.

```bash
#!/bin/bash

start=$(date -d "2 weeks ago" +%Y-%m-%d)
end=$(date +%Y-%m-%d)

details=$(gh api /orgs/grafana/teams/$1 | jq -r '"\(.id),\(.organization.id)"')
teamId=$(echo ${details} | cut -d , -f 1)
orgId=$(echo ${details} | cut -d , -f 2)

gh api "organizations/${orgId}/team/${teamId}/members" | \
  jq -r '.[] | .login' | \
  xargs -I % gh search prs --author=% --created="${start}..${end}" \
  --json="state,repository,url,title,updatedAt,author" --template '{{range .}}{{tablerow (.author.login | autocolor "green") (hyperlink .url .title) (.repository.name | autocolor "blue") (.state | autocolor "red") (timeago .updatedAt)}}{{end}}
{{tablerender}}'
```

## Notification OCD

The second script focuses on managing notifications related to pull requests and issues. I usually find that about one-third of my notifications are for merged PRs, PRs created by bots, or closed Issues. I don't care about these types of events. With this script, I can mark those notifications as done, which reduces clutter in my GitHub notifications and helps me see important updates. As I mentioned above, one cool feature of the `api` subcommand is that it allows me to consume all possible pages of a response using the `--paginate` flag, eliminating the need for a loop + token field dance!

```bash
#!/bin/bash
declare -A typeLookup
typeLookup["PullRequest"]="pull"
typeLookup["Issue"]="issues"

resp=$(gh api /notifications --paginate | jq -r '.[] | select(.subject.type == "PullRequest" or .subject.type == "Issue") | "\(.repository.full_name),\(.subject.url),\(.id),\(.subject.type)"')

for x in $resp; do
  name=$(echo "${x}" | cut -d ',' -f 1)
  id=$(echo "${x}" | cut -d ',' -f 3)
  number=$(basename $(echo "${x}" | cut -d ',' -f 2))
  ofType=$(echo "${x}" | cut -d ',' -f 4)
  urlType=$(echo ${typeLookup["${ofType}"]})
  isBot="false"

  if [ "${ofType}" == "PullRequest" ]; then
    isMerged=$(gh pr view --repo "${name}" "${number}" --json closed | jq -r .closed)
    isBot=$(gh pr view --repo "${name}" "${number}" --json author | jq -r .author.is_bot)
  fi

  if [ "${ofType}" == "Issue" ]; then
    isMerged=$(gh issue view --repo "${name}" "${number}" --json closed | jq -r .closed)
  fi

  if [ "${isMerged}" == "true" ] || [ "${isBot}" == "true" ]; then
    echo "marking https://github.com/${name}/${urlType}/${number} as done..."
    gh api -X PATCH "/notifications/threads/${id}"
  fi
done
```
