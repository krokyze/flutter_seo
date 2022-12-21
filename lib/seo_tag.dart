import 'package:seo/meta_tag.dart';

abstract class SeoTag {
  const SeoTag();
}

class TextTag extends SeoTag {
  final String text;

  const TextTag({
    required this.text,
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

  const LinkTag({
    required this.anchor,
    required this.href,
  });
}

class MetaTags extends SeoTag {
  final List<MetaTag> tags;

  const MetaTags({
    required this.tags,
  });
}
