import 'package:flutter/material.dart';

import 'test_seo_image.dart';
import 'test_seo_link.dart';
import 'test_seo_text.dart';

class TestSeoPage extends StatelessWidget {
  const TestSeoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        256,
        (_) => const TestSeoLink(
          child: Row(
            children: [
              TestSeoImage(),
              TestSeoText(),
              TestSeoLink(
                child: Column(
                  children: [
                    TestSeoText(),
                    TestSeoText(),
                    TestSeoText(),
                  ],
                ),
              ),
              TestSeoLink(
                child: Column(
                  children: [
                    TestSeoImage(),
                    TestSeoImage(),
                    TestSeoImage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
