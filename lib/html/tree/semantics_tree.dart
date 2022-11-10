import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:seo/seo_tag.dart';
import 'package:seo/seo_tree.dart';

class SemanticsTree extends SeoTree {
  PipelineOwner get _pipelineOwner => WidgetsBinding.instance.pipelineOwner;

  @override
  Stream<void> changes() {
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
        container: true,
        excludeSemantics: true,
        child: child,
      );
    } else if (tag is ImageTag) {
      return Semantics(
        label: tag.alt,
        value: tag.src,
        image: true,
        container: true,
        excludeSemantics: true,
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
  String toHtml() {
    final content = children.map((e) => e.toHtml()).join();

    if (_link) {
      return link(
        anchor: parent.label,
        href: parent.value,
        content: content,
      );
    } else if (_image) {
      return image(
        src: parent.value,
        alt: parent.label,
        height: parent.rect.height,
        width: parent.rect.width,
        content: content,
      );
    } else if (_text) {
      return text(
        text: parent.label,
        content: content,
      );
    } else {
      return div(
        content: content,
      );
    }
  }
}
