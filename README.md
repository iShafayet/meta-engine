
# meta-engine

A language agnostic directive system and preprocessor.

Offers great power and flexibility without much change in your build process. All of these are pre-compilation. So you do not add any runtime overhead.

# Installation

```bash
[sudo] npm install meta-engine
```

# Quick Overview

meta-engine basically has 3 (kinds of) directives.

1. `@region` and `@use`
2. `@describe`
3. `@include`

### @region and @use

`@region` tags a block of code so that it can be used later using `@use`. 

```html
@region "common-header"
  <div class="header">
    <div class="title">My Webpage</div>
    <div class="slogan">For a better world</div>
  </div>
```

```html
<html>
<body>
  @use "common-header"
  <div>
    My Content Here
  </div>
</body>
  
```

# Gulp

See [gulp-meta-engine](https://github.com/ishafayet/gulp-meta-engine)

# Testing

You need [mocha](https://github.com/mochajs/mocha)

`npm test`


# Contributing

We actively check for issues even for the least used repositories (unless explicitly abandoned). All of our opensource repositories are being used in commercial projects by teamO4 or bbsenterprise. So, it is very likely that we will sort out important issues not long after they are posted.

Please create a github issue if you find a bug or have a feature request.

Pull requests are always welcome for any of our public repos.



