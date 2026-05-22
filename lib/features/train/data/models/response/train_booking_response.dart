import '../station_object.dart';
import '../train_model.dart';

class TrainBookingResponse {
  final int? status;
  final String? message;
  final TrainBookingData? data;
  final UserModel? user;

  TrainBookingResponse({this.status, this.message, this.data, this.user});

  factory TrainBookingResponse.fromJson(Map<String, dynamic> json) {
    return TrainBookingResponse(
      status: json['status'] is String ? int.tryParse(json['status']) : json['status'],
      message: json['message'],
      data: json['data'] != null ? TrainBookingData.fromJson(json['data']) : null,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }
}

class TrainBookingData {
  final BookingData? booking;
  final String? bookingSid;

  TrainBookingData({this.booking, this.bookingSid});

  factory TrainBookingData.fromJson(Map<String, dynamic> json) {
    return TrainBookingData(
      booking: json['booking'] != null ? BookingData.fromJson(json['booking']) : null,
      bookingSid: json['booking_sid'],
    );
  }
}

class BookingData {
  final int? id;
  final String? bookingCode;
  final String? amount;
  final String? currency;
  final String? bookingProduct;
  final int? partnerId;
  final String? customerPhone;
  final String? customerEmail;
  final CustomerInfo? customer;
  final BookingRequest? request; // Thông tin yêu cầu tìm kiếm ban đầu
  final BookingInfo? bookingInfo;
  final String? paymentExpiredAt;
  final String? startTime;
  final int? userId;
  final String? createdAt;
  final String? updatedAt;

