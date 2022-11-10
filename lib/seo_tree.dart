import 'package:flutter/material.dart';
import 'package:seo/seo_tag.dart';

abstract class SeoTree {
  const SeoTree();

  Stream<void> changes();

  SeoTreeNode? traverse();

  Widget process(SeoTag tag, Widget child);
}

abstract class SeoTreeNode {
  bool get seo;

  String toHtml();

  String text({
    required String text,
    required String content,
  }) {
    return '<p>$text</p>$content';
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
    return '<div><a href="$href"><p>$anchor</p></a>$content</div>';
  }

  String div({
    required String content,
  }) {
    return '<div>$content</div>';
  }
}
