import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../controller/train_controller.dart';

class PromotionCard extends StatelessWidget {
  final String imageUrl;
  final String route;
  final String price;

  const PromotionCard({
    super.key,
    required this.imageUrl,
    required this.route,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = context.watch<TrainController>();
    return Container(
      // Sử dụng rh(16) để cố định khoảng cách dọc theo tỷ lệ thiết kế 812px
      margin: EdgeInsets.only(bottom: context.rh(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Hình ảnh địa điểm
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(context.radius),
            ),
            child: Image.network(
              imageUrl,
              // Thay h(20) bằng rh(160) để ảnh có chiều cao ổn định hơn trên các tỷ lệ màn hình khác nhau
              height: context.rh(160).clamp(140.0, 240.0),
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: context.rh(160).clamp(140.0, 240.0),
                color: Colors.grey.shade200,
                child: Icon(Icons.image_not_supported, size: context.icon(30)),
              ),
            ),
          ),

          Padding(
            // Sử dụng context.padding (12 hoặc 16) để thẳng hàng với các card khác
            padding: EdgeInsets.all(context.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2. Tên tuyến đường
                Text(
                  route,
                  style: TextStyle(
                    fontSize: context.sp(17),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D2D2D),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                // Dùng rh để kiểm soát khoảng cách nhỏ chính xác
                SizedBox(height: context.rh(8)),

                // 3. Phần giá và nút Chi tiết
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Khối thông tin giá bên trái
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.from_price,
                            style: TextStyle(
                              fontSize: context.sp(12),
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text( double.tryParse(price).toString(),
                            style: TextStyle(
                              fontSize: context.sp(20),
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor,
                            ),
                          ),
                          Text(
                            l10n.one_way,
                            style: TextStyle(
                              fontSize: context.sp(12),
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Nút Chi tiết bên phải
                    OutlinedButton(
                      onPressed: () {

                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: kPrimaryColor.withOpacity(0.5)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(context.radius * 0.7),
                        ),
                        // Dùng rw và rh cho padding nút để vùng bấm đạt chuẩn UX
                        padding: EdgeInsets.symmetric(
                          horizontal: context.rw(16),
                          vertical: context.rh(8),
                        ),
                        // fix chiều cao nút để không bị méo trên máy thật
                        minimumSize: Size(0, context.rh(36)),
                      ),
                      child: Text(
                        l10n.view_details_short,
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: context.sp(13),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}