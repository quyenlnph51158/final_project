import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import các màn hình
import 'package:final_project/features/account/presentation/screen/profile_screen.dart';
import 'package:final_project/features/train/presentation/screens/train_screen.dart';
import 'package:final_project/features/tour/presentation/screens/travel_booking_screen.dart';
import 'package:final_project/features/tour/presentation/screens/tour_screen.dart';
import 'package:final_project/features/flight/presentation/screens/flight_screen.dart';
import 'package:final_project/features/account/presentation/screen/login_screen.dart';

// Import controllers và core
import 'package:final_project/features/account/presentation/controller/auth_controller.dart';
import 'package:final_project/features/train/presentation/controller/train_controller.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:final_project/app/l10n/app_localizations.dart';
import '../../../../core/utils/responsive_layout.dart';

typedef TabSelectedCallback = void Function(dynamic tab); // Sửa TravelTab/FlightTab thành dynamic nếu cần dùng chung
typedef ControllerCallback = FutureOr<void> Function();

class AppDrawer extends StatelessWidget {


  const AppDrawer({
    super.key,
  });

  Widget _buildDrawerItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback action,
    ControllerCallback? controller, // Chuyển sang optional
    bool isBold = false,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: context.padding,
        vertical: context.rh(4),
      ),
      leading: Icon(icon, color: kSidebarTextColor, size: context.icon(22)),
      title: Text(
        title,
        style: TextStyle(
          color: kSidebarTextColor,
          fontSize: context.sp(isBold ? 17 : 15),
          fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: context.icon(12),
        color: kSidebarTextColor.withOpacity(0.3),
      ),
      onTap: () async {
        // 1. Đóng drawer ngay lập tức để tạo phản hồi nhanh
        Navigator.pop(context);

        // 2. Chạy logic controller (nếu có)
        if (controller != null) {
          await controller();
        }

        // 3. Thực hiện hành động chuyển màn hình
        action();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authController = context.watch<AuthController>();
    final isLoggedIn = authController.state.ui.isLoggedIn;

    return Drawer(
      width: context.rw(280).clamp(250.0, 320.0),
      backgroundColor: kSidebarBackgroundColor,
      child: Column(
        children: [
          // 1. HEADER: Nút đóng Drawer
          Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            height: context.rh(100).clamp(80.0, 120.0),
            width: double.infinity,
            color: kPrimaryColor,
            alignment: Alignment.center,
            child: IconButton(
              icon: Icon(
                Icons.close, // Thay đổi sang icon đóng để trực quan hơn
                color: kHeaderTextColor,
                size: context.icon(30),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // 2. LIST MENU ITEMS
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: context.rh(10)),
              physics: const BouncingScrollPhysics(),
              children: <Widget>[
                _buildDrawerItem(
                  context: context,
                  title: l10n.menu_homeTitle,
                  icon: Icons.home_outlined,
                  isBold: true,
                  action: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const TravelBookingScreen()),
                    );
                  },
                ),
                _buildDivider(context),

                _buildDrawerItem(
                  context: context,
                  title: l10n.menu_tourTitle,
                  icon: Icons.luggage_outlined,
                  action: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const TourScreen()),
                    );
                  },
                ),
                _buildDivider(context),

                _buildDrawerItem(
                  context: context,
                  title: l10n.menu_flightTitle,
                  icon: Icons.flight_outlined,
                  action: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const FlightScreen()),
                    );
                  },
                ),
                _buildDivider(context),

                _buildDrawerItem(
                  context: context,
                  title: l10n.menu_trainTitle,
                  icon: Icons.train_outlined,
                  controller: () {
                    context.read<TrainController>().resetToInitial();
                  },
                  action: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const TrainScreen()),
                    );
                  },
                ),
                _buildDivider(context),

                // Hiển thị Profile nếu đã đăng nhập
                if (isLoggedIn) ...[
                  _buildDrawerItem(
                    context: context,
                    title: "Thông tin tài khoản",
                    icon: Icons.person_outline,
                    action: () {
                      // Dùng push để có thể nhấn Back quay lại trang trước
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfileScreen()),
                      );
                    },
                  ),
                  _buildDivider(context),
                ],

                // Hiển thị Login nếu chưa đăng nhập
                if (!isLoggedIn) ...[
                  _buildDrawerItem(
                    context: context,
                    title: l10n.login,
                    icon: Icons.login,
                    action: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),

          // 3. FOOTER
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.only(bottom: context.rh(20)),
              child: Text(
                "Version 1.0.0",
                style: TextStyle(
                  color: kSidebarTextColor.withOpacity(0.3),
                  fontSize: context.sp(12),
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      color: kSidebarDividerColor.withOpacity(0.1),
      height: 1,
      indent: context.padding,
      endIndent: context.padding,
    );
  }
}