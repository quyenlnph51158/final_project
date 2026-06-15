class FlightBookingRequest {
  String? payload;
  String? flightGoSelected;
  String? flightGoSelectedFareClassIndex;
  String? flightReturnSelected;
  String? flightReturnSelectedFareClassIndex;
  List<PassengerRequest>? passenger;
  String? customerName;
  String? customerPhone;
  String? customerEmail;
  String? confirmCustomerEmail;
  String? customerSpecialRequest;
  String? customerCountryCode;
  dynamic? hasExportBill; // 0 hoặc 1
  String? billCompany;
  String? billMst;
  String? billAddress;
  String? billReceiver;
  String? requestId;

  FlightBookingRequest({
    this.payload,
    this.flightGoSelected,
    this.flightGoSelectedFareClassIndex,
    this.flightReturnSelected,
    this.flightReturnSelectedFareClassIndex,
    this.passenger,
    this.customerName,
    this.customerPhone,
    this.customerEmail,
    this.confirmCustomerEmail,
    this.customerSpecialRequest,
    this.customerCountryCode,
    this.hasExportBill,
    this.billCompany,
    this.billMst,
    this.billAddress,
    this.billReceiver,
    this.requestId,
  });

  Map<String, dynamic> toJson() {
    return {
      "payload": payload,
      "flightGoSelected": flightGoSelected,
      "flightGoSelectedFareClassIndex": flightGoSelectedFareClassIndex,
      "flightReturnSelected": flightReturnSelected,
      "flightReturnSelectedFareClassIndex": flightReturnSelectedFareClassIndex,
      "passenger": passenger?.map((v) => v.toJson()).toList(),
      "customer_name": customerName,
      "customer_phone": customerPhone,
      "customer_email": customerEmail,
      "comfirm_customer_email": confirmCustomerEmail,
      "customer_special_request": customerSpecialRequest,
      "customer_country_code": customerCountryCode,
      "has_export_bill": hasExportBill,
      "bill_company": billCompany,
      "bill_mst": billMst,
      "bill_address": billAddress,
      "bill_receiver": billReceiver,
      "request_id": requestId,
    };
  }
}

class PassengerRequest {
  String? firstName;
  String? lastName;
  int? gender; // 1: Nam, 2: Nữ
  String? type; // adults, children, infant
  String? birthday;
  String? passportNumber;
  String? nationality;
  String? flyer;
  String? cardNumber;

  PassengerRequest({
    this.firstName,
    this.lastName,
    this.gender,
    this.type,
    this.birthday,
    this.passportNumber,
    this.nationality,
    this.flyer,
    this.cardNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      "first_name": firstName,
      "last_name": lastName,
      "gender": gender,
      "type": type,
      "birthday": birthday,
      "passport_number": passportNumber,
      "nationality": nationality,
      "flyer": flyer,
      "card_number": cardNumber,
    };
  }
}