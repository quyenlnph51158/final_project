import 'package:flutter/material.dart';
import 'package:final_project/core/constants/colors.dart';

class DrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final double fontSize;

  const DrawerItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: kSidebarTextColor, size: fontSize + 4),
      title: Text(
        title,
        style: TextStyle(
          color: kSidebarTextColor,
          fontSize: fontSize,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: fontSize - 2, color: kSidebarTextColor),
      onTap: onTap,
    );
  }
}