// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seo/html/tree/widget_tree.dart';

import 'base.dart';
import 'widgets/test_seo_controller.dart';
import 'widgets/test_seo_image.dart';
import 'widgets/test_seo_link.dart';
import 'widgets/test_seo_page.dart';
import 'widgets/test_seo_text.dart';

void main() {
  testWidgets('Seo.text is processed correctly', (tester) async {
    await tester.pumpWidget(TestSeoController(
      tree: (context) => WidgetTree(context: context),
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
      tree: (context) => WidgetTree(context: context),
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
      tree: (context) => WidgetTree(context: context),
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
      tree: (context) => WidgetTree(context: context),
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

  testWidgets('traverse executes <2ms for single widget', (tester) async {
    late WidgetTree tree;
    await tester.pumpWidget(TestSeoController(
      tree: (context) {
        tree = WidgetTree(context: context);
        return tree;
      },
      child: const TestSeoText(),
    ));

    final duration =
        List.generate(10, (_) => measure(() => tree.traverse()?.toHtml()))
            .mapIndexed((index, duration) {
      tester.printToConsole('$index - $duration');
      return duration.inMicroseconds;
    }).average;

    expect(duration, lessThanOrEqualTo(2000));
    tester.printToConsole('average - ${duration / 1000.0}ms');
  });

  testWidgets('traverse executes <80ms for complex page', (tester) async {
    await tester.binding.setSurfaceSize(largeScreenSize);

    late WidgetTree tree;
    await tester.pumpWidget(TestSeoController(
      tree: (context) {
        tree = WidgetTree(context: context);
        return tree;
      },
      child: const TestSeoPage(),
    ));

    final duration =
        List.generate(10, (_) => measure(() => tree.traverse()?.toHtml()))
            .mapIndexed((index, duration) {
      tester.printToConsole('$index - $duration');
      return duration.inMicroseconds;
    }).average;

    expect(duration, lessThanOrEqualTo(80000));
    tester.printToConsole('average - ${duration / 1000.0}ms');

    await tester.binding.setSurfaceSize(null);
  });
}
