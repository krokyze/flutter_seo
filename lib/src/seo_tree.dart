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

  String text({
    required String text,
    required TextTagStyle style,
    required String content,
  }) {
    const tagStyleMap = {
      TextTagStyle.h1: 'h1',
      TextTagStyle.h2: 'h2',
      TextTagStyle.h3: 'h3',
      TextTagStyle.h4: 'h4',
      TextTagStyle.h5: 'h5',
      TextTagStyle.h6: 'h6',
      TextTagStyle.p: 'p',
    };

    final tag = tagStyleMap[style] ?? 'p';
    return '<$tag style="color:black;">$text</$tag>$content';
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
    required String? rel,
    required String content,
  }) {
    final attributes = {
      'href': href,
      'rel': rel,
    }
        .entries
        .where((entry) => entry.value != null)
        .map((entry) => '${entry.key}="${entry.value}"')
        .join(' ');

    return '<div><a $attributes><p>$anchor</p></a>$content</div>';
  }

  String head({
    required head_tag.HeadTag tag,
  }) {
    if (tag is head_tag.MetaTag) {
      final attributes = {
        'name': tag.name,
        'http-equiv': tag.httpEquiv,
        'content': tag.content,
      }
          .entries
          .where((entry) => entry.value != null)
          .map((entry) => '${entry.key}="${entry.value}"')
          .join(' ');

      return '<meta $attributes flt-seo>';
    } else if (tag is head_tag.LinkTag) {
      final attributes = {
        'title': tag.title,
        'rel': tag.rel,
        'type': tag.type,
        'hreflang': tag.hreflang,
        'href': tag.href,
        'media': tag.media,
      }
          .entries
          .where((entry) => entry.value != null)
          .map((entry) => '${entry.key}="${entry.value}"')
          .join(' ');

      return '<link $attributes flt-seo>';
    }

    throw UnimplementedError('unsupported tag: $tag');
  }

  String div({
    required String content,
  }) {
    return '<div>$content</div>';
  }
}
