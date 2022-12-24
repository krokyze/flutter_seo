import 'package:flutter/material.dart';
import 'package:seo/seo.dart';

import '../const.dart';

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
