import 'package:flutter_test/flutter_test.dart';
import 'package:seo/html/tree/widget_tree.dart';

import 'base.dart';
import 'widgets/test_seo_controller.dart';
import 'widgets/test_seo_text.dart';

void main() {
  testWidgets('element is null if controller is disabled', (tester) async {
    await tester.pumpWidget(TestSeoController(
      enabled: false,
      tree: (context) => WidgetTree(context: context),
      child: const TestSeoText(),
    ));
    await tester.pumpAndSettle(debounceTime);

    expect(element, isNull);
  });

  testWidgets('element is not null if controller is enabled', (tester) async {
    await tester.pumpWidget(TestSeoController(
      enabled: true,
      tree: (context) => WidgetTree(context: context),
      child: const TestSeoText(),
    ));
    await tester.pumpAndSettle(debounceTime);

    expect(element, isNotNull);
  });
}
