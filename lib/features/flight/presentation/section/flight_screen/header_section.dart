import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../app/l10n/app_localizations.dart';
import '../../../../../core/constants/image_link.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/utils/responsive_layout.dart'; // Extension mới
import '../../../../../shared/header/custom_app_bar.dart';
import '../../../../tour/presentation/widgets/header/header_back_ground.dart';
import '../../controller/flight_controller.dart';
import '../../form/search_form.dart';

class FlightHeaderSection extends StatelessWidget {
  const FlightHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Lấy Tab hiện tại
    final selectedTab = context.select(
      (FlightController c) => c.state.ui.selectedFlightTab,
    );

    // 2. TÍNH TOÁN THEO PIXEL THIẾT KẾ (Base 812x375)

    // Chiều cao nền ảnh: Thiết kế khoảng 280px
    final double headerBgHeight = context.rh(280).clamp(240.0, 320.0);

    // Khoảng cách Form "ăn gian" đè lên nền: Thiết kế khoảng 40px
    final double overlapOffset = context.rh(40);

    // Chiều cao ước tính của Form (FlightForm thường cao khoảng 500-600px tùy Tab)
    final double formHeight = context.rh(600);

    // Tổng chiều cao khu vực Header để đẩy nội dung bên dưới xuống đúng chỗ
    final double totalHeaderAreaHeight =
        (headerBgHeight - overlapOffset) + formHeight;

    return SizedBox(
      width: double.infinity,
      height: totalHeaderAreaHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // A. LỚP NỀN (BACKGROUND)
          HeaderBackground(
            height: headerBgHeight,
            image: ImageLink.flightScreenBackgroundHeader,
          ),

          // B. PHẦN TRÊN CÙNG: APPBAR & TIÊU ĐỀ
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomAppBar(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.padding,
                      // Đồng bộ lề 12/16px toàn app
                      vertical: context.rh(8), // Khoảng cách dọc ổn định
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.flight_screen_header_title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: context.sp(22),
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // C. PHẦN FORM TÌM KIẾM (SEARCH FORM)
          Positioned(
            top: headerBgHeight - overlapOffset,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.padding),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(context.radius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Material(
                  color: Colors.transparent,
                  child: SearchForm(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
