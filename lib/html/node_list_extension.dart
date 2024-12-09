import 'package:web/web.dart';

extension NodeListExtension on NodeList {
  List<Node?> toList() {
    return List.generate(length, (index) => item(index));
  }
}
