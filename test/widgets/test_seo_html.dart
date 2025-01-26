import 'package:flutter/material.dart';
import 'package:seo/seo.dart';

import '../const.dart';

class TestSeoHtml extends StatelessWidget {
  const TestSeoHtml({super.key});

  @override
  Widget build(BuildContext context) {
    return Seo.html(
      html: html,
      child: const SizedBox.square(dimension: 1),
    );
  }
}
