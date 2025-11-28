class LetterFormat {
  final int id;
  final String name;
  final String content;

  LetterFormat({
    required this.id,
    required this.name,
    required this.content,
  });

  factory LetterFormat.fromJson(Map<String, dynamic> json) {
    return LetterFormat(
      id: json['id'],
      name: json['name'],
      content: json['content'],
    );
  }
}
