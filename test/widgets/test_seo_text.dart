import 'package:flutter/material.dart';
import 'package:seo/seo.dart';

const text =
    'Lorem Ipsum is simply dummy text of the printing and typesetting industry.';

class TestSeoText extends StatelessWidget {
  const TestSeoText({super.key});

  @override
  Widget build(BuildContext context) {
    return Seo.text(
      text: text,
      child: const SizedBox.square(dimension: 1),
    );
  }
}
