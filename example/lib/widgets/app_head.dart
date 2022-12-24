import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seo/seo.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AppHead extends StatefulWidget {
  final String title;
  final String description;
  final String? author;

  final Widget child;

  const AppHead({
    super.key,
    required this.title,
    required this.description,
    this.author,
    required this.child,
  });

  @override
  State<AppHead> createState() => _AppHeadState();
}

class _AppHeadState extends State<AppHead> {
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
      child: Seo.head(
        tags: [
          MetaTag(name: 'title', content: widget.title),
          MetaTag(name: 'description', content: widget.description),
          if (widget.author != null)
            MetaTag(name: 'author', content: widget.author),
        ],
        child: widget.child,
      ),
    );
  }
}
