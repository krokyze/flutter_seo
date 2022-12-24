import 'package:flutter/material.dart';
import 'package:seo/src/seo_tag.dart';
import 'package:seo/src/seo_tree.dart';

class SemanticsTree extends SeoTree {
  @override
  Stream<void> changes() => throw UnimplementedError();

  @override
  Widget process(SeoTag tag, Widget child) => throw UnimplementedError();

  @override
  SeoTreeNode? traverse() => throw UnimplementedError();
}
