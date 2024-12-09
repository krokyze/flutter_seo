// ignore: avoid_web_libraries_in_flutter
import 'package:seo/html/node_list_extension.dart';
import 'package:web/web.dart';
import 'dart:ui';

const largeScreenSize = Size(1024, 2048 * 128);

const debounceTime = Duration(milliseconds: 250);

String? get headHtml => document.head
    ?.querySelectorAll('[flt-seo]')
    .toList()
    .whereType<Element>()
    .map((node) => node.outerHTML.toString())
    .join('\n');

String? get bodyHtml => document.body
    ?.querySelectorAll('[flt-seo]')
    .toList()
    .whereType<Element>()
    .map((node) => node.innerHTML.toString())
    .firstOrNull;

Duration measure<T>(T Function() measure) {
  final stopwatch = Stopwatch()..start();
  measure();
  return stopwatch.elapsed;
}
