import 'package:flutter/material.dart';
import 'package:seo/seo.dart';
import 'package:seo_example/main_router.dart';

void main() {
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
                headline5: const TextStyle(fontWeight: FontWeight.w600),
                headline6: const TextStyle(fontWeight: FontWeight.w600),
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
