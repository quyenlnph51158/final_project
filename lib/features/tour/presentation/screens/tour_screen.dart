import 'package:final_project/core/data/model/home_tour_model.dart';
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

  const TourScreen({super.key, this.homeData});

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
      controller.initData(
        l10n!.form_defaultDeparture,
        l10n.form_defaultDestination,
      );

      if (widget.homeData != null) {
        controller.updateTourForm(widget.homeData);
        await Future.delayed(const Duration(milliseconds: 300));
        controller.performTourSearch(l10n.form_defaultDestination);
        _scrollToResults();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TravelBookingController>();
    final l10n = AppLocalizations.of(context)!;

    // --- TÍNH TOÁN THEO PIXEL THIẾT KẾ (Base 812x375) ---
    // Chiều cao nền ảnh (Thiết kế khoảng 280px)
    final double headerBgHeight = context.rh(280).clamp(240.0, 320.0);

    // Khoảng cách Form "ăn gian" đè lên nền (Thiết kế khoảng 40px)
    final double overlapOffset = context.rh(40);

    // Chiều cao thực tế của Form (TourForm thường cao khoảng 350-400px)
    final double formHeight = context.rh(380);

    // Tổng chiều cao khu vực Header để đẩy nội dung bên dưới xuống đúng chỗ
    final double totalHeaderAreaHeight =
        (headerBgHeight - overlapOffset) + formHeight;

    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        endDrawer: const AppDrawer(),
        body: CustomScrollView(
          // Sử dụng CustomScrollView thay vì SingleChild để mượt hơn trên máy thật
          controller: controller.scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 1. PHẦN HEADER & FORM TÌM KIẾM
            SliverToBoxAdapter(
              child: SizedBox(
                height: totalHeaderAreaHeight,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Lớp nền xanh
                    HeaderBackground(height: headerBgHeight),

                    // Logo & AppBar
                    const BookingHeader(),

                    // Form tìm kiếm
                    Positioned(
                      top: headerBgHeight - overlapOffset,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.padding,
                        ),
                        child: Container(
                          padding: EdgeInsets.all(context.rw(16)),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(context.radius),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: TourSearchForm(
                            onSearch: () {
                              if (controller.state.ui.errorMessage != '') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      controller.state.ui.errorMessage!,
                                    ),
                                    backgroundColor: Colors.redAccent,
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.all(context.padding),
                                  ),
                                );
                              } else {
                                controller.performTourSearch(
                                  l10n.form_defaultDestination,
                                );
                                _scrollToResults();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2. KHOẢNG CÁCH GIỮA FORM VÀ DANH SÁCH
            SliverToBoxAdapter(child: SizedBox(height: context.rh(24))),

            // 3. DANH SÁCH TOUR
            SliverToBoxAdapter(child: ListTourSection(key: _resultKey)),

            // 4. KHOẢNG ĐỆM CUỐI VÀ FOOTER
            SliverToBoxAdapter(child: SizedBox(height: context.rh(40))),
            const SliverToBoxAdapter(child: AppFooter()),
          ],
        ),
      ),
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
