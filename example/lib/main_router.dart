import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:seo_example/pages/post_details_page.dart';
import 'package:seo_example/pages/post_list_page.dart';

part 'main_router.gr.dart';

@AdaptiveAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: [
    AutoRoute(
      path: '/posts',
      page: PostListPage,
      initial: true,
    ),
    AutoRoute(
      path: '/posts/:id',
      page: PostDetailsPage,
    ),
    RedirectRoute(path: '*', redirectTo: '/'),
  ],
)
class MainRouter extends _$MainRouter {}
