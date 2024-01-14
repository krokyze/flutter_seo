import 'package:seo/head_tag.dart';

abstract class SeoTag {
  const SeoTag();
}

enum TextTagStyle { h1, h2, h3, h4, h5, h6, p }

class TextTag extends SeoTag {
  final String text;
  final TextTagStyle style;

  const TextTag({
    required this.text,
    required this.style,
  });
}

class ImageTag extends SeoTag {
  final String alt;
  final String src;

  const ImageTag({
    required this.alt,
    required this.src,
  });
}

class LinkTag extends SeoTag {
  final String anchor;
  final String href;
  final String? rel;

  const LinkTag({
    required this.anchor,
    required this.href,
    required this.rel,
  });
}

class HeadTags extends SeoTag {
  final List<HeadTag> tags;

  const HeadTags({
    required this.tags,
  });
}
