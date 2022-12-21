import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seo/seo.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AppMeta extends StatefulWidget {
  final String title;
  final String description;
  final String? author;

  final Widget child;

  const AppMeta({
    super.key,
    required this.title,
    required this.description,
    this.author,
    required this.child,
  });

  @override
  State<AppMeta> createState() => _AppMetaState();
}

class _AppMetaState extends State<AppMeta> {
  final _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: _key,
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.0) {
          SystemChrome.setApplicationSwitcherDescription(
            ApplicationSwitcherDescription(
              label: widget.title,
              primaryColor: Theme.of(context).primaryColor.value,
            ),
          );
        }
      },
      child: Seo.meta(
        tags: [
          MetaNameTag(name: 'title', content: widget.title),
          MetaNameTag(name: 'description', content: widget.description),
          if (widget.author != null)
            MetaNameTag(name: 'author', content: widget.author!),
        ],
        child: widget.child,
      ),
    );
  }
}
