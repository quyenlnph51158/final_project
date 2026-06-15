import '../flight_item.dart';
import '../flight_inventory.dart';

/// 1. Top-level Response
class FlightBookingResponse {
  int? status;
  String? requestId;
  String? message;
  BookingData? data;
  BookingUser? user;

  FlightBookingResponse({
    this.status,
    this.requestId,
    this.message,
    this.data,
    this.user,
  });

  factory FlightBookingResponse.fromJson(Map<String, dynamic> json) {
    return FlightBookingResponse(
      status: json['status'],
      requestId: json['request_id'],
      message: json['message'],
      data: json['data'] != null ? BookingData.fromJson(json['data']) : null,
      user: json['user'] != null ? BookingUser.fromJson(json['user']) : null,
    );
  }
}

/// 2. Intermediate Data Layer
class BookingData {
  BookingModel? booking;
  String? bookingSid;

  BookingData({this.booking, this.bookingSid});

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      booking: json['booking'] != null
          ? BookingModel.fromJson(json['booking'])
          : null,
      bookingSid: json['booking_sid'],
    );
  }
}

/// 3. The main Booking Model
class BookingModel {
  int? id;
  String? bookingCode;
  double? amount;
  String? currency;
  String? customerPhone;
  String? customerEmail;
  String? paymentExpiredAt;
  String? createdAt;
  CustomerInfo? customer;
  BookingDetailsContainer? bookingInfo;

  BookingModel({
    this.id,
    this.bookingCode,
    this.amount,
    this.currency,
    this.customerPhone,
    this.customerEmail,
    this.paymentExpiredAt,
    this.createdAt,
    this.customer,
    this.bookingInfo,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      bookingCode: json['booking_code'],
      amount: json['amount'] != null ? double.parse(json['amount'].toString()) : 0.0,
      currency: json['currency'],
      customerPhone: json['customer_phone'],
      customerEmail: json['customer_email'],
      paymentExpiredAt: json['payment_expired_at'],
      createdAt: json['created_at'],
      customer: (json['customer'] is Map) ? CustomerInfo.fromJson(json['customer']) : null,
      bookingInfo: (json['booking_info'] is Map) ? BookingDetailsContainer.fromJson(json['booking_info']) : null,
    );
  }
}

/// 4. Container for Product Specific Info (Flight, Hotel, etc.)
class BookingDetailsContainer {
  FlightBookingDetails? flight;

  BookingDetailsContainer({this.flight});

  factory BookingDetailsContainer.fromJson(Map<String, dynamic> json) {
    return BookingDetailsContainer(
      flight: json['flight'] != null
          ? FlightBookingDetails.fromJson(json['flight'])
          : null,
    );
  }
}

/// 5. Detailed Flight Booking Information
class FlightBookingDetails {
  FlightInnerInfo? flightInfo;
  List<FlightPassengerResponse>? passengers;
  String? startTime;

  FlightBookingDetails({this.flightInfo, this.passengers, this.startTime});

  factory FlightBookingDetails.fromJson(Map<String, dynamic> json) {
    return FlightBookingDetails(
      flightInfo: json['flight_info'] != null
          ? FlightInnerInfo.fromJson(json['flight_info'])
          : null,
      passengers: json['passengers'] != null
          ? (json['passengers'] as List)
                .map((v) => FlightPassengerResponse.fromJson(v))
                .toList()
          : null,
      startTime: json['start_time'],
    );
  }
}

/// 6. The actual Flight/Tickets selected
class FlightInnerInfo {
  String? startAirport;
  String? endAirport;
  FlightItem? flightSelected; // TÁI SỬ DỤNG FlightItem model đã có của bạn
  FlightInventory? flightGoFareClassSelected; // TÁI SỬ DỤNG FlightInventory
  FlightInventory? flightReturnFareClassSelected;

  FlightInnerInfo({
    this.startAirport,
    this.endAirport,
    this.flightSelected,
    this.flightGoFareClassSelected,
    this.flightReturnFareClassSelected,
  });

  factory FlightInnerInfo.fromJson(Map<String, dynamic> json) {
    return FlightInnerInfo(
      startAirport: json['start_airport'] is String ? json['start_airport'] : null,
      endAirport: json['end_airport'] is String ? json['end_airport'] : null,

      flightSelected: (json['flightSelected'] is Map)
          ? FlightItem.fromJson(json['flightSelected'])
          : null,

      flightGoFareClassSelected: (json['flightGoFareClassSelected'] is Map)
          ? FlightInventory.fromJson(json['flightGoFareClassSelected'])
          : null,

      flightReturnFareClassSelected: (json['flightReturnFareClassSelected'] is Map)
          ? FlightInventory.fromJson(json['flightReturnFareClassSelected'])
          : null,
    );
  }
}

/// 7. Passenger Information as returned by Server
class FlightPassengerResponse {
  int? index;
  String? type;
  String? firstName;
  String? lastName;
  int? gender;
  String? birthday;
  String? passport;
  String? nationality;

  FlightPassengerResponse({
    this.index,
    this.type,
    this.firstName,
    this.lastName,
    this.gender,
    this.birthday,
    this.passport,
    this.nationality,
  });

  factory FlightPassengerResponse.fromJson(Map<String, dynamic> json) {
    return FlightPassengerResponse(
      index: json['Index'],
      type: json['Type'],
      firstName: json['FirstName'],
      lastName: json['LastName'],
      gender: json['Gender'],
      birthday: json['Birthday'],
      passport: json['Passport'],
      nationality: json['Nationality'],
    );
  }
}

/// 8. Customer Info
class CustomerInfo {
  String? fullName;
  String? phoneOriginal;
  String? customerSpecialRequest;
  String? countryCode;

  CustomerInfo({
    this.fullName,
    this.phoneOriginal,
    this.customerSpecialRequest,
    this.countryCode,
  });

  factory CustomerInfo.fromJson(Map<String, dynamic> json) {
    return CustomerInfo(
      fullName: json['full_name'],
      phoneOriginal: json['phoneOriginal'],
      customerSpecialRequest: json['customer_special_request'],
      countryCode: json['country_code'],
    );
  }
}

/// 9. User Info
class BookingUser {
  int? id;
  String? name;
  String? account;
  int? points;

  BookingUser({this.id, this.name, this.account, this.points});

  factory BookingUser.fromJson(Map<String, dynamic> json) {
    return BookingUser(
      id: json['id'],
      name: json['name'],
      account: json['account'],
      points: json['points'],
    );
  }
}
