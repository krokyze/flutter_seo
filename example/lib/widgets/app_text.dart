import 'package:flutter/material.dart';
import 'package:seo/seo.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const AppText({
    super.key,
    required this.text,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Seo.text(
      text: text,
      child: Text(
        text,
        style: style,
      ),
    );
  }
}
