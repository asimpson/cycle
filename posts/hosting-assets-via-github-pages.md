Screenshots in `README.md`s are really helpful to quickly demonstrate what your open source project does. Hosting those can be surprisingly difficult. There are a couple options:

## The Problem

1.  Upload the image to a image hosting service and then reference the direct URL in the `README.md`.
2.  Check the image into the repo and reference its `raw` URL in the `README.md`.

Both of these have their downsides. The first option means that your image is tied to the uptime of the image hosting service. If the service is down your image is now 404. Option two means you have the image mixed in with your source files which stinks from an organizational perspective.

## The Solution

The solution is fairly obvious but took me awhile to realize it: use [Github pages](https://pages.github.com) by pushing assets to the `gh-pages` branch.

Hosting assets via Github pages means I don't have to worry about the image hosting service uptime since Github is hosting both the `README.md` and the asset now. I also don't have to worry about those assets cluttering my source directories because Github pages uses a specific branch `gh-pages` and those assets only show up when that branch is checked out.

Here's a quick walk-through of how to push an image to Github pages (assuming there isn't a `gh-pages` branch yet).

1.  Create a `gh-pages` branch off of `master` (usually).
2.  Add the image to the repo via `git add /path/to/image`.
3.  Stage, commit, and push the branch to Github.
4.  Go to Github and head to your project settings to grab the Github pages URL. Append the asset name to the end of it and check if you can view the image in your browser.
5.  Go back to the command line and checkout `master`.
6.  Add the image to the `README.md` and check it in.
