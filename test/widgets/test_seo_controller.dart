import 'package:flutter/material.dart';
import 'package:seo/html/seo_controller.dart';
import 'package:seo/src/seo_tree.dart';

class TestSeoController extends StatelessWidget {
  final bool enabled;
  final SeoTree Function(BuildContext context) tree;
  final Widget child;

  const TestSeoController({
    super.key,
    this.enabled = true,
    required this.tree,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SeoController(
      enabled: enabled,
      tree: tree(context),
      child: MaterialApp(
        home: Center(
          child: child,
        ),
      ),
    );
  }
}
