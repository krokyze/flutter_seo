import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seo/html/tree/semantics_tree.dart';

import 'base.dart';
import 'widgets/test_seo_controller.dart';
import 'widgets/test_seo_image.dart';
import 'widgets/test_seo_link.dart';
import 'widgets/test_seo_text.dart';

void main() {
  testWidgets('Seo.text is processed correctly', (tester) async {
    await tester.pumpWidget(TestSeoController(
      tree: (_) => SemanticsTree(),
      child: const TestSeoText(),
    ));
    await tester.pumpAndSettle(debounceTime);

    expect(
      html,
      '<div><p>$text</p></div>',
    );
  });

  testWidgets('Seo.image is processed correctly', (tester) async {
    await tester.pumpWidget(TestSeoController(
      tree: (_) => SemanticsTree(),
      child: const TestSeoImage(),
    ));
    await tester.pumpAndSettle(debounceTime);

    expect(
      html,
      '<div><noscript><img src="$url" alt="$alt" height="$height" width="$width"></noscript></div>',
    );
  });

  testWidgets('Seo.link is processed correctly', (tester) async {
    await tester.pumpWidget(TestSeoController(
      tree: (_) => SemanticsTree(),
      child: const TestSeoLink(),
    ));
    await tester.pumpAndSettle(debounceTime);

    expect(
      html,
      '<div><div><a href="$href"><p>$anchor</p></a></div></div>',
    );
  });

  testWidgets('multiple Seo\'s are processed correctly', (tester) async {
    await tester.pumpWidget(TestSeoController(
      tree: (_) => SemanticsTree(),
      child: TestSeoLink(
        child: Row(
          children: const [
            TestSeoImage(),
            TestSeoText(),
          ],
        ),
      ),
    ));
    await tester.pumpAndSettle(debounceTime);

    expect(
      html,
      '<div><div><a href="$href"><p>$anchor</p></a><noscript><img src="$url" alt="$alt" height="$height" width="$width"></noscript><p>$text</p></div></div>',
    );
  });
}
