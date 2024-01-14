import 'package:flutter/material.dart';
import 'package:seo/seo.dart';

import '../const.dart';

class TestSeoLink extends StatelessWidget {
  final String? rel;
  final Widget? child;

  const TestSeoLink({
    super.key,
    this.rel,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Seo.link(
      anchor: anchor,
      href: href,
      rel: rel,
      child: child ?? const SizedBox.square(dimension: 1),
    );
  }
}
