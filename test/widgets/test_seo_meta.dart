import 'package:flutter/material.dart';
import 'package:seo/seo.dart';

const title = 'Lorem Ipsum';
const name = 'twitter:title';
const property = 'og:title';

class TestSeoMeta extends StatelessWidget {
  final Widget? child;

  const TestSeoMeta({
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Seo.meta(
      tags: const [
        MetaNameTag(name: name, content: title),
        MetaPropertyTag(property: property, content: title),
      ],
      child: child ?? const SizedBox.square(dimension: 1),
    );
  }
}
