

# @region

the `region` tag marks a block of code with a label so that it can be used (or re-used) later.

### A `region` must always have a name.

The name is always inside double quotes, can be alphanumeric. hyphens, dots and slashes are allowed.

```html
@region "common-header"
  <div class="header">
    <div class="title">My Webpage</div>
    <div class="slogan">For a better world</div>
  </div>
```

### A `region` may contain the optional `indented` parameter.

The `indented` parameter makes sure that the indentation level of the block of code is altered according to the indentation level of area where it is being `use`d. Detailed examples in the `@use` section.

### A `region` may be overriden by another region of the same name.

### `region`s span across multiple files. 
This behaviour can be switched of using the `isolated` parameter for `include`. Discussed in the `@use` section.

### Programmatic `region`s
One can provide multiple global level `region`s through programmatic apis. These disregard the `isolated` tag. Meaning these are always available. Read the programmatic apis for more info.



