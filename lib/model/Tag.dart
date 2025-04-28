class Tag {
  final String name;
  final String url;

  Tag({
    required this.name,
    required this.url,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      name: json['name'],
      url: json['url'],
    );
  }
}