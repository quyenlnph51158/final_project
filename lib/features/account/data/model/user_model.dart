class UserModel {
  final int id;
  final String name;
  final String account;
  final String phone;
  final String? email;
  final String? status;
  final String? type;
  final String? birthDate;
  final String? gender;
  final int points;

  UserModel({
    required this.id,
    required this.name,
    required this.account,
    required this.phone,
    this.email,
    this.status,
    this.type,
    this.birthDate,
    this.gender,
    this.points = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      account: json['account'] ?? '',
      phone: json['phone'] ?? '',
      email: (json['email'] is String) ? json['email'] : null,
      status: json['status'],
      type: json['type'],
      birthDate: json['birth_date'],
      gender: json['gender'],
      points: json['points'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'account': account,
      'phone': account,
      'email': email,
      'status': status,
      'type': type,
      'birth_date': birthDate,
      'gender': gender,
      'points': points,
    };
  }
}
