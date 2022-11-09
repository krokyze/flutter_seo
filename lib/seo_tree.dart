import 'package:flutter/material.dart';
import 'package:seo/html/seo_widget.dart';

abstract class SeoTree {
  const SeoTree();

  Stream<void> changes();

  SeoTreeNode? traverse();

  Widget process(Seo seo);
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
    required String? anchor,
    required String href,
    required String content,
  }) {
    return '<a href="$href">${(anchor ?? '').isNotEmpty ? '<p>$anchor</p>' : ''}$content</a>';
  }

  String div({
    required String content,
  }) {
    return '<div>$content</div>';
  }
}
