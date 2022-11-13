import 'dart:async';

import 'package:flutter/material.dart';
import 'package:seo/seo_tag.dart';
import 'package:seo/seo_tree.dart';

class WidgetTree extends SeoTree {
  WidgetTree({
    required BuildContext context,
  });

  @override
  Stream<void> changes() => throw UnimplementedError();

  @override
  Widget process(SeoTag tag, Widget child) => throw UnimplementedError();

  @override
  SeoTreeNode? traverse() => throw UnimplementedError();
}
