// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

const debounceTime = Duration(milliseconds: 250);

Element? get element => document.body?.children
    .firstWhereOrNull((element) => element.localName == 'flt-seo');

String? get html => element?.innerHtml;
