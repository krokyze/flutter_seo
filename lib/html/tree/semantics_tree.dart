import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:seo/src/seo_html.dart';
import 'package:seo/src/seo_tag.dart';
import 'package:seo/src/seo_tree.dart';

class SemanticsTree extends SeoTree {
  PipelineOwner get _pipelineOwner => WidgetsBinding.instance.pipelineOwner;

  @override
  Stream<void> changes() {
    // https://github.com/dart-lang/linter/issues/1381
    // ignore: close_sinks
    late StreamController<void> controller;
    SemanticsHandle? handle;

    void onStart() {
      handle = _pipelineOwner.ensureSemantics(
        listener: () => controller.add(null),
      );
    }

    void onStop() {
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
    final node = _pipelineOwner.semanticsOwner?.rootSemanticsNode;
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
    if (tag is TextTag) {
      return Semantics(
        label: tag.text,
        excludeSemantics: true,
        container: true,
        child: child,
      );
    } else if (tag is ImageTag) {
      return Semantics(
        label: tag.alt,
        value: tag.src,
        image: true,
        excludeSemantics: true,
        container: true,
        child: child,
      );
    } else if (tag is LinkTag) {
      return Semantics(
        label: tag.anchor,
        value: tag.href,
        link: true,
        container: true,
        child: child,
      );
    } else if (tag is HeadTags) {
      // Semantics doesn't support a way to pass head tag info to SemanticsNode
      return child;
    }

    throw UnimplementedError('unsupported tag: $tag');
  }
}

class _Node with SeoTreeNode {
  final SemanticsNode parent;
  final List<_Node> children;

  const _Node({
    required this.parent,
    required this.children,
  });

  @override
  bool get seo => _text || _link || _image;

  bool get _text {
    return parent.label.isNotEmpty;
  }

  bool get _link {
    return parent.hasFlag(SemanticsFlag.isLink) && parent.value.isNotEmpty;
  }

  bool get _image {
    return parent.hasFlag(SemanticsFlag.isImage) && parent.value.isNotEmpty;
  }

  @override
  String toString() {
    final label = parent.label.replaceAll('\n', ' ');
    final value = parent.value;

    if (_link) {
      return 'link: $label | url: $value';
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
        body: link(
          anchor: parent.label,
          href: parent.value,
          rel: null,
          content: html.body,
        ),
      );
    } else if (_image) {
      return html.copyWith(
        body: image(
          src: parent.value,
          alt: parent.label,
          height: parent.rect.height,
          width: parent.rect.width,
          content: html.body,
        ),
      );
    } else if (_text) {
      return html.copyWith(
        body: text(
          text: parent.label,
          style: TextTagStyle.p,
          content: html.body,
        ),
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
