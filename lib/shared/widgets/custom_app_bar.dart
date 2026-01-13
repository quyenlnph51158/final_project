import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget {
  final Color?  backgroundColor;
  const CustomAppBar({
    super.key,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.network('https://www.wonderingvietnam.com/assets/img/logo_footer.svg', // <-- Thay bằng đường dẫn ảnh của bạn
                height: 50,
                width: 50,
              ),
            ],
          ),
          // Nút Menu (Builder để truy cập Scaffold)
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: backgroundColor ?? Colors.white, size: 30),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
    );
  }
}