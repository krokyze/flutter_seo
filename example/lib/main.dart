import 'package:flutter/material.dart';
import 'package:seo/seo.dart';
import 'package:seo_example/post_list_page.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return SeoController(
      enabled: true,
      tree: WidgetTree(context: context),
      child: const MaterialApp(
        home: PostListPage(),
      ),
    );
  }
}
