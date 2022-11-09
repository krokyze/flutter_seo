import 'package:flutter/material.dart';

class Seo extends StatelessWidget {
  final Widget child;

  const Seo.text({
    super.key,
    String? text,
    required this.child,
  });

  const Seo.image({
    super.key,
    String? alt,
    String? url,
    required this.child,
  });

  const Seo.link({
    super.key,
    String? anchor,
    String? href,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => child;
}
