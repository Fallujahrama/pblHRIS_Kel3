class Superior {
  final int id;
  final String fullName;
  final String position;
  final String phone;
  final String email;
  final String? companyName;

  Superior({
    required this.id,
    required this.fullName,
    required this.position,
    required this.phone,
    required this.email,
    this.companyName,
  });

  factory Superior.fromJson(Map<String, dynamic> json) {
    return Superior(
      id: json['id'],
      fullName: json['full_name'],
      position: json['position'],
      phone: json['phone'],
      email: json['email'],
      companyName: json['company']?['name'],
    );
  }
}
