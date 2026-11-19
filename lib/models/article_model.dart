class ArticleModel {
  final String? author;
  final String title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String publishedAt;
  final String? content;

  ArticleModel({
    this.author,
    required this.title,
    this.description,
    this.url,
    this.urlToImage,
    required this.publishedAt,
    this.content,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    final source = json['source'];
    return ArticleModel(
      author: source is Map ? source['name'] as String? : null,
      title: json['title'] as String? ?? 'Tanpa Judul',
      description: json['description'] as String?,
      url: json['url'] as String?,
      urlToImage: json['image'] as String?,
      publishedAt: json['publishedAt'] as String? ?? '',
      content: _rapikanContent(json['content'] as String?),
    );
  }

  /// Paket gratis memotong content dan menambahkan penanda seperti " [988 chars]"
  static String? _rapikanContent(String? content) {
    if (content == null) return null;
    return content.replaceAll(RegExp(r'\s*\[\d+ chars\]$'), '...');
  }
}
