# Cycle Hugo Theme

A minimal, clean Hugo theme ported from the [Cycle static site generator](https://github.com/asimpson/cycle).

## Features

- Clean, minimal design using Tachyons CSS
- RSS feed support
- Archive page for all posts
- Support for link posts (external URLs)
- Responsive layout
- Custom pages (e.g., /uses, /support)

## Installation

### As a Git Submodule

```bash
cd your-hugo-site
git submodule add https://github.com/asimpson/cycle.git themes/cycle
```

### Configuration

Update your `hugo.toml`:

```toml
baseURL = "https://example.com/"
languageCode = "en-us"
title = "Your Site Title"
theme = "cycle"

[params]
  description = "Your site description"

[permalinks]
  post = "/writing/:slug/"

[outputs]
  home = ["HTML", "RSS"]

[outputFormats.RSS]
  mediatype = "application/rss+xml"
  baseName = "rss"

[services.rss]
  limit = 20
```

### CSS Files

Copy or create these CSS files in your site's `assets/` directory:
- `tachyons.css` - Main CSS framework
- `custom.css` - Site-specific styles

You can find example CSS files in `themes/cycle/assets/`.

## Content Structure

### Posts

Posts go in `content/post/` with YAML frontmatter:

```yaml
---
title: "Post Title"
date: 2024-01-01T10:00:00-05:00
lastmod: 2024-01-01T10:00:00-05:00
slug: post-slug
excerpt: "Post excerpt for listings and RSS"
---

Your post content here...
```

### Link Posts

To create a link post (pointing to external content):

```yaml
---
title: "External Article"
date: 2024-01-01T10:00:00-05:00
slug: external-article
excerpt: "Description of the external article"
link: "https://example.com/article"
---

Optional commentary about the link...
```

### Pages

Regular pages go in `content/page/`:

```yaml
---
title: "About"
permalink: "/about"
excerpt: "About this site"
type: "page"
---

Page content...
```

### Archive Page

Create an archive section by adding `content/archive/_index.md`:

```yaml
---
title: "Archive"
---
```

## Example Site

An example site with sample content is available in `exampleSite/`. To run it:

```bash
cd themes/cycle/exampleSite
hugo server
```

## Customization

The theme uses several partials that can be overridden:

- `layouts/partials/head.html` - HTML head content
- `layouts/partials/header.html` - Site header with navigation
- `layouts/partials/footer.html` - Site footer
- `layouts/partials/logo.html` - Site logo SVG
- `layouts/partials/post_body.html` - Individual post layout

## License

GPLv3 - See LICENSE file for details.
