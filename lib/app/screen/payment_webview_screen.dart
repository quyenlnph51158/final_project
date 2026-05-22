import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String paymentUrl;
  // Bỏ https và phần đầu, chỉ giữ lại đoạn đặc trưng nhất để so sánh
  final String returnUrlKey = "payment/onepay/return";

  const PaymentWebViewScreen({super.key, required this.paymentUrl});

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {super.initState();
  _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)

  // 1. LOG CÁC THÔNG BÁO TỪ CONSOLE CỦA TRANG WEB (Quan trọng nhất để bắt lỗi NG04002)
    ..setOnConsoleMessage((JavaScriptConsoleMessage message) {
      debugPrint('''
      [JS CONSOLE LOG]
      - Cấp độ: ${message.level}
      - Nội dung: ${message.message}
      ''');
    })

    ..setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (url) {
          setState(() => _isLoading = true);
          debugPrint(">>> BẮT ĐẦU LOAD TRANG: $url");
        },

        onPageFinished: (url) {
          setState(() => _isLoading = false);
          debugPrint(">>> ĐÃ LOAD XONG TRANG: $url");
        },

        // 2. LOG LỖI TÀI NGUYÊN (Lỗi DNS, SSL, hoặc không kết nối được)
        onWebResourceError: (WebResourceError error) {
          debugPrint('''
          [LỖI TÀI NGUYÊN WEB]
          - Mô tả: ${error.description}
          - Mã lỗi: ${error.errorCode}
          - Loại lỗi: ${error.errorType}
          - URL gây lỗi: ${error.url}
          ''');
        },

        onNavigationRequest: (NavigationRequest request) {
          debugPrint(">>> YÊU CẦU ĐIỀU HƯỚNG ĐẾN: ${request.url}");

          // Chốt chặn xử lý như đã bàn ở câu trước
          if (request.url.contains("payment/onepay/return")) {
            Navigator.pop(context, request.url);
            return NavigationDecision.prevent;
          }

          if (request.url.contains("payment-error") || request.url.contains("TIMEOUT")) {
            debugPrint(">>> PHÁT HIỆN TRANG LỖI CỦA ONEPAY - ĐÓNG NGAY");
            Navigator.pop(context, "PAYMENT_ERROR_SCREEN");
            return NavigationDecision.prevent;
          }

          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    // Thêm WillPopScope để xử lý khi người dùng tự bấm nút Back của điện thoại
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) return;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Thanh toán an toàn")),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              const Center(child: CircularProgressIndicator(color: Color(0xFF006D7C))),
          ],
        ),
      ),
    );
  }
}