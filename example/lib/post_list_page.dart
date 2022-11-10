import 'package:flutter/material.dart';
import 'package:seo/seo.dart';

class PostListPage extends StatelessWidget {
  const PostListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        itemCount: 256,
        itemBuilder: (_, index) => _Card(post: Post(index: index)),
        separatorBuilder: (_, __) => const SizedBox(height: 32.0),
      ),
    );
  }
}

class Post {
  final String image;
  final String title;
  final String description;
  final String author;
  final String date;
  final String url;

  const Post({
    required int index,
  })  : image = 'https://picsum.photos/100/100?$index',
        title = '$index# TITLE',
        description = 'TODO: $index# descriptipon',
        author = 'TODO: $index# AUTHOR',
        date = 'TODO: $index# DATE',
        url = '/#/post/$index';
}

class _Card extends StatelessWidget {
  final Post post;

  const _Card({
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Seo.link(
      anchor: post.title,
      href: post.url,
      child: Row(
        children: [
          Seo.image(
            alt: post.title,
            url: post.image,
            child: Image.network(
              post.image,
              width: 100,
              height: 100,
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
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Seo.text(
                      text: post.description,
                      child: Text(
                        post.description,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
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
    );
  }
}
