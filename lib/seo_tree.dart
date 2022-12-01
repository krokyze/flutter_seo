import 'package:flutter/material.dart';
import 'package:seo/seo.dart';
import 'package:seo/seo_html.dart';
import 'package:seo/seo_tag.dart';

abstract class SeoTree {
  const SeoTree();

  Stream<void> changes();

  SeoTreeNode? traverse();

  Widget process(SeoTag tag, Widget child);
}

abstract class SeoTreeNode {
  bool get seo;

  SeoHtml toHtml();

  String text({
    required String text,
    required String content,
  }) {
    return '<p style="color:black;">$text</p>$content';
  }

  String image({
    required String src,
    required String alt,
    required double? height,
    required double? width,
    required String content,
  }) {
    return '<noscript><img src="$src" alt="$alt" height="$height" width="$width"/></noscript>$content';
  }

  String link({
    required String anchor,
    required String href,
    required String content,
  }) {
    return '<div><a href="$href"><p style="color:black;">$anchor</p></a>$content</div>';
  }

  String meta({
    required MetaTag tag,
  }) {
    if (tag is MetaNameTag) {
      return '<meta name="${tag.name}" content="${tag.content}" flt-seo>';
    } else if (tag is MetaPropertyTag) {
      return '<meta property="${tag.property}" content="${tag.content}" flt-seo>';
    }

    throw UnimplementedError('unsupported tag: $tag');
  }

  String div({
    required String content,
  }) {
    return '<div>$content</div>';
  }
}
