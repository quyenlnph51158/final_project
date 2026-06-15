class UpdateProfileRequest {
  final String name;
  final String phone;
  final String email;
  final String gender;
  final String birthDay;

  UpdateProfileRequest({
   required this.name,
   required this.phone,
   required this.email,
   required this.gender,
   required this.birthDay,
  });

  Map<String, dynamic> toJson(){
    return {
      "name": name,
      "phone": phone,
      "email": email,
      "gender": gender,
      "birthday": birthDay,
    };
  }
}