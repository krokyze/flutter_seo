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
        (_) => TestSeoLink(
          child: Row(
            children: [
              const TestSeoImage(),
              const TestSeoText(),
              TestSeoLink(
                child: Column(
                  children: const [
                    TestSeoText(),
                    TestSeoText(),
                    TestSeoText(),
                  ],
                ),
              ),
              TestSeoLink(
                child: Column(
                  children: const [
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
