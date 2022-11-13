import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:seo/seo.dart';
import 'package:seo_example/post.dart';

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
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Seo.image(
                  alt: post.title,
                  url: post.imageLarge,
                  child: Image.network(
                    post.imageLarge,
                    width: 256,
                    height: 256,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Seo.text(
                          text: post.title,
                          child: Text(
                            post.title,
                            style: Theme.of(context).textTheme.headline5,
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
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text(
                            post.text,
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
    );
  }
}
