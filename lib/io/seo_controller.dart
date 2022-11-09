import 'package:flutter/material.dart';
import 'package:seo/seo.dart';
import 'package:seo/seo_tree.dart';

class SeoController extends StatelessWidget {
  final Widget child;

  const SeoController({
    super.key,
    bool? enabled,
    SeoTree? tree,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => child;

  static Widget process({
    required BuildContext context,
    required Seo child,
  }) {
    throw 'proccess shouldn\'t be called';
  }
}
