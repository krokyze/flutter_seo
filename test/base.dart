// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:ui';

import 'package:collection/collection.dart';

const largeScreenSize = Size(1024, 2048 * 128);

const debounceTime = Duration(milliseconds: 250);

String? get headHtml => document.head?.children
    .where((element) => element.attributes.containsKey('flt-seo'))
    .map((element) => element.outerHtml)
    .join('\n');

String? get bodyHtml => document.body?.children
    .firstWhereOrNull((element) => element.localName == 'flt-seo')
    ?.innerHtml;

Duration measure<T>(T Function() measure) {
  final stopwatch = Stopwatch()..start();
  measure();
  return stopwatch.elapsed;
}
