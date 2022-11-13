import 'package:faker/faker.dart';

class Post {
  final int id;
  final String imageSmall;
  final String imageLarge;
  final String title;
  final String text;
  final String author;
  final String date;

  Post(int id) : this._(id, Faker(seed: id));

  Post._(this.id, Faker faker)
      : imageSmall = 'https://picsum.photos/id/$id/64/64',
        imageLarge = 'https://picsum.photos/id/$id/256/256',
        title = faker.food.dish(),
        text = faker.lorem.sentences(10).join(' '),
        author = faker.person.name(),
        date = faker.date.time();
}
