import 'package:flutter/material.dart';
import 'package:seo/head_tag.dart' as head_tag;
import 'package:seo/src/seo_html.dart';
import 'package:seo/src/seo_tag.dart';

abstract class SeoTree {
  const SeoTree();

  Stream<void> changes();

  SeoTreeNode? traverse();

  Widget process(SeoTag tag, Widget child);
}

mixin SeoTreeNode {
  bool get seo;

  SeoHtml toHtml();

  String textTag({
    required String text,
    required TextTagStyle style,
    required String content,
  }) {
    final tag = style.name;
    return '<$tag style="color:black;">$text</$tag>$content';
  }

  String imageTag({
    required String src,
    required String alt,
    required double? height,
    required double? width,
    required String content,
  }) {
    return '<noscript><img src="$src" alt="$alt" height="$height" width="$width"/></noscript>$content';
  }

  String linkTag({
    required String anchor,
    required String href,
    required String? rel,
    required String content,
  }) {
    final attributes = _attributes({'href': href, 'rel': ?rel});

    return '<div><a $attributes><p>$anchor</p></a>$content</div>';
  }

  String htmlTag({required String html, required String content}) {
    return '$html$content';
  }

  String headTag({required head_tag.HeadTag tag}) {
    final attributes = _attributes(switch (tag) {
      head_tag.MetaTag() => {
        'name': ?tag.name,
        'http-equiv': ?tag.httpEquiv,
        'content': ?tag.content,
      },
      head_tag.LinkTag() => {
        'title': ?tag.title,
        'rel': ?tag.rel,
        'type': ?tag.type,
        'hreflang': ?tag.hreflang,
        'href': ?tag.href,
        'media': ?tag.media,
      },
    });

    return switch (tag) {
      head_tag.MetaTag() => '<meta $attributes flt-seo>',
      head_tag.LinkTag() => '<link $attributes flt-seo>',
    };
  }

  String divTag({required String content}) {
    return '<div>$content</div>';
  }
}

String _attributes(Map<String, String> attributes) {
  return attributes.entries
      .map((entry) => '${entry.key}="${entry.value}"')
      .join(' ');
}
