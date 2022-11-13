import 'package:flutter/material.dart';
import 'package:seo/seo.dart';

const anchor = 'Lorem Ipsum';
const href = 'https://www.href.com';

class TestSeoLink extends StatelessWidget {
  final Widget? child;

  const TestSeoLink({
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Seo.link(
      anchor: anchor,
      href: href,
      child: child ?? const SizedBox.square(dimension: 1),
    );
  }
}
