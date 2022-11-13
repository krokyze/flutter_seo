import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:seo/seo.dart';
import 'package:seo_example/main_router.dart';
import 'package:seo_example/post.dart';

class PostListPage extends StatelessWidget {
  const PostListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        itemCount: 64,
        itemBuilder: (_, id) => _Card(post: Post(id)),
        separatorBuilder: (_, __) => const SizedBox(height: 16.0),
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
    const baseHref = '/flutter_seo'; // needed because of --base-href
    final route = PostDetailsRoute(id: post.id);

    return Seo.link(
      anchor: post.title,
      href: baseHref + route.fullPath,
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
                Seo.image(
                  alt: post.title,
                  url: post.imageSmall,
                  child: Image.network(
                    post.imageSmall,
                    width: 64,
                    height: 64,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Seo.text(
                          text: post.title,
                          child: Text(
                            post.title,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Row(
                            children: [
                              Seo.text(
                                text: post.author,
                                child: Text(
                                  post.author,
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Seo.text(
                                  text: post.date,
                                  child: Text(
                                    post.date,
                                    style: Theme.of(context).textTheme.caption,
                                  ),
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
