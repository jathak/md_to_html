// Initial structure of transformer based on sample code
// Copyright (c) 2014, the Dart project authors.
// Released under the same BSD license as this package.

import 'package:barback/barback.dart';
import 'package:markdown/markdown.dart';
import 'package:mustache_no_mirror/mustache.dart' as Mustache;

import 'dart:async';
import 'dart:convert' show JSON;

class MarkdownTransformer extends Transformer {

    final BarbackSettings _settings;

    MarkdownTransformer.asPlugin(this._settings);

    String get allowedExtensions => ".md .markdown .mdown";

    Future apply(Transform transform) {
        return transform.primaryInput.readAsString().then((content) {

            var id = transform.primaryInput.id.changeExtension(".html");

            String templatePath = _settings.configuration['template'];
            return new Asset.fromPath(id, templatePath).readAsString().then((template){
                var t = Mustache.parse(template, lenient:true);
                var tags = {};
                if(content.startsWith("{")){
                    int jsonEnd = 1;
                    int depth = 1;
                    while(depth > 0){
                        if(content[jsonEnd]=="{"){
                            depth++;
                        }else if(content[jsonEnd]=="}"){
                            depth--;
                        }
                        jsonEnd++;
                    }
                    tags = JSON.decode(content.substring(0, jsonEnd));
                    content = content.substring(jsonEnd);
                }
                tags['content'] = markdownToHtml(content);
                String output = t.renderString(tags, lenient:true, htmlEscapeValues:false);
                transform.addOutput(new Asset.fromString(id, output));
            });
        });
    }
}
