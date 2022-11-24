class SeoHtml {
  final String head;
  final String body;

  const SeoHtml({
    required this.head,
    required this.body,
  });

  SeoHtml copyWith({
    String? head,
    String? body,
  }) {
    return SeoHtml(
      head: head ?? this.head,
      body: body ?? this.body,
    );
  }

  SeoHtml operator +(SeoHtml b) {
    return copyWith(
      head: head + b.head,
      body: body + b.body,
    );
  }
}
