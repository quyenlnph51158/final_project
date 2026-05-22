import 'dart:async';
import 'package:final_project/features/auth/presentation/controller/auth_controller.dart';
import 'package:final_project/features/train/presentation/screens/train_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_project/features/tour/presentation/screens/travel_booking_screen.dart';
import 'package:final_project/features/tour/presentation/screens/tour_screen.dart';
import 'package:final_project/features/flight/presentation/screens/flight_screen.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:final_project/app/l10n/app_localizations.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../../features/auth/presentation/screen/login_screen.dart';
import '../../features/train/presentation/controller/train_controller.dart';

typedef TabSelectedCallback = void Function(TravelTab tab);
typedef TabSelectedFlightCallback = void Function(FlightTab tab);
typedef ControllerCallback = FutureOr<void> Function();

class AppDrawer extends StatelessWidget {
  final TabSelectedCallback? onTabSelected;
  final VoidCallback? onHomeSelected;
  final TabSelectedFlightCallback? onTabFlightSelected;

  const AppDrawer({
    super.key,
    this.onTabSelected,
    this.onHomeSelected,
    this.onTabFlightSelected,
  });

  Widget _buildDrawerItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback action,
    required ControllerCallback controller,
    bool isBold = false,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: context.padding,
        // Dùng rh(4) thay vì h(0.2) để cố định khoảng cách theo tỷ lệ pixel chuẩn
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
        await controller();
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
      // Dùng rw(280) để cố định chiều rộng drawer theo tỷ lệ thiết kế 375px
      width: context.rw(280).clamp(250.0, 320.0),
      backgroundColor: kSidebarBackgroundColor,
      child: Column(
        children: [
          // 1. HEADER: Nút đóng Drawer
          Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            // rh(100) giúp header có chiều cao ổn định khoảng 100px trên máy chuẩn
            height: context.rh(100).clamp(80.0, 120.0),
            width: double.infinity,
            color: kPrimaryColor,
            alignment: Alignment.center,
            child: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_right_sharp,
                color: kHeaderTextColor,
                size: context.icon(35),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // 2. LIST MENU ITEMS
          Expanded(
            child: ListView(
              // Padding dọc đồng bộ theo tỷ lệ pixel
              padding: EdgeInsets.symmetric(vertical: context.rh(10)),
              physics: const BouncingScrollPhysics(),
              children: <Widget>[
                _buildDrawerItem(
                  context: context,
                  title: l10n.menu_homeTitle,
                  icon: Icons.home_outlined,
                  action: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TravelBookingScreen(),
                      ),
                    );
                  },
                  controller: () {},
                  isBold: true,
                ),
                _buildDivider(context),

                _buildDrawerItem(
                  context: context,
                  title: l10n.menu_tourTitle,
                  icon: Icons.luggage_outlined,
                  action: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TourScreen(),
                      ),
                    );
                  },
                  controller: () {},
                ),
                _buildDivider(context),

                _buildDrawerItem(
                  context: context,
                  title: l10n.menu_flightTitle,
                  icon: Icons.flight_outlined,
                  action: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FlightScreen(),
                      ),
                    );
                  },
                  controller: () {},
                ),
                _buildDivider(context),

                _buildDrawerItem(
                  context: context,
                  title: l10n.menu_trainTitle,
                  icon: Icons.train_outlined,
                  action: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TrainScreen(),
                      ),
                    );
                  },
                  controller: () {
                    context.read<TrainController>().resetToInitial();
                  },
                ),
                _buildDivider(context),

                _buildDrawerItem(
                  context: context,
                  title: isLoggedIn ? "Đăng xuất" : l10n.login,
                  icon: isLoggedIn ? Icons.logout : Icons.login,
                  action: () {
                    Navigator.pop(context);
                    if (!isLoggedIn) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    }
                  },
                  controller: () async {
                    if (isLoggedIn) {
                      await authController.logOut();
                    }
                  },
                ),
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
