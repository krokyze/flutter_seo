import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:seo/src/seo_html.dart';
import 'package:seo/src/seo_tag.dart';
import 'package:seo/src/seo_tree.dart';

class SemanticsTree extends SeoTree {
  SemanticsOwner? get _semanticsOwner =>
      WidgetsBinding.instance.renderViews.firstOrNull?.owner?.semanticsOwner;

  @override
  Stream<void> changes() {
    // https://github.com/dart-lang/linter/issues/1381
    // ignore: close_sinks
    late StreamController<void> controller;
    SemanticsHandle? handle;
    SemanticsOwner? owner;

    void listener() => controller.add(null);

    void onStart() {
      handle = SemanticsBinding.instance.ensureSemantics();
      owner = _semanticsOwner?..addListener(listener);
    }

    void onStop() {
      owner?.removeListener(listener);
      owner = null;
      handle?.dispose();
      handle = null;
    }

    controller = StreamController<void>(
      onListen: onStart,
      onPause: onStop,
      onResume: onStart,
      onCancel: onStop,
    );

    return controller.stream;
  }

  @override
  SeoTreeNode? traverse() {
    final node = _semanticsOwner?.rootSemanticsNode;
    if (node == null) return null;

    return _traverse(node);
  }

  _Node _traverse(SemanticsNode node) {
    if (node.mergeAllDescendantsIntoThisNode) {
      return _Node(parent: node, children: []);
    }

    final children = <SemanticsNode>[];
    node.visitChildren((node) {
      children.add(node);
      return true;
    });

    return _Node(
      parent: node,
      children: children
          .map(_traverse)
          .expand((node) => node.seo ? [node] : node.children)
          .toList(),
    );
  }

  @override
  Widget process(SeoTag tag, Widget child) {
    return switch (tag) {
      TextTag() => Semantics(
        label: tag.text,
        headingLevel: switch (tag.style) {
          TextTagStyle.p => null,
          final style => style.index + 1,
        },
        excludeSemantics: true,
        container: true,
        child: child,
      ),
      ImageTag() => Semantics(
        label: tag.alt,
        value: tag.src,
        image: true,
        excludeSemantics: true,
        container: true,
        child: child,
      ),
      LinkTag() => Semantics(
        label: tag.anchor,
        linkUrl: Uri.tryParse(tag.href),
        link: true,
        container: true,
        child: child,
      ),
      // Semantics doesn't support a way to pass head tag info to SemanticsNode
      HtmlTag() || HeadTags() => child,
    };
  }
}

class _Node with SeoTreeNode {
  final SemanticsNode parent;
  final List<_Node> children;

  const _Node({required this.parent, required this.children});

  @override
  bool get seo => _text || _link || _image;

  bool get _text {
    return parent.label.isNotEmpty;
  }

  bool get _link {
    return parent.flagsCollection.isLink &&
        '${parent.linkUrl ?? ''}'.isNotEmpty;
  }

  bool get _image {
    return parent.flagsCollection.isImage && parent.value.isNotEmpty;
  }

  @override
  String toString() {
    final label = parent.label.replaceAll('\n', ' ');
    final value = parent.value;

    if (_link) {
      return 'link: $label | url: ${parent.linkUrl}';
    } else if (_image) {
      return 'image: $label | url: $value';
    } else if (_text) {
      return 'text: $label';
    } else {
      return 'div: ${children.length}';
    }
  }

  @override
  SeoHtml toHtml() {
    final html = children
        .map((e) => e.toHtml())
        .fold(const SeoHtml(head: '', body: ''), (h1, h2) => h1 + h2);

    if (_link) {
      return html.copyWith(
        body: linkTag(
          anchor: parent.label,
          href: parent.linkUrl.toString(),
          rel: null,
          content: html.body,
        ),
      );
    } else if (_image) {
      return html.copyWith(
        body: imageTag(
          src: parent.value,
          alt: parent.label,
          height: parent.rect.height,
          width: parent.rect.width,
          content: html.body,
        ),
      );
    } else if (_text) {
      return html.copyWith(
        body: textTag(
          text: parent.label,
          style: switch (parent.headingLevel) {
            0 => TextTagStyle.p,
            final level => TextTagStyle.values[level - 1],
          },
          content: html.body,
        ),
      );
    } else {
      return html.copyWith(body: divTag(content: html.body));
    }
  }
}
