abstract class MetaTag {
  final String content;

  const MetaTag({
    required this.content,
  });
}

class MetaNameTag extends MetaTag {
  final String name;

  const MetaNameTag({
    required this.name,
    required super.content,
  });
}

class MetaPropertyTag extends MetaTag {
  final String property;

  const MetaPropertyTag({
    required this.property,
    required super.content,
  });
}
