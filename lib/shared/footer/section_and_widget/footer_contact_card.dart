import 'package:flutter/material.dart';
import 'package:final_project/core/constants/colors.dart';
import '../../../core/utils/responsive_layout.dart';

class FooterContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const FooterContactCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Thay Card bằng Container để dễ kiểm soát Shadow và màu sắc đồng bộ
      margin: EdgeInsets.only(bottom: context.rh(8)),
      decoration: BoxDecoration(
        color: kContactBoxColor,
        borderRadius: BorderRadius.circular(context.radius), // Sử dụng radius chuẩn (10 hoặc 14)
        border: Border.all(color: Colors.white.withOpacity(0.05)), // Viền cực nhẹ tạo chiều sâu
      ),
      child: Padding(
        padding: EdgeInsets.all(context.rw(16)), // Padding chuẩn 16px (có scale)
        child: Row(
          children: [
            // Icon sử dụng context.icon để scale cân đối
            Icon(
              icon,
              color: kHeaderTextColor,
              size: context.icon(26),
            ),

            SizedBox(width: context.rw(16)), // Khoảng cách giữa icon và text

            Expanded( // Bọc Expanded để tránh lỗi overflow khi text quá dài trên máy nhỏ
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: kHeaderTextColor,
                      fontSize: context.sp(15), // Scale font tiêu đề
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: context.rh(4)), // Khoảng cách dòng
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: kHeaderTextColor.withOpacity(0.8),
                      fontSize: context.sp(13), // Scale font nội dung
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}