  BookingData({
    this.id,
    this.bookingCode,
    this.amount,
    this.currency,
    this.bookingProduct,
    this.partnerId,
    this.customerPhone,
    this.customerEmail,
    this.customer,
    this.request,
    this.bookingInfo,
    this.paymentExpiredAt,
    this.startTime,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      id: json['id'] is String ? int.tryParse(json['id']) : json['id'],
      bookingCode: json['booking_code'],
      amount: json['amount']?.toString(),
      currency: json['currency'],
      bookingProduct: json['booking_product'],
      partnerId: json['partner_id'] is String ? int.tryParse(json['partner_id']) : json['partner_id'],
      customerPhone: json['customer_phone'],
      customerEmail: json['customer_email'],
      customer: json['customer'] != null ? CustomerInfo.fromJson(json['customer']) : null,
      request: json['request'] != null ? BookingRequest.fromJson(json['request']) : null,
      bookingInfo: json['booking_info'] != null ? BookingInfo.fromJson(json['booking_info']) : null,
      paymentExpiredAt: json['payment_expired_at'],
      startTime: json['start_time'],
      userId: json['user_id'] is String ? int.tryParse(json['user_id']) : json['user_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class BookingRequest {
  final String? startStation;
  final String? endStation;
  final int? adults;
  final int? children;
  final int? infant;
  final String? startDate;
  final String? returnDate;
  final int? typeTrip;

  BookingRequest({
    this.startStation,
    this.endStation,
    this.adults,
    this.children,
    this.infant,
    this.startDate,
    this.returnDate,
    this.typeTrip,
  });

  factory BookingRequest.fromJson(Map<String, dynamic> json) {
    return BookingRequest(
      startStation: json['start_station'],
      endStation: json['end_station'],
      adults: json['adults'] is String ? int.tryParse(json['adults']) : json['adults'],
      children: json['children'] is String ? int.tryParse(json['children']) : json['children'],
      infant: json['infant'] is String ? int.tryParse(json['infant']) : json['infant'],
      startDate: json['start_date'],
      returnDate: json['return_date'],
      typeTrip: json['type_trip'] is String ? int.tryParse(json['type_trip']) : json['type_trip'],
    );
  }
}

class BookingInfo {
  final TrainInfo? trainInfo;
  final List<PassengerModel>? passengers;
  final List<ExtraServiceModel>? extraService; // Các dịch vụ bổ sung (xe buýt...)
  final StationObject? startStation;
  final StationObject? endStation;
  final String? startTime;

  BookingInfo({
    this.trainInfo,
    this.passengers,
    this.extraService,
    this.startStation,
    this.endStation,
    this.startTime,
  });

  factory BookingInfo.fromJson(Map<String, dynamic> json) {
    return BookingInfo(
      trainInfo: json['train_info'] != null ? TrainInfo.fromJson(json['train_info']) : null,
      passengers: json['passengers'] != null
          ? (json['passengers'] as List).map((i) => PassengerModel.fromJson(i)).toList()
          : null,
      extraService: json['extra_service'] != null
          ? (json['extra_service'] as List).map((i) => ExtraServiceModel.fromJson(i)).toList()
          : null,
      startStation: json['start_station'] != null ? StationObject.fromJson(json['start_station']) : null,
      endStation: json['end_station'] != null ? StationObject.fromJson(json['end_station']) : null,
      startTime: json['start_time'],
    );
  }
}

class TrainInfo {
  final TrainSelected? trainSelected;
  final FareClass? trainGoFareClassSelected;
  final FareClass? trainReturnFareClassSelected; // Chiều về nếu có
  final int? typeTrip;
  final String? startDate;
  final String? returnDate;
  final int? adults;
  final int? children;
  final int? infant;

  TrainInfo({
    this.trainSelected,
    this.trainGoFareClassSelected,
    this.trainReturnFareClassSelected,
    this.typeTrip,
    this.startDate,
    this.returnDate,
    this.adults,
    this.children,
    this.infant,
  });

  factory TrainInfo.fromJson(Map<String, dynamic> json) {
    return TrainInfo(
      trainSelected: json['trainSelected'] != null ? TrainSelected.fromJson(json['trainSelected']) : null,
      trainGoFareClassSelected: json['trainGoFareClassSelected'] != null ? FareClass.fromJson(json['trainGoFareClassSelected']) : null,
      trainReturnFareClassSelected: json['trainReturnFareClassSelected'] != null ? FareClass.fromJson(json['trainReturnFareClassSelected']) : null,
      typeTrip: json['type_trip'] is String ? int.tryParse(json['type_trip']) : json['type_trip'],
      startDate: json['start_date'],
      returnDate: json['return_date'],
      adults: json['adults'] is String ? int.tryParse(json['adults']) : json['adults'],
      children: json['children'] is String ? int.tryParse(json['children']) : json['children'],
      infant: json['infant'] is String ? int.tryParse(json['infant']) : json['infant'],
    );
  }
}

class TrainSelected {
  final TrainModel? go;
  final TrainModel? returnTrain;

  TrainSelected({this.go, this.returnTrain});

  factory TrainSelected.fromJson(Map<String, dynamic> json) {
    return TrainSelected(
      go: json['go'] != null ? TrainModel.fromJson(json['go']) : null,
      returnTrain: json['return'] != null ? TrainModel.fromJson(json['return']) : null,
    );
  }
}

class FareClass {
  final int? tax;
  final num? price;
  final String? title;

  FareClass({this.tax, this.price, this.title});

  factory FareClass.fromJson(Map<String, dynamic> json) {
    return FareClass(
      tax: json['tax'] is String ? int.tryParse(json['tax']) : json['tax'],
      price: json['price'],
      title: json['title'],
    );
  }
}

class PassengerModel {
  final int? index;
  final String? type;
  final String? fullName;
  final String? birthday;
  final String? passport;
  final String? nationality;

  PassengerModel({this.index, this.type, this.fullName, this.birthday, this.passport, this.nationality});

  factory PassengerModel.fromJson(Map<String, dynamic> json) {
    return PassengerModel(
      index: json['Index'] is String ? int.tryParse(json['Index']) : json['Index'],
      type: json['Type'],
      fullName: json['FullName'],
      birthday: json['Birthday'],
      passport: json['Passport'],
      nationality: json['Nationality'],
    );
  }
}

class ExtraServiceModel {
  final String? name;
  final String? price;
  final String? address;

  ExtraServiceModel({this.name, this.price, this.address});

  factory ExtraServiceModel.fromJson(Map<String, dynamic> json) {
    return ExtraServiceModel(
      name: json['name'],
      price: json['price'],
      address: json['address'],
    );
  }
}

class CustomerInfo {
  final String? fullName;
  final String? lastName;
  final String? firstName;
  final String? countryCode;
  final String? phoneOriginal;

  CustomerInfo({this.fullName, this.lastName, this.firstName, this.countryCode, this.phoneOriginal});

  factory CustomerInfo.fromJson(Map<String, dynamic> json) {
    return CustomerInfo(
      fullName: json['full_name'],
      lastName: json['last_name'],
      firstName: json['first_name'],
      countryCode: json['country_code'],
      phoneOriginal: json['phoneOriginal'],
    );
  }
}

class UserModel {
  final int? id;
  final String? name;
  final String? account;
  final String? phone;
  final String? email;
  final String? status;
  final String? type;

  UserModel({this.id, this.name, this.account, this.phone, this.email, this.status, this.type});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is String ? int.tryParse(json['id']) : json['id'],
      name: json['name'],
      account: json['account'],
      phone: json['phone'],
      email: json['email']?.toString(),
      status: json['status'],
      type: json['type'],
    );
  }
}