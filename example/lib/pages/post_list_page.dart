import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:seo/seo.dart';
import 'package:seo_example/main_router.dart';
import 'package:seo_example/post.dart';
import 'package:seo_example/widgets/app_head.dart';
import 'package:seo_example/widgets/app_image.dart';
import 'package:seo_example/widgets/app_link.dart';
import 'package:seo_example/widgets/app_text.dart';

@RoutePage()
class PostListPage extends StatelessWidget {
  const PostListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppHead(
        title: 'Flutter SEO Example',
        description: 'This is a Flutter example webpage using seo package.',
        canonicalUrl: Uri.base.origin,
        child: ListView.separated(
          itemCount: 64,
          itemBuilder: (_, id) => _Card(post: Post(id)),
          separatorBuilder: (_, __) => const SizedBox(height: 16.0),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Post post;

  const _Card({
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    final route = PostDetailsRoute(id: post.id);

    return AppLink(
      anchor: post.title,
      href: route.match(context)!.fullPath,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => context.router.push(route),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                SizedBox.square(
                  dimension: 64.0,
                  child: AppImage(
                    alt: post.title,
                    src: post.imageSmall,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: post.title,
                          tagStyle: TextTagStyle.h6,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Row(
                            children: [
                              AppText(
                                text: post.author,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: AppText(
                                  text: post.date,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
