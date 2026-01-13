import 'package:flutter/material.dart';
import 'package:final_project/features/train/presentation/Screens/train_results_screen.dart';
import 'package:final_project/features/tour/presentation/screens/travel_booking_screen.dart';
import 'package:final_project/features/tour/presentation/screens/tour_screen.dart';
import 'package:final_project/features/flight/presentation/screens/flight_screen.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:final_project/app/l10n/app_localizations.dart';

// Định nghĩa kiểu hàm callback để truyền hành động cuộn và đổi tab
typedef TabSelectedCallback = void Function(TravelTab tab);
typedef TabSelectedFlightCallback=void Function(FlightTab tab);


class AppDrawer extends StatelessWidget {
  // Callback để truyền hành động chọn tab ra bên ngoài
  final TabSelectedCallback onTabSelected;
  // Callback cho Trang Chủ (thường là cuộn lên đầu)
  final VoidCallback onHomeSelected;
  final TabSelectedFlightCallback onTabFlightSelected;
  // XÓA TỪ KHÓA const ở đây
  const AppDrawer({
    super.key,
    required this.onTabSelected,
    required this.onHomeSelected,
    required this.onTabFlightSelected,
  });

  // Hàm tạo các mục trong Drawer
  Widget _buildDrawerItem(String title, IconData icon, VoidCallback action,
      {bool isBold = false}) {
    return ListTile(
      leading: Icon(icon, color: kSidebarTextColor),
      title: Text(
        title,
        style: TextStyle(
          color: kSidebarTextColor,
          fontSize: isBold ? 18 : 16,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios,
          size: 14, color: kSidebarTextColor),
      onTap: () {
        action(); // Thực thi hành động: setState và cuộn
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.7,
      backgroundColor: kSidebarBackgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Header: Nút đóng Drawer (mũi tên lên)
          Container(
            height: 120,
            color: kPrimaryColor,
            child: Align(
              alignment: Alignment.center,
              child: IconButton(
                icon: const Icon(Icons.keyboard_arrow_up,
                    color: kHeaderTextColor, size: 50),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // Mục Trang chủ (In đậm)
          _buildDrawerItem(
            l10n.menu_homeTitle,
            Icons.home_outlined,
                () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const TravelBookingScreen(), // Thay BlogScreen() bằng Screen mong muốn
                ),
              );
            },

            isBold: true,

          ),
          Divider(color: kSidebarDividerColor.withOpacity(0.5), height: 1),

          // Mục VÉ MÁY BAY
          _buildDrawerItem(
            l10n.menu_flightTitle,
            Icons.flight_outlined,
                () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const FlightScreen(), // Thay BlogScreen() bằng Screen mong muốn
                ),
              );
            },
          ),
          Divider(color: kSidebarDividerColor.withOpacity(0.5), height: 1),

          // Mục TOUR DU LỊCH
          _buildDrawerItem(
            l10n.menu_tourTitle,
            Icons.luggage_outlined,
                () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const TourScreen(), // Thay BlogScreen() bằng Screen mong muốn
                ),
              );
            },
          ),
          Divider(color: kSidebarDividerColor.withOpacity(0.5), height: 1),

          // Mục VÉ TÀU
          _buildDrawerItem(
            l10n.menu_trainTitle,
            Icons.directions_boat_outlined,
                () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const TrainResultScreen(), // Thay BlogScreen() bằng Screen mong muốn
                ),
              );
            },
          ),
          Divider(color: kSidebarDividerColor.withOpacity(0.5), height: 1),

          // Mục BLOG
          _buildDrawerItem(
            l10n.menu_blogTitle,
            Icons.article_outlined,
                () {
              Navigator.pop(context);
            },
          ),
          Divider(color: kSidebarDividerColor.withOpacity(0.5), height: 1),

          // Mục ĐẶT NGAY (Nút nổi bật)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Chuyển đến trang Đặt ngay...')),
                );
              },
              icon: const Icon(Icons.arrow_forward, color: Colors.white),
              label: Text(l10n.menu_bookNowButton,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}