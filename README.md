## md_to_html ##

This is a simple transformer that converts all Markdown files into HTML based on a provided template.

To use, add `md_to_html` to your pubspec:

    dependencies:
        md_to_html: ">=0.1.0 <0.2.0"

Then, add the transformer and set the `template` property to the location of a Mustache-style template:

    transformers:
        md_to_html:
            template: "web/template.html"

In the template, the `{{content}}` tag will be replaced with the generated HTML from your Markdown. You can fill other tags by adding JSON to the beginning of your Markdown file.

For example:

    {"title": "My Title"}

    ## This is a header

    This is a paragraph.

With a template:

    <html>
    <head><title>{{title}}</title></head>
    <body>{{content}}</body>
    </html>

Would render as:
    <html>
    <head><title>My Title</title></head>
    <body><h2>This is a header</h2>
    <p>This is a paragraph.</p></body>
    </html>


