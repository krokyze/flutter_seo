import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:seo/html/seo_widget.dart';
import 'package:seo/src/seo_html.dart';
import 'package:seo/src/seo_tag.dart';
import 'package:seo/src/seo_tree.dart';

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
    element.debugVisitOnstageChildren((element) => children.add(element));

    return _Node(
      parent: element,
      children: children
          .map(_traverse)
          .expand((node) => node.seo ? [node] : node.children)
          .toList(),
    );
  }

  @override
  Widget process(SeoTag tag, Widget child) {
    _controller.add(null);
    return child;
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
    } else if (tag is HeadTags) {
      return 'head: ${tag.tags.length}';
    } else {
      return 'div';
    }
  }

  @override
  SeoHtml toHtml() {
    final widget = parent?.widget;
    final tag = widget is Seo ? widget.tag : null;
    final html = children
        .map((e) => e.toHtml())
        .fold(const SeoHtml(head: '', body: ''), (h1, h2) => h1 + h2);

    if (tag is TextTag) {
      return html.copyWith(
        body: text(
          text: tag.text,
          content: html.body,
        ),
      );
    } else if (tag is ImageTag) {
      return html.copyWith(
        body: image(
          src: tag.src,
          alt: tag.alt,
          height: parent?.size?.height,
          width: parent?.size?.width,
          content: html.body,
        ),
      );
    } else if (tag is LinkTag) {
      return html.copyWith(
        body: link(
          anchor: tag.anchor,
          href: tag.href,
          content: html.body,
        ),
      );
    } else if (tag is HeadTags) {
      return html.copyWith(
        head: html.head + tag.tags.map((tag) => head(tag: tag)).join('\n'),
      );
    } else {
      return html.copyWith(
        body: div(
          content: html.body,
        ),
      );
    }
  }
}
