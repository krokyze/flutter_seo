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
      : imageSmall = faker.image.loremPicsum(
          width: 128,
          height: 128,
          seed: '$id',
          imageFormat: ImageFormat.webp,
        ),
        imageLarge = faker.image.loremPicsum(
          width: 512,
          height: 512,
          seed: '$id',
          imageFormat: ImageFormat.webp,
        ),
        title = faker.food.dish(),
        text = faker.lorem.sentences(10).join(' '),
        author = faker.person.name(),
        date = faker.date.time();
}
