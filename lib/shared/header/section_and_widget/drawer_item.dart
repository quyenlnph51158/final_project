import 'package:flutter/material.dart';
import 'package:final_project/core/constants/colors.dart';
import '../../../core/utils/responsive_layout.dart';

class DrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isBold;

  const DrawerItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    // Định nghĩa cỡ chữ cơ sở (base size), sp() sẽ tự scale và clamp an toàn
    final double baseFontSize = isBold ? 17 : 15;

    return ListTile(
      // Sử dụng context.padding (12 hoặc 16) để thẳng hàng với Header/Divider
      contentPadding: EdgeInsets.symmetric(
        horizontal: context.padding,
        // Dùng rh(4) thay vì h(0.2) để cố định khoảng cách dọc theo tỷ lệ pixel
        vertical: context.rh(4),
      ),

      // Icon co giãn mượt mà theo mật độ điểm ảnh của máy thật
      leading: Icon(icon, color: kSidebarTextColor, size: context.icon(22)),

      title: Text(
        title,
        style: TextStyle(
          color: kSidebarTextColor,
          fontSize: context.sp(baseFontSize),
          fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
        ),
      ),

      // Icon mũi tên (chevron) sử dụng size nhỏ hơn để tinh tế
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: context.icon(12),
        color: kSidebarTextColor.withOpacity(0.3),
      ),

      onTap: onTap,
    );
  }
}
