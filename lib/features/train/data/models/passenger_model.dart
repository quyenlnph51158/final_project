class PassengerModel {
  String? name;
  String? type;
  String? birthday;
  String? passportNumber;
  String? nationnality;

  PassengerModel({
    this.name,
    this.type,
    this.birthday,
    this.nationnality,
    this.passportNumber
  });
  Map<String, dynamic> toJson(){
    return {
      "name": name,
      "type": type,
      "birthday": birthday,
      "passport_number": passportNumber,
      "nationality": 'VN',
    };
  }
}