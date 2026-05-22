import 'package:final_project/features/train/data/models/passenger_model.dart';

class CreateBookingRequest {
  String? payload;
  String? trainGoSelected;
  int? trainGoSelectedFareClassIndex;
  String? trainReturnSelected;
  int? trainReturnSelectedFareClassIndex;
  String? customer_note;
  List<PassengerModel>? passenger;
  String? customerName;
  String? customerPhone;
  String? customerEmail;
  String? customerCountryCode;
  List<SpecialRequestModel>? extra;

  CreateBookingRequest({
    this.payload,
    this.trainGoSelected,
    this.trainGoSelectedFareClassIndex,
    this.trainReturnSelected,
    this.trainReturnSelectedFareClassIndex,
    this.customer_note,
    this.extra,
    this.passenger,
    this.customerName,
    this.customerPhone,
    this.customerEmail,
    this.customerCountryCode,
  });

  Map<String, dynamic> toJson() {
    return {
      "payload": payload,
      "trainGoSelected": trainGoSelected,
      "trainGoSelectedFareClassIndex": trainGoSelectedFareClassIndex,
      "trainReturnSelected": trainReturnSelected,
      "trainReturnSelectedFareClassIndex": trainReturnSelectedFareClassIndex,
      "customer_note": customer_note,
      "extra": extra,
      "passenger": passenger!.map((i) => i.toJson()).toList(),
      "customer_name": customerName,
      "customer_phone": customerPhone,
      "customer_email": customerEmail,
      "customer_country_code": customerCountryCode,
    };
  }
}
class SpecialRequestModel {
  int? index;
  String? address;
  SpecialRequestModel({
    this.index,
    this.address,
  });
  Map<String, dynamic> toJson(){
    return {
      "index": index,
      "address": address
    };
  }


}
