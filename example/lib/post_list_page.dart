import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:seo/seo.dart';

class PostListPage extends StatelessWidget {
  const PostListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        itemCount: 64,
        itemBuilder: (_, index) => _Card(post: Post(index)),
        separatorBuilder: (_, __) => const SizedBox(height: 16.0),
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

  Post(int id) : this._(id, Faker(seed: id));

  Post._(int id, Faker faker)
      : image = 'https://picsum.photos/id/$id/100/100',
        title = faker.food.dish(),
        description = faker.lorem.sentence(),
        author = faker.person.name(),
        date = faker.date.time(),
        url = '/#/post/$id';
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
