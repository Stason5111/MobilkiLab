class News {
  final String title;
  final String description;
  final String content;

  News({required this.title, required this.description, required this.content});

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      content: json['content'] ?? 'No Content',
    );
  }
}
