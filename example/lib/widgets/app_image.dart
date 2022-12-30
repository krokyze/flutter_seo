import 'package:flutter/material.dart';
import 'package:seo/seo.dart';

class AppImage extends StatelessWidget {
  final String alt;
  final String src;

  const AppImage({
    super.key,
    required this.alt,
    required this.src,
  });

  @override
  Widget build(BuildContext context) {
    return Seo.image(
      alt: alt,
      src: src,
      child: Image.network(src),
    );
  }
}
