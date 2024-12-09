import 'dart:async';
import 'dart:js_interop';
import 'package:seo/html/node_list_extension.dart';
import 'package:web/web.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:seo/src/seo_html.dart';
import 'package:seo/src/seo_tag.dart';
import 'package:seo/src/seo_tree.dart';

class SeoController extends StatefulWidget {
  final bool enabled;

  final SeoTree tree;
  final Widget child;

  const SeoController({
    super.key,
    this.enabled = true,
    required this.tree,
    required this.child,
  });

  @override
  State<SeoController> createState() => _SeoControllerState();

  static Widget process({
    required BuildContext context,
    required SeoTag tag,
    required Widget child,
  }) {
    final tree = context
        .dependOnInheritedWidgetOfExactType<_InheritedSeoTreeWidget>()
        ?.tree;

    if (tree == null) {
      throw Exception('SeoController not found');
    }

    return tree.process(tag, child);
  }
}

class _SeoControllerState extends State<SeoController> {
  StreamSubscription? _subscription;
  int? _headHash;
  int? _bodyHash;

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  @override
  void didUpdateWidget(covariant SeoController oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.enabled != widget.enabled) {
      _subscribe();
    }
  }

  void _subscribe() {
    _subscription?.cancel();
    _subscription = null;

    if (widget.enabled) {
      _subscription = widget.tree
          .changes()
          .debounceTime(const Duration(milliseconds: 250))
          .listen((_) => _update());
    }
  }

  void _update() async {
    if (!mounted) return;

    if (SchedulerBinding.instance.schedulerPhase != SchedulerPhase.idle) {
      await SchedulerBinding.instance.endOfFrame;
      if (!mounted) return;
    }

    final html = widget.tree.traverse()?.toHtml();
    if (html != null) {
      _updateHead(html);
      _updateBody(html);
    }
  }

  void _updateHead(SeoHtml html) {
    final head = document.head;
    if (head == null) return;

    final hash = html.head.hashCode;
    if (_headHash == hash) return;
    _headHash = hash;

    head
        .querySelectorAll('[flt-seo]')
        .toList()
        .nonNulls
        .forEach((node) => head.removeChild(node));

    head.insertAdjacentHTML(
      'beforeEnd',
      html.head.toJS,
    );
  }

  void _updateBody(SeoHtml html) {
    final body = document.body;
    if (body == null) return;

    final hash = html.body.hashCode;
    if (_bodyHash == hash) return;
    _bodyHash = hash;

    body
        .querySelectorAll('[flt-seo]')
        .toList()
        .nonNulls
        .forEach((node) => body.removeChild(node));

    body.insertAdjacentHTML(
      'afterBegin',
      '<div flt-seo>${html.body}</div>'.toJS,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedSeoTreeWidget(
      tree: widget.tree,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    super.dispose();
  }
}

class _InheritedSeoTreeWidget extends InheritedWidget {
  final SeoTree tree;

  const _InheritedSeoTreeWidget({
    required this.tree,
    required super.child,
  });

  @override
  bool updateShouldNotify(_InheritedSeoTreeWidget old) => true;
}
