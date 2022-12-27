import 'package:flutter/material.dart';
import 'package:seo/seo.dart';

import '../const.dart';

class TestSeoImage extends StatelessWidget {
  const TestSeoImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Seo.image(
      alt: alt,
      src: src,
      child: const SizedBox(height: height, width: width),
    );
  }
}
