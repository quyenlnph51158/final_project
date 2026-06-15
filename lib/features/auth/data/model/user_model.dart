class UserModel {
  final int id;
  final String name;
  final String account;
  final String phone;
  final String? email;
  final String? status;
  final String? type;
  final int points;

  UserModel({
    required this.id,
    required this.name,
    required this.account,
    required this.phone,
    this.email,
    this.status,
    this.type,
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
      'points': points,
    };
  }
}
