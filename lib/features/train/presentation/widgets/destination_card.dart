import 'package:final_project/core/constants/colors.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_layout.dart';

class DestinationCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;

  const DestinationCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Thay h(2) bằng rh(16) để khoảng cách dưới cố định theo tỷ lệ pixel chuẩn
      margin: EdgeInsets.only(bottom: context.rh(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.radius),
        border: Border.all(color: kBorderColor.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(context.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hình ảnh được bo tròn
            ClipRRect(
              borderRadius: BorderRadius.circular(context.radius * 0.8),
              child: Image.network(
                imageUrl,
                // Thay h(22) bằng rh(180) để chiều cao ảnh ổn định trên các dòng máy dài/ngắn
                height: context.rh(180).clamp(150.0, 250.0),
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: context.rh(180).clamp(150.0, 250.0),
                    color: Colors.grey.shade100,
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  height: context.rh(180).clamp(150.0, 250.0),
                  color: Colors.grey.shade200,
                  child: Icon(
                    Icons.image_not_supported,
                    size: context.icon(30),
                    color: Colors.grey,
                  ),
                ),
              ),
            ),

            // Thay h(2) bằng rh(12) cho khoảng cách giữa ảnh và tiêu đề
            SizedBox(height: context.rh(12)),

            // 2. Tiêu đề
            Text(
              title,
              style: TextStyle(
                fontSize: context.sp(19),
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2D2D2D),
                letterSpacing: -0.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            // Thay h(0.8) bằng rh(4) cho khoảng cách giữa tiêu đề và mô tả
            SizedBox(height: context.rh(4)),

            // 3. Mô tả
            Text(
              description,
              style: TextStyle(
                fontSize: context.sp(14),
                color: Colors.grey.shade700,
                height: 1.5,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
