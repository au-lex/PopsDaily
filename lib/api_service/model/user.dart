class User {
  final int id;
  final String fullName;
  final String email;
  final String phone;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        fullName: json['full_name'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone'] ?? '',
        createdAt: json['created_at'] != null
            ? DateTime.tryParse(json['created_at'])
            : null,
        updatedAt: json['updated_at'] != null
            ? DateTime.tryParse(json['updated_at'])
            : null,
      );
}