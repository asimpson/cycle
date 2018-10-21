Last week I gave a short introduction to using npm as a build tool at [GemCity JS](http://gemcityjs.com).

> Here are the links and repo for my talk about "NPM as a build tool" at [@GemCityJS](https://twitter.com/GemCityJS).<https://t.co/pByIGcRNpO>
>
> — Adam Simpson (@a\_simpson) [October 15, 2015](https://twitter.com/a_simpson/status/654693173667622914)

## Rewrite?

There were a few questions about how to start using npm as a build tool on an existing project. The short answer is: start abstracting tasks behind [npm scripts](https://docs.npmjs.com/misc/scripts). This weekend I migrated this blog to [my new favorite host](https://chunkhost.com/r/46012) and ended up replacing a [grunt](http://gruntjs.com) task with a npm task. Here's how it went down.

## Pick a task

I was using two plugins, [grunt-usemin](https://github.com/yeoman/grunt-usemin) and [grunt-rev](https://github.com/cbas/grunt-rev), to "fingerprint" or rev my asset files. It *barely* worked (only some files were properly rev'd and inserted) and it was awkward. Usemin requires specific HTML comments so that it knows what files to replace. I finally decided to write my own rev task.

## The old

For reference here is my old Grunt config:

``` coffeescript

 rev:
  files:
    src: ["public/js/browser.js", "public/css/base.css"]

  usemin:
    html: 'server/app.hbs'
    options:
    assetsDirs: 'public/'

  useminPrepare:
    html: ['server/app-tmp.hbs']`
```

These tasks were run in this order during deployment: `rev, useminPrepare, usemin`.

## The plan

I stared off by jotting down the flow and transformations required for revving my assets. I came up with this list:

1.  Compile assets (sass, babel)
2.  Rev them (this is just magic right?)
3.  Overwrite non-rev'd paths in `app.hbs`.

That list was terribly shortsighted. Here's how it actually turned out:

1.  Compile assets
2.  Generate rev filename for each asset
3.  Write new asset file with rev'd filename for each asset.
4.  Create (force if necessary) `app.hbs` from `app-tmp.hbs` (-tmp for template)
5.  Read `app.hbs` as a string.
6.  Replace non-rev'd paths with rev'd paths in `app.hbs` using `String.replace()`.

Seem like this might be more code and trouble than it's worth? Not at all.

## The new task

Since we're going to replace a grunt task with a npm script task, lets use ES6 goodness. I [installed `babel`](https://babeljs.io) which lets me execute scripts [using `babel-node` instead of `node`](https://babeljs.io/docs/usage/cli/#babel-node). I then created a new directory called `tasks/` and named my new task file, `tasks/rev.js`. I also installed the super awesome [rev-file](https://www.npmjs.com/package/rev-file) package to handle the reving.

The code turns out to be fairly succicent:

``` javascript

import rev from "rev-file";
import path from "path";
import fs from "fs-extra";

const projectPath= path.dirname(__dirname);
const tmp = `${projectPath}/server/app-tmp.hbs`;
const app = `${projectPath}/server/app.hbs`;

fs.copySync(tmp, app, {'clobber': true});

const assets = [
  `${projectPath}/public/css/base.css`,
  `${projectPath}/public/js/browser.js`
];

assets.forEach((f) => {
  const revPath = rev.sync(f);
  fs.copySync(f, revPath);
  const appString = fs.readFileSync(app, 'utf8');
  fs.writeFileSync(app, appString.replace( path.basename(f), path.basename(revPath) ));
});
```

## Wrap it up

Now I have a task. How do I integrate this into my existing Grunt process? [npm scripts](https://docs.npmjs.com/misc/scripts) to the rescue. I created a new script entry in my `package.json` like this:

``` javascript

"scripts": {
  "start": "node ./bin/www",
  "rev": "babel-node tasks/rev.js"
}
```

npm scripts can be called directly using `npm run`, `npm run rev` in this case. The final step is to modify my `Gruntfile` to run the rev command using the handy [grunt shell plugin](https://github.com/sindresorhus/grunt-shell):

``` language-coffeescript

  shell:
    rev:
      command: "npm run rev"
```

And that's all I had to do. Now I can continue to replace pieces of my build system with npm scripts without having to do a big re-write. Using npm as a build tool also illustrates the simplicity of some of these tasks. It's much easier to maintain a 20 line task than to keep multiple plugins up to date.
