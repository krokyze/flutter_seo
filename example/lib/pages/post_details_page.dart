import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:seo/seo.dart';
import 'package:seo_example/post.dart';
import 'package:seo_example/widgets/app_head.dart';
import 'package:seo_example/widgets/app_image.dart';
import 'package:seo_example/widgets/app_text.dart';

class PostDetailsPage extends StatelessWidget {
  final int id;

  const PostDetailsPage({
    super.key,
    @pathParam required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final post = Post(id);

    return Scaffold(
      body: AppHead(
        title: post.title,
        description: post.text,
        author: post.author,
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  AppImage(
                    alt: post.title,
                    src: post.imageLarge,
                    width: 256,
                    height: 256,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: post.title,
                            tagStyle: TextTagStyle.h5,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Row(
                              children: [
                                AppText(
                                  text: post.author,
                                  style: Theme.of(context).textTheme.caption,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: AppText(
                                    text: post.date,
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: AppText(
                              text: post.text,
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
