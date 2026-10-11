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
    final root = _Node(parent: null, children: []);

    var nodes = root.children;
    void visit(Element element) {
      final parent = nodes;
      if (element.widget is Seo) {
        final node = _Node(parent: element, children: []);
        nodes.add(node);
        nodes = node.children;
      }

      element.debugVisitOnstageChildren(visit);
      nodes = parent;
    }

    context.visitChildElements(visit);

    return root;
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
    final head = StringBuffer();
    final body = _toHtml(head);

    return SeoHtml(head: head.toString(), body: body);
  }

  String _toHtml(StringBuffer head) {
    final widget = parent?.widget;
    final tag = widget is Seo ? widget.tag : null;

    final buffer = StringBuffer();
    for (final child in children) {
      buffer.write(child._toHtml(head));
    }
    final content = buffer.toString();

    switch (tag) {
      case TextTag():
        return textTag(text: tag.text, style: tag.style, content: content);
      case ImageTag():
        return imageTag(
          src: tag.src,
          alt: tag.alt,
          height: parent?.size?.height,
          width: parent?.size?.width,
          content: content,
        );
      case LinkTag():
        return linkTag(
          anchor: tag.anchor,
          href: tag.href,
          rel: tag.rel,
          content: content,
        );
      case HtmlTag():
        return htmlTag(html: tag.html, content: content);
      case HeadTags():
        head.write(tag.tags.map((tag) => headTag(tag: tag)).join('\n'));
        return content;
      case null:
        return divTag(content: content);
    }
  }
}
