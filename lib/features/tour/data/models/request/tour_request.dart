class TourRequest {
  final String? tourSid;
  final String startDate;
  final String? departurePoint;
  final String fullName;
  final String phone;
  final String email;
  final String? note;
  final String srand;
  final String stime;
  final String stoken;
  final String sf;
  TourRequest({
    this.tourSid,
    required this.startDate,
    this.departurePoint,
    required this.fullName,
    required this.phone,
    required this.email,
    this.note,
    required this.srand,
    required this.stime,
    required this.stoken,
    required this.sf,
  });

  // Hàm chuyển Model thành JSON Map để gửi đi
  Map<String, dynamic> toJson() {
    return {
      'tour_sid': tourSid,
      'start_date': startDate,
      'departure_point': departurePoint,
      'full_name': fullName,
      'phone': phone,
      'email': email,
      'note': note,
      'srand': srand,
      'stime': stime,
      'stoken': stoken,
      'sf': sf,
    };
  }
}