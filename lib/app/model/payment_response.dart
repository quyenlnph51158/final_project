class PaymentResponse {
  final int status;
  final String msg;
  final PaymentData? data;

  PaymentResponse({required this.status, required this.msg, this.data});

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      status: json['status'] ?? 0,
      msg: json['msg'] ?? '',
      data: json['data'] != null ? PaymentData.fromJson(json['data']) : null,
    );
  }
}

class PaymentData {
  final String paymentUrl;
  final String bookingCode;
  final String transactionId;

  PaymentData({
    required this.paymentUrl,
    required this.bookingCode,
    required this.transactionId,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      paymentUrl: json['payment_url'] ?? '',
      bookingCode: json['booking_code'] ?? '',
      transactionId: json['transaction_sid'] ?? '',
    );
  }
}