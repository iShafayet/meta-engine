
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
2. `@include`
3. `@describe`

### @region and @use

`@region` tags a block of code so that it can be used later using `@use`.

**declare a region**
```coffee
@region "a-name"
```

or declare a region and declare it as indentation sensitive
```coffee
@region "a-name" indented
```
the `indented` option makes sure that whenever the region is used, the indentation is matched to the destination unless the destination has the option `as-is`.

**use a region**
```coffee
@use "a-name"
```
indentation will be matched if the `@region` is `indented`

or use a region and do not match indentation
```coffee
@use "a-name" as-is
```
`as-is` has higher priority than `indented`


### @include

Include a file. the contents of that file will be inserted where the @include tag is.

```coffee
@include "filepath"
```

Filepath is relative to the current file. `.`, `..`, `/` are supported. quotations are mandatory.

Unlike `@use`, `@include` is always *as-is*. included content is never altered to match destination. If you need that feature, just wrap the source inside a `@region`.

All the `@include`s are resolved before the `@region`s are parsed. this can be overriden by using the option `isolated` which makes sure the `@region`s and `@use`es are evaluated (and flattened) before returning to the parent file.

# Examples

### Plain HTML Projects

**header.html**

```html
@region "common-header"
  <div class="header">
    <div class="title">My Webpage</div>
    <div class="slogan">For a better world</div>
  </div>
```

**index.html**

```html
@include './header.html'
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



