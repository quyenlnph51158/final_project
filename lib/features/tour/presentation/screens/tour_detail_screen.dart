import 'package:final_project/core/data/constants/faqs_tour_detail_data.dart';
import 'package:final_project/features/tour/presentation/booking/forms/consultation_form_screen.dart';
import 'package:final_project/features/tour/presentation/sections/tour_detail_screen/faqs_section.dart';
import 'package:flutter/material.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:final_project/shared/header/custom_app_bar.dart';
import 'package:final_project/shared/footer/app_footer.dart';
import 'package:final_project/shared/header/app_drawer.dart';
import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/image_link.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../controller/travel_booking_controller.dart';
import '../sections/tour_detail_screen/highlight_section.dart';
import '../sections/tour_detail_screen/image_carousel_section.dart';
import '../sections/tour_detail_screen/related_tour_section.dart';
import '../sections/tour_detail_screen/review_section.dart';
import '../sections/tour_detail_screen/schedule_section.dart';

class TourDetailScreen extends StatefulWidget {
  final String name;
  final String location;
  final String date;

  const TourDetailScreen({
    super.key,
    required this.name,
    required this.location,
    required this.date,
  });

  @override
  State<TourDetailScreen> createState() => _TourDetailScreenState();
}

class _TourDetailScreenState extends State<TourDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _tabScrollController = ScrollController();

  final GlobalKey _introKey = GlobalKey();
  final GlobalKey _scheduleKey = GlobalKey();
  final GlobalKey _reviewKey = GlobalKey();
  final GlobalKey _faqKey = GlobalKey();

  final List<GlobalKey> _tabKeys = List.generate(4, (_) => GlobalKey());
  late final List<GlobalKey> _sectionKeys = [
    _introKey,
    _scheduleKey,
    _reviewKey,
    _faqKey,
  ];

  int _currentTab = 0;
  bool _isAutoScrolling = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final l10n = AppLocalizations.of(context)!;
      context.read<TravelBookingController>().fetchTourDetail(
        widget.name,
        l10n.error_dataLoadingFailed,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Lấy state từ controller
    final tourState = context.watch<TravelBookingController>().state;
    final tourDetail = tourState.tour.tourDetail;
    final isLoading = tourState.ui.isLoading;

    final double topPadding = MediaQuery.of(context).padding.top;
    final double tabHeight = context.rh(50);

    // --- SỬA LỖI: Kiểm tra nếu đang tải hoặc dữ liệu chưa có ---
    if (isLoading || tourDetail == null) {
      return Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          title: Text(widget.name, style: TextStyle(fontSize: context.sp(16))),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: const Center(
          child: CircularProgressIndicator(color: kPrimaryColor),
        ),
      );
    }

    // Nếu đã có dữ liệu, mới render CustomScrollView
    return Scaffold(
      backgroundColor: kBackgroundColor,
      endDrawer: const AppDrawer(),
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. HEADER & IMAGE CAROUSEL
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.white,
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomAppBar(
                          image: ImageLink.logoAppHeaderBackgroundWhite,
                          backgroundColor: kPrimaryColor,
                        ),
                        SizedBox(height: context.rh(12)),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.padding,
                          ),
                          child: Text(
                            widget.name,
                            style: TextStyle(
                              fontSize: context.sp(22),
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1D2939),
                            ),
                          ),
                        ),
                        SizedBox(height: context.rh(12)),
                      ],
                    ),
                  ),
                ),
                ImageCarousel(
                  images: tourDetail.images ?? [], // Dùng ?? [] cho an toàn
                  height: context.rh(250).clamp(200.0, 350.0),
                ),
              ],
            ),
          ),

          // 2. STICKY TAB BAR
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyTabBarDelegate(
              tabHeight: tabHeight,
              topPadding: topPadding,
              child: _buildTabs(tabHeight),
            ),
          ),

          // 3. CONTENT SECTIONS
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Giới thiệu
                Padding(
                  key: _introKey,
                  padding: EdgeInsets.all(context.padding),
                  child: HtmlWidget(
                    tourDetail.brief ?? "",
                    textStyle: TextStyle(
                      fontSize: context.sp(14),
                      color: kTextColor,
                      height: 1.6,
                    ),
                  ),
                ),
                _buildDivider(context),
                HighlightSection(detail: tourDetail),
                _buildDivider(context),
                ScheduleSection(key: _scheduleKey, detail: tourDetail),
                _buildDivider(context),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: ConsultationFormScreen(),
                ),
                _buildDivider(context),
                ReviewSection(key: _reviewKey, detail: tourDetail),
                _buildDivider(context),
                FaqSection(
                  key: _faqKey,
                  faqs: FaqsTourDetailData.faqs(context),
                ),
                _buildDivider(context),
                RelatedTourSection(tourDetail: tourDetail),
                const AppFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) =>
      SizedBox(height: context.rh(32));

  Widget _buildTabs(double height) {
    final l10n = AppLocalizations.of(context)!;
    final tabs = [
      l10n.tour_detail_tab_intro,
      l10n.tour_detail_tab_schedule,
      l10n.tour_detail_tab_review,
      l10n.tour_detail_tab_question,
    ];

    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SingleChildScrollView(
        controller: _tabScrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: context.rw(8)),
        child: Row(
          children: List.generate(tabs.length, (index) {
            final isActive = _currentTab == index;
            return InkWell(
              onTap: () => _scrollToSection(index),
              child: Container(
                key: _tabKeys[index],
                padding: EdgeInsets.symmetric(horizontal: context.rw(12)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      tabs[index],
                      style: TextStyle(
                        fontSize: context.sp(14),
                        fontWeight: isActive
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: isActive ? kPrimaryColor : kTextColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      height: 3,
                      width: isActive ? context.rw(40) : 0,
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(context.radius),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // Logic Scroll mượt mà hơn cho máy thật
  void _scrollToSection(int index) {
    final sectionContext = _sectionKeys[index].currentContext;
    if (sectionContext == null) return;

    setState(() {
      _isAutoScrolling = true;
      _currentTab = index;
    });

    final box = sectionContext.findRenderObject() as RenderBox;
    final position = box.localToGlobal(Offset.zero, ancestor: context.findRenderObject());

    final topPadding = MediaQuery.of(context).padding.top;
    final tabHeight = context.rh(50);

    // Tính toán vị trí cần cuộn đến: Vị trí hiện tại + khoảng cách đến đích - (chiều cao Header + Padding)
    double targetOffset = _scrollController.offset + position.dy - (tabHeight + topPadding);

    // Đảm bảo không cuộn quá giới hạn của danh sách
    targetOffset = targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent);

    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    ).then((_) => _isAutoScrolling = false);

    _scrollTabToCenter(index);
  }

  void _scrollTabToCenter(int index) {
    if (!_tabScrollController.hasClients) return;
    final keyContext = _tabKeys[index].currentContext;
    if (keyContext == null) return;

    final box = keyContext.findRenderObject() as RenderBox;
    final position = box.localToGlobal(Offset.zero);
    final size = box.size;
    final screenWidth = context.screenWidth;

    final offset =
        _tabScrollController.offset +
        position.dx -
        (screenWidth / 2 - size.width / 2);

    _tabScrollController.animateTo(
      offset.clamp(0.0, _tabScrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _onScroll() {
    if (_isAutoScrolling || !_scrollController.hasClients) return;

    final topPadding = MediaQuery.of(context).padding.top;
    final tabHeight = context.rh(50);
    final threshold = tabHeight + topPadding + 10; // Ngưỡng nhận diện section

    for (int i = _sectionKeys.length - 1; i >= 0; i--) {
      final ctx = _sectionKeys[i].currentContext;
      if (ctx == null) continue;

      final box = ctx.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero, ancestor: context.findRenderObject());

      if (position.dy <= threshold) {
        if (_currentTab != i) {
          setState(() => _currentTab = i);
          _scrollTabToCenter(i);
        }
        break; // Dừng lại ở section cao nhất đang chạm đỉnh
      }
    }
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double tabHeight;
  final double topPadding;

  _StickyTabBarDelegate({required this.child, required this.tabHeight, required this.topPadding,});

  @override
  double get minExtent => tabHeight + topPadding;

  @override
  double get maxExtent => tabHeight + topPadding;


  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      color: Colors.white,
      elevation: overlapsContent ? 2 : 0,
      child: Column(
        children: [
          Container(height: topPadding, color: Colors.white),
          Expanded(child: child),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return oldDelegate.tabHeight != tabHeight ||
        oldDelegate.topPadding != topPadding ||
        oldDelegate.child != child;
  }
}
