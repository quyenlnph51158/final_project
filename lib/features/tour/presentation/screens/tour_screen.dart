import 'package:final_project/core/data/model/home_tour_model.dart';
import 'package:final_project/core/design/shared/app_layout_spacing.dart';
import 'package:final_project/core/design/tour/tour_shape.dart';
import 'package:final_project/features/tour/presentation/sections/tour_screen/list_tour_section.dart';
import 'package:flutter/material.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:final_project/shared/footer/app_footer.dart';
import 'package:final_project/shared/header/app_drawer.dart';
import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../booking/forms/tour_search_form.dart';
import '../controller/travel_booking_controller.dart';
import '../widgets/header/booking_header.dart';
import '../widgets/header/header_back_ground.dart';

class TourScreen extends StatefulWidget {
  final HomeTourData? homeData;
  const TourScreen({
    super.key,
    this.homeData
  });
  @override
  State<TourScreen> createState() => _TourScreen();
}
class _TourScreen extends State<TourScreen> {
  final GlobalKey _resultKey = GlobalKey();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      final controller = context.read<TravelBookingController>();
      controller.resetToInitial();

      // 1. Khởi tạo data cơ bản

      controller.initData(l10n!.form_defaultDeparture, l10n.form_defaultDestination);

      // 2. QUAN TRỌNG: Đảm bảo initialList đã được load từ Server/Local
      // Nếu controller chưa load list, hãy gọi hàm fetch list ở đây và await nó
      // await controller.fetchTours();

      if (widget.homeData != null) {
        controller.updateTourForm(widget.homeData);

        // Đợi một nhịp để State ổn định
        await Future.delayed(const Duration(milliseconds: 300));

        // Thực hiện search
        controller.performTourSearch(l10n.form_defaultDestination);

        // Cuộn tới kết quả
        _scrollToResults();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TravelBookingController>();
    final l10n = AppLocalizations.of(context)!;

    // --- TÍNH TOÁN THÔNG SỐ THẬT QUA EXTENSION ---
    // Chiều cao header linh hoạt: Máy nhỏ 200, Máy thường 25% height, Tablet tối đa 300
    final double headerHeight = context.hp(35);

    // Padding ngang cho Form: Tablet thì rộng hơn cho thoáng
    final double horizontalPadding = context.isTablet ? context.width * 0.1 : 16.0;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result){
          if(didPop) return;
      },
      child:Scaffold(
        backgroundColor: kBackgroundColor,
        endDrawer: AppDrawer(
          onTabSelected: controller.updateTab,
          onHomeSelected: controller.resetSearch,
          onTabFlightSelected: (_) => controller.updateTab(TravelTab.flight),
        ),
        body: SingleChildScrollView(
          controller: controller.scrollController,
          child: Column(
            children: [
              // ================= HEADER & FORM (TỰ CO GIÃN) =================
              IntrinsicHeight( // Tự động nở chiều cao theo nội dung con
                child: Stack(
                  children: [
                    HeaderBackground(height: headerHeight),
                    const BookingHeader(),
                    Padding(
                      padding: EdgeInsets.only(
                        top: headerHeight - 20, // Đè nhẹ lên header
                        left: horizontalPadding,
                        right: horizontalPadding,
                        bottom: 20, // Tạo khoảng cách cho phần dưới
                      ),
                      child: Container(
                        padding: SharedAppLayoutSpacing.paddingForm,
                        decoration: AppShape.boxForm,
                        child: TourSearchForm(
                          onSearch: () {
                            controller.performTourSearch(l10n.form_defaultDestination);
                            _scrollToResults();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ================= DANH SÁCH TOUR (GRID TỰ ĐỘNG) =================
              // Giới hạn độ rộng tối đa trên Tablet để không bị tràn lan
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: context.isTablet ? 1100 : double.infinity,
                  ),
                  child: Column(
                    children: [
                      SharedAppLayoutSpacing.section,
                      ListTourSection(key: _resultKey),
                      SharedAppLayoutSpacing.footer,
                      const AppFooter(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  void _scrollToResults() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _resultKey.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }
}