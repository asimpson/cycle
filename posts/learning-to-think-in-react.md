Some of you may have noticed that this blog has been going through some renovations. I’ve spent the last couple months moving off [Siteleaf](http://siteleaf.com/) and towards a hosted WordPress install. My ultimate goal is to use Wordpress strictly for managing content and to attach a separate front-end written in React.js. While not completely finished, I’m at the point where all pieces are functional enough that I feel comfortable to begin sharing what I’ve learned through the process.

## React

At the moment, React is definitely the cool kid on the Javascript framework block, which history tells us is a perilous and passing position. Regardless, I’ve been intrigued by its philosophy and decisions for a while. Love Facebook or hate them, you can’t deny they have a [fantastic engineering team](https://code.facebook.com/) solving some of the hardest problems on the web. My interest in React stems from the fact that that, instead of setting out to solve all the problems of building a web app, it aims to solve just one: the complexity of building user-interfaces. Facebook explains how React makes building UIs easier in [a perfect introductory post](https://facebook.github.io/react/blog/2013/11/05/thinking-in-react.html) (which I’ve gone back to many times) that walks through building up a frontend from scratch. Because React is focused on the user interface, it isn’t a very large API to learn. This focus encourages you to use any other tooling, frameworks, or libraries for other aspects of your app.

## Isomorphic

React’s other big draw for me is that it easily enables an isomorphic structure for your web application, which simply means that the same code can render HTML pages on the server and render HTML in the browser. React accomplishes this via two render methods: `render` and `renderToString`. `render` is the default method that inserts the React HTML into a DOM node, and `renderToString` does what it says on the tin by passing the HTML out as a string.

The biggest challenge has been learning to think "isomorphically." Thankfully, there are several fantastic articles that walk through how to structure and reason about an isomorphic app. [Nicolas Hery has a fantastic overview](http://nicolashery.com/exploring-isomorphic-javascript/) of what an isomorphic app structure can and *should* look like; I still have this one open in my browser, as I refer to it constantly. I was inspired by [James Long’s excellent post](http://jlongster.com/Presenting-The-Most-Over-Engineered-Blog-Ever) on moving his blog to React. Additionally, [Charlie Marsh’s post](http://www.crmarsh.com/react-ssr/) helped me get off the ground when it comes to writing an isomorphic app with React.

## Data flow

Having an isomorphic app means data flow in the app is going to change, and I definitely bent my brain trying to figure out a reasonable approach. The [aforementioned Hery article](http://nicolashery.com/exploring-isomorphic-javascript/) does a great job of outlining one possible solution. Facebook of course has its Flux architecture as the "preferred" approach, but I opted for a simpler approach more akin to [James](http://jlongster.com/Presenting-The-Most-Over-Engineered-Blog-Ever)’ flow. Essentially, I defined a [static function](https://facebook.github.io/react/docs/component-specs.html#statics) called `fetchData` anywhere I needed to request data. I then called this function on the router level.

## React-router

Speaking of the router, I’m using the awesome and delightful [React-router](https://github.com/rackt/react-router). React-router is a fantastic example of how to maintain an open-source project. [This post announcing changes to its API](https://github.com/rackt/react-router/wiki/Announcements#whats-the-deal-with-the-new-api) reveal the depth of thinking and intentionality of React-router’s authors. I’ve poured over the docs and issues in the course of this project and have been impressed with it constantly.

I’m using React-router to handle routes on the server and the client (yay, isomorphic\!) with React’s `render` and `renderToString` methods. This means that I have a `server-routes.js` file and a `client-routes.js` file, which are the only two files that *aren’t* shared between the client and the server. I’m using a vanilla Express server to kickoff the server portion of the blog. React-router simply plugs in as middleware to handle serving up the application. On the client, I have React-router using the History APIs to navigate, which greatly increases the perceived performance of the site.

## Promises

This was my first experience working with Promises in Javascript. I don’t know how I could have done this project without them - I’d probably still be untangling all the callbacks. Luckily, the brilliant minds behind [CujoJS](http://cujojs.com/) have not only a [great promises library](https://github.com/cujojs/when), but also a [rest library that returns promises](https://github.com/cujojs/rest). Moreover, both libraries work in the browser and on the server. The pattern I followed for my data fetching looks like this:

    var promises = state.routes.filter(function (route) {
      return route.handler.fetchData;
    }).reduce(function (promises, route) {
      promises[route.name] = route.handler.fetchData(state.params);
      return promises;
    }, {});
    
    resolveHash(promises).then(function (data) {
      React.render(<Handler data={data}/>, container);
    });

Sidenote: For a fantastic primer on `.map`, `.reduce`, and `.filter`, check out [Elijah Manor’s post](http://www.elijahmanor.com/reducing-filter-and-map-down-to-reduce/).

These functions go in [react-router’s run callback](https://github.com/rackt/react-router/blob/master/docs/api/run.md). The `state.routes` object contains the matching route components, so you can filter over them and get all the necessary `fetchData` functions. We massage this object of functions into a key:value structure to use with the `resolveHash` method that ships with [whenjs](https://github.com/cujojs/when). `resolveHash` will call all the `fetchData` methods, and once all data has been fetched it calls back to React to render with the new data. This is all possible because, thanks to [rest](https://github.com/cujojs/rest), every `fetchData` method returns a promise. Here is an example of what a `fetchData` function looks like:

    fetchData: function(pageNumber) {
      var fetchPosts = rest(url).then(function(response) {
        var postInfo = {
        };
        return postInfo;
      });
      return fetchPosts;
    }

## Going Forward

I think that covers the React portion for now. I've pulled the React portion out of my private repo and [published it on Github](https://github.com/asimpson/react-blog), feel free to browse around. I hope to outline other interesting pieces of the blog, including the WordPress side of things, soon. Feel free to ping me on [twitter](http://twitter.com/a_simpson) with any questions.
