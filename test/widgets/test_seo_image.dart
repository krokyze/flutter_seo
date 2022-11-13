import 'package:flutter/material.dart';
import 'package:seo/seo.dart';

const alt = 'Lorem Ipsum';
const src = 'https://www.image.com';
const double height = 300;
const double width = 150;

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
