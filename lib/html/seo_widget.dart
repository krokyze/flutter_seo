import 'package:flutter/material.dart';
import 'package:seo/head_tag.dart' as head_tag;
import 'package:seo/html/seo_controller.dart';
import 'package:seo/src/seo_tag.dart';

class Seo extends StatelessWidget {
  final SeoTag tag;
  final Widget child;

  Seo.text({
    super.key,
    required String text,
    TextTagStyle style = TextTagStyle.p,
    required this.child,
  }) : tag = TextTag(text: text, style: style);

  Seo.image({
    super.key,
    required String alt,
    required String src,
    required this.child,
  }) : tag = ImageTag(alt: alt, src: src);

  Seo.link({
    super.key,
    required String anchor,
    required String href,
    String? rel,
    required this.child,
  }) : tag = LinkTag(anchor: anchor, href: href, rel: rel);

  Seo.html({
    super.key,
    required String html,
    required this.child,
  }) : tag = HtmlTag(html: html);

  Seo.head({
    super.key,
    required List<head_tag.HeadTag> tags,
    required this.child,
  }) : tag = HeadTags(tags: tags);

  @override
  Widget build(BuildContext context) {
    return SeoController.process(
      context: context,
      tag: tag,
      child: child,
    );
  }
}
