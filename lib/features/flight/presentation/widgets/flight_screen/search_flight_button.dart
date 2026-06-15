import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/utils/responsive_layout.dart';
import '../../controller/flight_controller.dart';

class SearchFlightButton extends StatelessWidget {
  final String text;
  const SearchFlightButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<FlightController>();
    // Chỉ theo dõi isLoading để vô hiệu hóa nút khi đang xử lý
    final isLoading = context.select((FlightController c) => c.state.ui.isLoading);
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      height: context.rh(50).clamp(48.0, 55.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: isLoading ? null : () {
          // GỌI DUY NHẤT HÀM NÀY
          final bool isValid = controller.navigateToFlightResults(l10n);

          // Nếu controller báo lỗi validate, lấy lỗi từ state và hiện SnackBar
          if (!isValid) {
            final error = controller.state.ui.errorMessage;
            if (error != null && error.isNotEmpty) {
              _showErrorSnackBar(context, error);
            }
          }
        },
        child: isLoading
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search, color: Colors.white),
            const SizedBox(width: 8),
            Text(text, style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
          ],
        ),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}