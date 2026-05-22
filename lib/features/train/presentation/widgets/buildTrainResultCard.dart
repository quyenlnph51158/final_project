import 'package:flutter/material.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:final_project/core/utils/responsive_layout.dart';

class TrainResult {
  final String trainCompany;
  final String trainCompanyLogoUrl;
  final String departureStation;
  final String arrivalStation;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final double price;

  TrainResult({
    required this.trainCompany,
    required this.trainCompanyLogoUrl,
    required this.departureStation,
    required this.arrivalStation,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.price,
  });
}

Widget buildTrainResultCard(BuildContext context, TrainResult train) {
  final l10n = AppLocalizations.of(context)!;

  void _selectTrainAndContinue(
    BuildContext context,
    TrainResult selectedTrain,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n.train_directOfMove(
            selectedTrain.trainCompany,
            selectedTrain.departureStation,
            selectedTrain.arrivalStation,
          ),
          style: TextStyle(fontSize: context.sp(14)),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        // Dùng rh để SnackBar cách Home bar chính xác trên máy thật
        margin: EdgeInsets.all(context.padding),
      ),
    );
  }

  return Container(
    // Thay h(0.8) bằng rh(8) để khoảng cách dọc ổn định
    margin: EdgeInsets.symmetric(
      vertical: context.rh(8),
      horizontal: context.padding,
    ),
    // Padding 12 hoặc 16 tùy thiết bị
    padding: EdgeInsets.all(context.padding),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(context.radius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          // Làm đậm nhẹ shadow cho máy thật
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        // Logo hãng tàu
        ClipRRect(
          borderRadius: BorderRadius.circular(context.radius * 0.4),
          child: Image.network(
            train.trainCompanyLogoUrl,
            // Dùng icon() để giữ tỉ lệ pixel hoàn hảo
            height: context.icon(35),
            width: context.icon(35),
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                Icon(Icons.train, color: Colors.orange, size: context.icon(28)),
          ),
        ),
        // Thay w(3) bằng rw(12) cho khoảng cách ngang chuẩn
        SizedBox(width: context.rw(12)),

        // Giờ khởi hành + ga đi đến
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    train.departureTime,
                    style: TextStyle(
                      fontSize: context.sp(16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.rw(4)),
                    child: Text(
                      "–",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: context.sp(14),
                      ),
                    ),
                  ),
                  Text(
                    train.arrivalTime,
                    style: TextStyle(
                      fontSize: context.sp(16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // Thay h(0.5) bằng rh(4)
              SizedBox(height: context.rh(4)),
              Text(
                "${train.departureStation} → ${train.arrivalStation}",
                style: TextStyle(
                  fontSize: context.sp(12),
                  color: Colors.grey.shade700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: context.rh(2)),
              Text(
                train.duration,
                style: TextStyle(fontSize: context.sp(11), color: Colors.grey),
              ),
            ],
          ),
        ),

        // Giá + nút đặt vé
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              train.price.toString(),
              style: TextStyle(
                fontSize: context.sp(17),
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
            // Thay h(1) bằng rh(8)
            SizedBox(height: context.rh(8)),
            ElevatedButton(
              onPressed: () => _selectTrainAndContinue(context, train),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                // Dùng rw/rh cho nút bấm để không bị biến dạng
                padding: EdgeInsets.symmetric(
                  horizontal: context.rw(12),
                  vertical: context.rh(6),
                ),
                minimumSize: Size(context.rw(80), context.rh(32)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.radius * 0.6),
                ),
              ),
              child: Text(
                l10n.general_bookingButton,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: context.sp(13),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
