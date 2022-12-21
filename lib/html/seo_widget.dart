import 'package:flutter/material.dart';
import 'package:seo/html/seo_controller.dart';
import 'package:seo/meta_tag.dart';
import 'package:seo/seo_tag.dart';

class Seo extends StatelessWidget {
  final SeoTag tag;
  final Widget child;

  Seo.text({
    super.key,
    required String text,
    required this.child,
  }) : tag = TextTag(text: text);

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
    required this.child,
  }) : tag = LinkTag(anchor: anchor, href: href);

  Seo.meta({
    super.key,
    required List<MetaTag> tags,
    required this.child,
  }) : tag = MetaTags(tags: tags);

  @override
  Widget build(BuildContext context) {
    return SeoController.process(
      context: context,
      tag: tag,
      child: child,
    );
  }
}
