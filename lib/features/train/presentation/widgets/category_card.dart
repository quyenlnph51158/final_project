import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_layout.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String imageUrl;

  const CategoryCard({super.key, required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    // Sử dụng rw(140) để ảnh có kích thước ổn định theo tỷ lệ pixel chuẩn
    // Giới hạn an toàn để không quá bé trên máy nhỏ và không quá thô trên máy lớn
    final double circleSize = context.rw(140).clamp(100.0, 180.0);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        // Sử dụng radius chuẩn (10px cho máy nhỏ, 14px cho máy thường)
        borderRadius: BorderRadius.circular(context.radius),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      // Thay h(4) bằng rh(30) để padding dọc cân đối hơn trên máy thật
      padding: EdgeInsets.symmetric(vertical: context.rh(30)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Widget tạo hình ảnh tròn
          Container(
            width: circleSize,
            height: circleSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Thay h(2) bằng rh(16) cho khoảng cách giữa ảnh và chữ
          SizedBox(height: context.rh(16)),

          // Tiêu đề chữ responsive
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.rw(12)),
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2, // Đề phòng tiêu đề dài
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: context.sp(17), // Giảm nhẹ xuống 17 cho tinh tế
                fontWeight: FontWeight.bold,
                color: const Color(0xFF001D27),
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
