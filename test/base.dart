// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:ui';

import 'package:collection/collection.dart';

const largeScreenSize = Size(1024, 2048 * 128);

const debounceTime = Duration(milliseconds: 250);

Element? get element => document.body?.children
    .firstWhereOrNull((element) => element.localName == 'flt-seo');

String? get html => element?.innerHtml;

Duration measure<T>(T Function() measure) {
  final stopwatch = Stopwatch()..start();
  measure();
  return stopwatch.elapsed;
}
