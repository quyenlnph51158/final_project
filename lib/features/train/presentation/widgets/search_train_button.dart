import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/l10n/app_localizations.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../controller/train_controller.dart';

class SearchTrainButton extends StatelessWidget {
  final String text;

  const SearchTrainButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = context.watch<TrainController>();

    return SizedBox(
      width: double.infinity,
      // Sử dụng rh(50) để nút cao khoảng 50px (đã nhân scale)
      // clamp đảm bảo nút không quá bé dưới 48px hoặc quá thô trên 60px
      height: context.rh(50).clamp(48.0, 60.0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          // Sử dụng radius chuẩn từ extension (10 hoặc 14)
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.radius),
          ),
          // Padding ngang đồng bộ theo tỷ lệ thiết kế
          padding: EdgeInsets.symmetric(horizontal: context.rw(16)),
        ),
        icon: Icon(
          Icons.search,
          color: Colors.white,
          // Sử dụng icon() để scale biểu tượng kính lúp mượt mà
          size: context.icon(22),
        ),
        label: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            // Sử dụng sp() để font chữ không bị vỡ layout trên máy thật
            fontSize: context.sp(16),
          ),
        ),
        onPressed: () {
          controller.validateForm(l10n);
          if (controller.state.ui.errorMessage.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  controller.state.ui.errorMessage,
                  style: TextStyle(fontSize: context.sp(14)),
                ),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.radius),
                ),
                // Sử dụng lề chuẩn của hệ thống
                margin: EdgeInsets.all(context.padding),
              ),
            );
          } else {
            controller.navigateToTrainResults(l10n);
          }
        },
      ),
    );
  }
}
