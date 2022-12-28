import 'package:flutter/material.dart';
import 'package:seo/seo.dart';

import '../const.dart';

class TestSeoText extends StatelessWidget {
  final TextTagStyle? tagStyle;

  const TestSeoText({
    super.key,
    this.tagStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Seo.text(
      text: text,
      style: tagStyle ?? TextTagStyle.p,
      child: const SizedBox.square(dimension: 1),
    );
  }
}
