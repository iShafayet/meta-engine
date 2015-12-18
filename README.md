
# meta-engine

A language agnostic directive system and preprocessor.

Offers great power and flexibility without much change in your build process. All the processing happen inside your build process. So there is no runtime overhead at all.

# Features

* Language agnostic. Should practically work for all modern languages.
* Great support for indent/whitespace sensitive languages (i.e. CoffeeScript).
* Fills in only the blanks. Not trying to reinvent the wheel or replace template engines.
* Exposes a Programmatic API.
* Command Line tool comes alongside.
* Classically written and easily extensible.
* Very well documented.
* Not hardcoded to use the `fs` module. Can be used with absolutely any sort of data source, not just files.

# Installation

```bash
[sudo] npm install meta-engine
```

# Quick Overview

meta-engine (as of now) has 2 kinds of directives.

1. `@region` and `@use`
2. `@include`

### @region and @use

`@region` tags a block of code so that it can be reused somewhere else using `@use`.

**declare a region**
```coffee
@region "a-name"
```
supported option(s): `indented`

**use a region**
```coffee
@use "a-name"
```
supported option(s): `match-indent`, `as-is`

### @include

Include a file. the contents of that file will be inserted where the @include tag is.

**including a file using it's relative path**
```coffee
@include "filepath"
```
supported option(s): `isolated`

# Examples

### Plain HTML Project

**header.html**

```html
@region "common-header" indented
  <div class="header">
    <div class="title">My Webpage</div>
    <div class="slogan">For a better world</div>
  </div>
```

**index.html**

```html
@include "./header.html"
<html>
<body>
  @use "common-header"
  <div>
    Welcome to my page
  </div>
</body>
</html>
```

**about.html**

```html
@include "./header.html"
<html>
<body>
  @use "common-header"
  <div>
    A place to rant about your great website.
  </div>
</body>
</html>
```

# Full Usage

See [Full Usage](docs/full-usage.md) before you jump in.

# Programmatic API

See [Programmatic API](docs/api.md) in order to incorporate it into your custom build process. And if you are using **gulp**, we got you covered. Scroll below.

# Command Line Tool

See [metae](https://github.com/ishafayet/metae) to learn more about how to access the full potential of the command line tool. It even walks a directory for you.

# Gulp

See [gulp-meta-engine](https://github.com/ishafayet/gulp-meta-engine)

# Testing

You need [mocha](https://github.com/mochajs/mocha)

`npm test`


# Contributing

We actively check for issues even for the least used repositories (unless explicitly abandoned). All of our opensource repositories are being used in commercial projects by [SoftEvolve](https://softevolve.com), [teamO4](https://teamo4.com), [BDEMR](https://bdemr.com) or [BBS Enterprise](https://bbsenterprise.com). So, it is very likely that we will sort out important issues not long after they are posted.

Please create a github issue if you find a bug or have a feature request.

Pull requests are always welcome for any of our public repos.



