import 'package:flutter/material.dart';

import '../screen/payment_webview_screen.dart';
import '../service/payment_service.dart';

class PaymentController extends ChangeNotifier {
  final PaymentService _service = PaymentService();
  bool isLoading = false;

  Future<void> startPaymentFlow(BuildContext context, String bookingId) async {
    isLoading = true;
    notifyListeners();

    try {
      // BƯỚC 1: Gọi API lấy link
      if (bookingId.isNotEmpty) {
        final res = await _service.makePayment(bookingId);

        if (res.status == 1 && res.data != null) {
          // BƯỚC 2: Mở WebView và đợi nó đóng
          print( 'this is transactionId ${res.data?.transactionId}');
          final String? returnUrl = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  PaymentWebViewScreen(paymentUrl: res.data!.paymentUrl),
            ),
          );

          // BƯỚC 3: Xử lý sau khi WebView đóng
          if (returnUrl != null) {
            _verifyPayment(context, res.data!.transactionId);
          }
        } else {
          _showError(context, res.msg);
        }
      }
    } catch (e) {
      _showError(context, e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // BƯỚC 4: Xác thực với Backend
  Future<void> _verifyPayment(BuildContext context, String transactionId) async {
    // 1. Hiện Loading
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator())
    );

    try {
      // 2. Chờ 2 giây để Backend xử lý IPN từ OnePay
      await Future.delayed(const Duration(seconds: 2));

      // 3. Check status
      final isSuccess = await _service.checkPaymentStatus(transactionId);

      if (context.mounted) Navigator.pop(context); // Đóng loading

      if (isSuccess) {
        _showSuccess(context); // Hiện màn hình thành công
      } else {
        _showError(context, "Thanh toán thất bại.");
      }
    } catch (e) {
      if (context.mounted) Navigator.pop(context); // Đóng loading
      _showError(context, "Lỗi kiểm tra: $e");
    }
  }

  void _showSuccess(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(title: const Text("Thông báo"), content: Text("Thanh toán thành công")),
    );
  }
  void _showError(BuildContext context, String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(title: const Text("Thông báo"), content: Text(msg)),
    );
  }
}