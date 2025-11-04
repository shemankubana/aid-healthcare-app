class Article {
  final String id;
  final String title;
  final String author;
  final String content;
  final String? imageUrl;
  final String? category;
  final DateTime createdAt;
  final int readTime; // in minutes
  final bool isLiked;
  final int likes;

  Article({
    required this.id,
    required this.title,
    required this.author,
    required this.content,
    this.imageUrl,
    this.category,
    required this.createdAt,
    this.readTime = 5,
    this.isLiked = false,
    this.likes = 0,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['imageUrl'],
      category: json['category'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      readTime: json['readTime'] ?? 5,
      isLiked: json['isLiked'] ?? false,
      likes: json['likes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'content': content,
      'imageUrl': imageUrl,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'readTime': readTime,
      'isLiked': isLiked,
      'likes': likes,
    };
  }
}
