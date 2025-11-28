class Letter {
  final int id;
  final String name;
  final String date;
  final int employeeId;
  final int formatId;

  Letter({
    required this.id,
    required this.name,
    required this.date,
    required this.employeeId,
    required this.formatId,
  });

  factory Letter.fromJson(Map<String, dynamic> json) {
    return Letter(
      id: json['id'],
      name: json['name'],
      date: json['date'],
      employeeId: json['employee_id'],
      formatId: json['letter_format_id'],
    );
  }
}
