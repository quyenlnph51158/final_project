import 'package:final_project/core/design/tour/tour_layout_spacing.dart';
import 'package:final_project/core/design/shared/app_layout_spacing.dart';
import 'package:final_project/core/design/tour/tour_sizes.dart';
import 'package:final_project/core/design/tour/tour_styles.dart';
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

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final l10n = AppLocalizations.of(context)!;
      final controller = context.read<TravelBookingController>();
      controller.fetchTourDetail(widget.name, l10n.error_dataLoadingFailed);
      controller.initData(l10n.form_defaultDeparture, l10n.form_defaultDestination);
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
    final controller = context.read<TravelBookingController>();

    // Performance Optimization: Only rebuild when the tour data changes, not every scroll.
    final tourDetail = context.select((TravelBookingController c) => c.state.tour.tourDetail);

    // Responsive Logic
    final bool isDesktop = context.isDesktop;
    final double horizontalPadding = isDesktop ? context.wp(10) : 0.0;
    final double maxContentWidth = 1200.0;

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
          body: Center( // Centers the content on Wide Screens (Desktop)
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: isDesktop ? maxContentWidth : double.infinity),
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // 1. Header Section
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          color: Colors.white,
                          child: SafeArea(
                            bottom: false,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomAppBar(
                                    image: ImageLink.logoAppHeaderBackgroundWhite,
                                    backgroundColor: kPrimaryColor
                                ),
                                TourLayoutSpacing.customAppBarAndTourName,
                                Padding(
                                  padding: TourLayoutSpacing.paddingTourDetailName(context),
                                  child: Text(
                                      widget.name,
                                      style: AppStyles.tourNameInTourDetail(context)
                                  ),
                                ),
                                TourLayoutSpacing.headerNamePosition,
                              ],
                            ),
                          ),
                        ),
                        ImageCarousel(
                          images: tourDetail.images,
                          height: AppSizes.imageDescription(context),
                        ),
                      ],
                    ),
                  ),

                  // 2. Sticky Tab Bar (Floating)
                  SliverPersistentHeader(
                    pinned: false,
                    floating: true,
                    delegate: _StickyTabBarDelegate(
                      tabHeight: AppSizes.tabSection(context),
                      child: _buildTabs(),
                    ),
                  ),

                  // 3. Main Content Sections
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        children: [
                          // Intro Section
                          Padding(
                            key: _introKey,
                            padding: TourLayoutSpacing.paddingBriefTourDetail(context),
                            child: HtmlWidget(
                                tourDetail.brief.toString(),
                                textStyle: AppStyles.briefTourDetail(context)
                            ),
                          ),
                          SharedAppLayoutSpacing.section,

                          HighlightSection(detail: tourDetail),
                          SharedAppLayoutSpacing.section,

                          ScheduleSection(key: _scheduleKey, detail: tourDetail),
                          SharedAppLayoutSpacing.section,

                          // Consultation Form
                          Padding(
                            padding: TourLayoutSpacing.paddingConsultationSection(context),
                            child: ConsultationFormScreen(),
                          ),
                          SharedAppLayoutSpacing.section,

                          ReviewSection(key: _reviewKey, detail: tourDetail),
                          SharedAppLayoutSpacing.section,

                          FaqSection(key: _faqKey, faqs: tourDetail.faqs),
                          SharedAppLayoutSpacing.section,

                          RelatedTourSection(tourDetail: tourDetail),
                          SharedAppLayoutSpacing.footer,

                          const AppFooter(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }

  Widget _buildTabs() {
    final l10n = AppLocalizations.of(context)!;
    final tabs = [
      l10n.tour_detail_tab_intro,
      l10n.tour_detail_tab_schedule,
      l10n.tour_detail_tab_review,
      l10n.tour_detail_tab_question
    ];

    return Container(
      height: AppSizes.tabSection(context),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: kBorderColor, width: 0.5)),
      ),
      child: RawScrollbar(
        controller: _tabScrollController,
        thumbVisibility: true,
        trackVisibility: false,
        thickness: 3,
        radius: const Radius.circular(8),
        thumbColor: kPrimaryColor.withOpacity(0.5),
        padding: const EdgeInsets.only(bottom: 2),
        child: SingleChildScrollView(
          controller: _tabScrollController,
          scrollDirection: Axis.horizontal,
          padding: TourLayoutSpacing.paddingTabSection(context).copyWith(bottom: 10),
          child: Row(
            children: List.generate(tabs.length, (index) {
              final isActive = _currentTab == index;
              return GestureDetector(
                onTap: () => _scrollToSection(index),
                child: Padding(
                  key: _tabKeys[index],
                  padding: TourLayoutSpacing.paddingTabItem(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        tabs[index],
                        style: TextStyle(
                          fontSize: context.sp(16),
                          fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                          color: isActive ? kPrimaryColor : kTextColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        height: AppSizes.heightUnderline,
                        width: isActive ? 40 : 0,
                        color: kPrimaryColor,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  void _scrollToSection(int index) {
    final sectionContext = _sectionKeys[index].currentContext;
    if (sectionContext == null) return;

    final box = sectionContext.findRenderObject() as RenderBox;
    final position = box.localToGlobal(Offset.zero, ancestor: context.findRenderObject());

    _scrollController.animateTo(
      _scrollController.offset + position.dy - AppSizes.tabSection(context),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );

    setState(() => _currentTab = index);
    _scrollTabToCenter(index);
  }

  void _scrollTabToCenter(int index) {
    if (!_tabScrollController.hasClients) return;
    final keyContext = _tabKeys[index].currentContext;
    if (keyContext == null) return;

    final box = keyContext.findRenderObject() as RenderBox;
    final position = box.localToGlobal(Offset.zero);
    final size = box.size;
    final screenWidth = MediaQuery.of(context).size.width;

    final offset = _tabScrollController.offset + position.dx - (screenWidth / 2 - size.width / 2);

    _tabScrollController.animateTo(
      offset.clamp(0.0, _tabScrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final scrollOffset = _scrollController.offset;
    int newIndex = _currentTab;

    for (int i = 0; i < _sectionKeys.length; i++) {
      final ctx = _sectionKeys[i].currentContext;
      if (ctx == null) continue;

      final box = ctx.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero, ancestor: context.findRenderObject());

      final sectionTop = scrollOffset + position.dy - AppSizes.tabSection(context) - 50;

      if (scrollOffset >= sectionTop) {
        newIndex = i;
      }
    }

    if (newIndex != _currentTab) {
      setState(() => _currentTab = newIndex);
      _scrollTabToCenter(newIndex);
    }
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double tabHeight;

  _StickyTabBarDelegate({required this.child, required this.tabHeight});

  @override
  double get minExtent => tabHeight + 40; // Dynamic height based on AppSizes

  @override
  double get maxExtent => tabHeight + 40;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Material(
      color: Colors.white,
      elevation: overlapsContent ? 4 : 0,
      child: Column(
        children: [
          SizedBox(height: statusBarHeight),
          Expanded(child: child),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return oldDelegate.tabHeight != tabHeight || oldDelegate.child != child;
  }
}