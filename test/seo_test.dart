import 'package:flutter_test/flutter_test.dart';

void main() {
  test('adds one to input values', () {
    // TODO
  });
}

T measure<T>(T Function() measure, {String key = ''}) {
  final stopwatch = Stopwatch()..start();
  final result = measure();
  print('measure($key) executed in ${stopwatch.elapsed}');
  return result;
}
