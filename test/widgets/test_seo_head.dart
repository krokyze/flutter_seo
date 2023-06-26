import 'package:flutter/material.dart';
import 'package:seo/seo.dart';

import '../const.dart';

class TestSeoHead extends StatelessWidget {
  final Widget? child;

  const TestSeoHead({
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Seo.head(
      tags: const [
        MetaTag(name: name, content: content),
        MetaTag(httpEquiv: httpEquiv, content: content),
        MetaTag(name: name, httpEquiv: httpEquiv, content: content),
        LinkTag(title: title, href: href),
        LinkTag(type: type, media: media),
        LinkTag(
          title: title,
          rel: rel,
          type: type,
          hreflang: hreflang,
          href: href,
          media: media,
        ),
      ],
      child: child ?? const SizedBox.square(dimension: 1),
    );
  }
}
