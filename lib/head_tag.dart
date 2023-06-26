abstract class HeadTag {
  const HeadTag();
}

class MetaTag extends HeadTag {
  final String? name;
  final String? httpEquiv;
  final String? content;

  const MetaTag({
    this.name,
    this.httpEquiv,
    this.content,
  });
}

class LinkTag extends HeadTag {
  final String? title;
  final String? rel;
  final String? type;
  final String? hreflang;
  final String? href;
  final String? media;

  const LinkTag({
    this.title,
    this.rel,
    this.type,
    this.hreflang,
    this.href,
    this.media,
  });
}
