import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:seo_example/pages/post_details_page.dart';
import 'package:seo_example/pages/post_list_page.dart';

part 'main_router.gr.dart';

@AutoRouterConfig()
class MainRouter extends _$MainRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/posts/',
          page: PostListRoute.page,
        ),
        AutoRoute(
          path: '/posts/:id/',
          page: PostDetailsRoute.page,
        ),
        RedirectRoute(path: '*', redirectTo: '/posts/'),
      ];
}
