

# @region

the `region` tag marks a block of code with a label so that it can be used (or re-used) later.

### A `region` must always have a name.

The name is always inside double quotes, can be alphanumeric. hyphens, dots and slashes are allowed.

```html
@region "common-header" indented
  <div class="header">
    <div class="title">My Webpage</div>
    <div class="slogan">For a better world</div>
  </div>
```

### A `region` may contain the optional `indented` parameter.

The `indented` parameter makes sure that the indentation level of the block of code is altered according to the indentation level of area where it is being `use`d. Detailed examples in the `@use` section.

### A `region` may be overriden by another region of the same name.

The last one takes precedence. 

### `region`s span across multiple files. 
This behaviour can be switched of using the `isolated` parameter for `include`. Discussed in the `@use` section.

### Programmatic `region`s
One can provide multiple global level `region`s through programmatic apis. These disregard the `isolated` tag. Meaning these are always available. Read the programmatic apis for more info.

# @use

the `use` tag inserts the named `region` in the current position.

```html
<body>
  <div>
    @use "common-header"
  </div>
</body>
```

will result in 

```html
<body>
  <div>
    <div class="header">
      <div class="title">My Webpage</div>
      <div class="slogan">For a better world</div>
    </div>
  </div>
</body>
```

### `use` respects the `region`'s `indented` parameter.
In the previous example, if the `region` did not have the `indented` tag, the results would be

```html
<body>
  <div>
  <div class="header">
    <div class="title">My Webpage</div>
    <div class="slogan">For a better world</div>
  </div>
  </div>
</body>
```

### `use` accepts the `match-indent` parameter
In the previous example, if the `region` did not have the `indented` tag BUT the `use` tag had the `match-indent` parameter,

```html
<body>
  <div>
    @use "common-header" match-indent
  </div>
</body>
```

results would be

```html
<body>
  <div>
    <div class="header">
      <div class="title">My Webpage</div>
      <div class="slogan">For a better world</div>
    </div>
  </div>
</body>
```

### `use` may disregard `indented` with the `as-is` parameter.

`as-is` takes absolute precedence.


```html
<body>
  <div>
    @use "common-header" as-is
  </div>
</body>
```

results would be, even if the `region` had the `indented` parameter.

```html
<body>
  <div>
  <div class="header">
    <div class="title">My Webpage</div>
    <div class="slogan">For a better world</div>
  </div>
  </div>
</body>
```

# @include

the `include` tag can be used to import the contents of another file into current file.

### `include`d files share namespace.

All the `region`s of the parent are available in the child and vice-versa.

### `include`s may be forced to work in `isolated` namespace

Using the `isolated` paramer, an `include`d file can be forced to be *flattened* (as in all the `use` tags processed) before it's contents are included in the parent.

### `include` can be infinitely nested.

There is virtually no limit imposed by the developer.


