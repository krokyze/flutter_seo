import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:seo/seo.dart';
import 'package:seo_example/main_router.dart';

void main() {
  usePathUrlStrategy();
  runApp(App());
}

class App extends StatelessWidget {
  App({super.key});

  final _router = MainRouter();

  @override
  Widget build(BuildContext context) {
    return SeoController(
      enabled: true,
      tree: WidgetTree(context: context),
      child: MaterialApp.router(
        theme: Theme.of(context).copyWith(
          scaffoldBackgroundColor: const Color(0xFFEEEEEE),
          textTheme: Theme.of(context)
              .textTheme
              .copyWith(
                headlineSmall: const TextStyle(fontWeight: FontWeight.w600),
                titleLarge: const TextStyle(fontWeight: FontWeight.w600),
              )
              .apply(
                displayColor: Colors.black,
                bodyColor: Colors.black,
              ),
        ),
        routerDelegate: _router.delegate(),
        routeInformationParser: _router.defaultRouteParser(),
      ),
    );
  }
}
