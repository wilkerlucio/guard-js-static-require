# Guard Javascript Static Require

This guard watches for new/removed javascript files and automatic inject the script tags for loading them on an html page.

## Setup

Install the guard as a regular gem:

    gem install guard-js-static-require

Or add it to your Gemfile:

    gem "guard-js-static-require"

## Configuration

This is the default template for static require:

    guard "js-static-require", :libs => ["vendor", "lib"], :updates => "examples/index.html"

This will watch (recursively) on folders `vendor` and `lib` for javascript files, and when changes are detected it will update the `examples/index.html` file.
If you need to update more than one file, add a new guard.

You HTML file need to have the begin and end blocks, the javascript load will be inject in the middle of them (look at sample code below).

## Sample HTML

```html
<!DOCTYPE html>
<html>
  <head>
    <title>My Page</title>
    <!-- START JS_STATIC_REQUIRE -->
    <!-- END JS_STATIC_REQUIRE -->
  </head>
  <body>
    <h1>My Page</h1>
  </body>
</html>
```
