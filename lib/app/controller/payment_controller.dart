import 'package:final_project/features/tour/presentation/screens/travel_booking_screen.dart';
import 'package:flutter/material.dart';

import '../../core/utils/responsive_layout.dart';
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
        print('PAYMENT URL = ${res.data?.paymentUrl}');
        print('TXN = ${res.data?.transactionId}');
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
      bool isSuccess = false;
      // Thử kiểm tra 3 lần, mỗi lần cách nhau 3 giây
      for (int i = 0; i < 3; i++) {
        await Future.delayed(const Duration(seconds: 3));
        isSuccess = await _service.checkPaymentStatus(transactionId);
        if (isSuccess) break;
      }

      if (context.mounted) Navigator.pop(context); // Đóng Loading

      if (isSuccess) {
        _showSuccess(context);
      } else {
        _showError(context, "Hệ thống đang xử lý giao dịch. Vui lòng kiểm tra lịch sử đặt chỗ sau vài phút.");
      }
    } catch (e) {
      if (context.mounted) Navigator.pop(context); // Đóng loading
      _showError(context, "Lỗi kiểm tra: $e");
    }
  }

  void _showSuccess(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Bắt buộc người dùng phải nhấn OK
      builder: (ctx) => AlertDialog(
        title: Text("Thông báo", style: TextStyle(fontSize: context.sp(18), fontWeight: FontWeight.bold)),
        content: Text("Thanh toán thành công!", style: TextStyle(fontSize: context.sp(14))),
        actions: [
          TextButton(
            onPressed: () {
              // 1. Đóng Dialog
              Navigator.pop(ctx);

              // 2. Chuyển hướng về trang chủ và xóa sạch stack (không cho quay lại màn thanh toán)
              // Giả sử route trang chủ của bạn là '/' hoặc '/home'
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => TravelBookingScreen()), (route) => false);
            },
            child: Text("OK", style: TextStyle(color: const Color(0xFF006D7C), fontWeight: FontWeight.bold, fontSize: context.sp(14))),
          ),
        ],
      ),
    );
  }

  void _showError(BuildContext context, String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Thông báo", style: TextStyle(fontSize: context.sp(18), fontWeight: FontWeight.bold)),
        content: Text(msg, style: TextStyle(fontSize: context.sp(14))),
        actions: [
          TextButton(
            onPressed: () {
              // Chỉ đóng thông báo để người dùng kiểm tra lại thông tin hoặc thử lại
              Navigator.pop(ctx);
            },
            child: Text("Đóng", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: context.sp(14))),
          ),
        ],
      ),
    );
  }
}