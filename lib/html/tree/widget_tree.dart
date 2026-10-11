import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:seo/html/seo_widget.dart';
import 'package:seo/src/seo_html.dart';
import 'package:seo/src/seo_tag.dart';
import 'package:seo/src/seo_tree.dart';

class WidgetTree extends SeoTree {
  final BuildContext context;
  final _controller = StreamController<void>();

  WidgetTree({required this.context});

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

  const _Node({required this.parent, required this.children});

  @override
  bool get seo => parent?.widget is Seo;

  @override
  String toString() {
    final widget = parent?.widget;
    final tag = widget is Seo ? widget.tag : null;

    return switch (tag) {
      TextTag() => 'text: ${tag.text}',
      ImageTag() => 'image: ${tag.alt} | url: ${tag.src}',
      LinkTag() => 'link: ${tag.anchor} | url: ${tag.href} | rel: ${tag.rel}',
      HtmlTag() => 'html: ${tag.html}',
      HeadTags() => 'head: ${tag.tags.length}',
      null => 'div',
    };
  }

  @override
  SeoHtml toHtml() {
    final widget = parent?.widget;
    final tag = widget is Seo ? widget.tag : null;
    final html = children
        .map((e) => e.toHtml())
        .fold(const SeoHtml(head: '', body: ''), (h1, h2) => h1 + h2);

    return switch (tag) {
      TextTag() => html.copyWith(
        body: textTag(text: tag.text, style: tag.style, content: html.body),
      ),
      ImageTag() => html.copyWith(
        body: imageTag(
          src: tag.src,
          alt: tag.alt,
          height: parent?.size?.height,
          width: parent?.size?.width,
          content: html.body,
        ),
      ),
      LinkTag() => html.copyWith(
        body: linkTag(
          anchor: tag.anchor,
          href: tag.href,
          rel: tag.rel,
          content: html.body,
        ),
      ),
      HtmlTag() => html.copyWith(
        body: htmlTag(html: tag.html, content: html.body),
      ),
      HeadTags() => html.copyWith(
        head: html.head + tag.tags.map((tag) => headTag(tag: tag)).join('\n'),
      ),
      null => html.copyWith(body: divTag(content: html.body)),
    };
  }
}
