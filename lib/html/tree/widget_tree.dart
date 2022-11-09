import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:seo/html/seo_tag.dart';
import 'package:seo/html/seo_widget.dart';
import 'package:seo/seo_tree.dart';

class WidgetTree extends SeoTree {
  final BuildContext context;
  final _controller = StreamController<void>();

  WidgetTree({
    required this.context,
  });

  @override
  Stream<void> changes() {
    return _controller.stream;
  }

  @override
  SeoTreeNode? traverse() {
    final children = <Element>[];
    context.visitChildElements((element) => children.add(element));

    return _Node(
      parent: null,
      children: children
          .map(_traverse)
          .expand((node) => node.seo ? [node] : node.children)
          .toList(),
    );
  }

  _Node _traverse(Element element) {
    final children = <Element>[];
    element.visitChildren((element) => children.add(element));

    return _Node(
      parent: element,
      children: children
          .map(_traverse)
          .expand((node) => node.seo ? [node] : node.children)
          .toList(),
    );
  }

  @override
  Widget process(Seo seo) {
    _controller.add(null);
    return seo.child;
  }
}

class _Node with SeoTreeNode {
  final Element? parent;
  final List<_Node> children;

  const _Node({
    required this.parent,
    required this.children,
  });

  @override
  bool get seo => parent?.widget is Seo;

  @override
  String toString() {
    final widget = parent?.widget;
    final tag = widget is Seo ? widget.tag : null;

    if (tag is TextTag) {
      return 'text: ${tag.text}';
    } else if (tag is ImageTag) {
      return 'image: ${tag.alt} | url: ${tag.src}';
    } else if (tag is LinkTag) {
      return 'link: ${tag.anchor} | url: ${tag.href}';
    } else {
      return 'div';
    }
  }

  @override
  String toHtml() {
    final widget = parent?.widget;
    final tag = widget is Seo ? widget.tag : null;
    final content = children.map((e) => e.toHtml()).join();

    if (tag is TextTag) {
      return text(
        text: tag.text,
        content: content,
      );
    } else if (tag is ImageTag) {
      return image(
        src: tag.src,
        alt: tag.alt,
        height: parent?.size?.height,
        width: parent?.size?.width,
        content: content,
      );
    } else if (tag is LinkTag) {
      return link(
        anchor: tag.anchor,
        href: tag.href,
        content: content,
      );
    } else {
      return div(
        content: content,
      );
    }
  }
}
