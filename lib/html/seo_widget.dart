import 'package:flutter/material.dart';
import 'package:seo/html/seo_controller.dart';
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
    required String url,
    required this.child,
  }) : tag = ImageTag(alt: alt, src: url);

  Seo.link({
    super.key,
    required String anchor,
    required String href,
    required this.child,
  }) : tag = LinkTag(anchor: anchor, href: href);

  @override
  Widget build(BuildContext context) {
    return SeoController.process(
      context: context,
      tag: tag,
      child: child,
    );
  }
}
