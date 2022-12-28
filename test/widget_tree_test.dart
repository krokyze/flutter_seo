import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seo/html/tree/widget_tree.dart';
import 'package:seo/src/seo_tag.dart';

import 'base.dart';
import 'const.dart';
import 'widgets/test_seo_controller.dart';
import 'widgets/test_seo_head.dart';
import 'widgets/test_seo_image.dart';
import 'widgets/test_seo_link.dart';
import 'widgets/test_seo_page.dart';
import 'widgets/test_seo_text.dart';

void main() {
  testWidgets('Seo.text is processed correctly', (tester) async {
    await tester.pumpWidget(TestSeoController(
      tree: (context) => WidgetTree(context: context),
      child: Column(
        children: const [
          TestSeoText(tagStyle: TextTagStyle.h1),
          TestSeoText(tagStyle: TextTagStyle.h2),
          TestSeoText(tagStyle: TextTagStyle.h3),
          TestSeoText(tagStyle: TextTagStyle.h4),
          TestSeoText(tagStyle: TextTagStyle.h5),
          TestSeoText(tagStyle: TextTagStyle.h6),
          TestSeoText(),
        ],
      ),
    ));
    await tester.pumpAndSettle(debounceTime);

    expect(
      bodyHtml,
      '<div>${[
        '<h1 style="color:black;">$text</h1>',
        '<h2 style="color:black;">$text</h2>',
        '<h3 style="color:black;">$text</h3>',
        '<h4 style="color:black;">$text</h4>',
        '<h5 style="color:black;">$text</h5>',
        '<h6 style="color:black;">$text</h6>',
        '<p style="color:black;">$text</p>',
      ].join()}</div>',
    );
  });

  testWidgets('Seo.image is processed correctly', (tester) async {
    await tester.pumpWidget(TestSeoController(
      tree: (context) => WidgetTree(context: context),
      child: const TestSeoImage(),
    ));
    await tester.pumpAndSettle(debounceTime);

    expect(
      bodyHtml,
      '<div><noscript><img src="$src" alt="$alt" height="$height" width="$width"></noscript></div>',
    );
  });

  testWidgets('Seo.link is processed correctly', (tester) async {
    await tester.pumpWidget(TestSeoController(
      tree: (context) => WidgetTree(context: context),
      child: const TestSeoLink(),
    ));
    await tester.pumpAndSettle(debounceTime);

    expect(
      bodyHtml,
      '<div><div><a href="$href"><p>$anchor</p></a></div></div>',
    );
  });

  testWidgets('multiple Seo\'s are processed correctly', (tester) async {
    await tester.pumpWidget(TestSeoController(
      tree: (context) => WidgetTree(context: context),
      child: TestSeoHead(
        child: TestSeoLink(
          child: Row(
            children: const [
              TestSeoImage(),
              TestSeoText(),
            ],
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle(debounceTime);

    expect(
      headHtml,
      [
        '<meta name="$name" content="$content" flt-seo="">',
        '<meta http-equiv="$httpEquiv" content="$content" flt-seo="">',
        '<meta name="$name" http-equiv="$httpEquiv" content="$content" flt-seo="">',
        '<link title="$title" href="$href" flt-seo="">',
        '<link type="$type" media="$media" flt-seo="">',
        '<link title="$title" rel="$rel" type="$type" href="$href" media="$media" flt-seo="">',
      ].join('\n'),
    );

    expect(
      bodyHtml,
      '<div><div><a href="$href"><p>$anchor</p></a><noscript><img src="$src" alt="$alt" height="$height" width="$width"></noscript><p style="color:black;">$text</p></div></div>',
    );
  });

  testWidgets('traverse executes <3ms for single widget', (tester) async {
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

    expect(duration, lessThanOrEqualTo(3000));
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
