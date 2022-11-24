import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seo/seo.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AppMeta extends StatefulWidget {
  final String title;
  final String description;
  final String? image;

  final Widget child;

  const AppMeta({
    super.key,
    required this.title,
    required this.description,
    this.image,
    required this.child,
  });

  @override
  State<AppMeta> createState() => _AppMetaState();
}

class _AppMetaState extends State<AppMeta> {
  final _key = UniqueKey();

  @override
  void initState() {
    super.initState();
    // initially build Uri.base is the previous path
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

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
          // Primary Meta Tags
          MetaNameTag(name: 'title', content: widget.title),
          MetaNameTag(name: 'description', content: widget.description),

          // Open Graph / Facebook
          MetaPropertyTag(property: 'og:title', content: widget.title),
          MetaPropertyTag(
              property: 'og:description', content: widget.description),
          MetaPropertyTag(property: 'og:url', content: Uri.base.toString()),
          if (widget.image != null)
            MetaPropertyTag(property: 'og:image', content: widget.image!),
          const MetaPropertyTag(property: 'og:type', content: 'article'),

          // Twitter
          MetaNameTag(name: 'twitter:title', content: widget.title),
          MetaNameTag(name: 'twitter:description', content: widget.description),
          if (widget.image != null)
            MetaNameTag(name: 'twitter:image', content: widget.image!),
          const MetaNameTag(name: 'twitter:card', content: 'summary'),
        ],
        child: widget.child,
      ),
    );
  }
}
