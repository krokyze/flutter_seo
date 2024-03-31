import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

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
  final _headValidator = NodeValidatorBuilder()
    ..allowHtml5(uriPolicy: _AllowAllUriPolicy())
    ..allowCustomElement(
      'meta',
      attributes: ['name', 'http-equiv', 'content', 'flt-seo'],
    )
    ..allowCustomElement(
      'link',
      attributes: [
        'title',
        'rel',
        'type',
        'hreflang',
        'href',
        'media',
        'flt-seo'
      ],
    );

  final _bodyValidator = NodeValidatorBuilder()
    ..allowHtml5(uriPolicy: _AllowAllUriPolicy())
    ..allowCustomElement('div', attributes: ['flt-seo'])
    ..allowCustomElement('noscript')
    ..allowCustomElement('h1', attributes: ['style'])
    ..allowCustomElement('h2', attributes: ['style'])
    ..allowCustomElement('h3', attributes: ['style'])
    ..allowCustomElement('h4', attributes: ['style'])
    ..allowCustomElement('h5', attributes: ['style'])
    ..allowCustomElement('h6', attributes: ['style'])
    ..allowCustomElement('p', attributes: ['style'])
    ..allowCustomElement('a', attributes: ['rel']);

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

    head.children
        .removeWhere((element) => element.attributes.containsKey('flt-seo'));

    head.insertAdjacentHtml(
      'beforeEnd',
      html.head,
      validator: _headValidator,
    );
  }

  void _updateBody(SeoHtml html) {
    final body = document.body;
    if (body == null) return;

    final hash = html.body.hashCode;
    if (_bodyHash == hash) return;
    _bodyHash = hash;

    body.children
        .removeWhere((element) => element.attributes.containsKey('flt-seo'));

    body.insertAdjacentHtml(
      'afterBegin',
      '<div flt-seo>${html.body}</div>',
      validator: _bodyValidator,
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

class _AllowAllUriPolicy implements UriPolicy {
  @override
  bool allowsUri(String uri) => true;
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
