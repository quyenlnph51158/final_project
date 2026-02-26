import 'package:final_project/core/design/tour/app_layout_spacing.dart';
import 'package:final_project/core/design/tour/app_sizes.dart';
import 'package:final_project/core/design/tour/app_styles.dart';
import 'package:final_project/features/tour/presentation/sections/faqs_section.dart';
import 'package:flutter/material.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:final_project/shared/widgets/custom_app_bar.dart';
import 'package:final_project/shared/widgets/app_footer.dart';
import 'package:final_project/shared/widgets/app_drawer.dart';
import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/image_link.dart';
import '../booking/forms/consultation_form_screen.dart';
import '../controller/travel_booking_controller.dart';
import '../sections/highlight_section.dart';
import '../sections/image_carousel_section.dart';
import '../sections/related_tour_section.dart';
import '../sections/review_section.dart';
import '../sections/schedule_section.dart';

class TourDetailScreen extends StatefulWidget{
  final String name;
  final String location;
  final String date;
  const TourDetailScreen({
    super.key,
    required this.name,
    required this.location,
    required this.date
  });
  @override
  State<TourDetailScreen> createState() => _TourDetailScreen();
}
class _TourDetailScreen extends State<TourDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _tabScrollController = ScrollController();

  final GlobalKey _introKey = GlobalKey();
  final GlobalKey _scheduleKey = GlobalKey();
  final GlobalKey _reviewKey = GlobalKey();
  final GlobalKey _faqKey = GlobalKey();
  final List<GlobalKey> _tabKeys =
  List.generate(4, (_) => GlobalKey());
  late final List<GlobalKey> _sectionKeys = [
    _introKey,
    _scheduleKey,
    _reviewKey,
    _faqKey,
  ];


  int _currentTab = 0;
  @override
  void initState(){
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final l10n = AppLocalizations.of(context)!;
      context.read<TravelBookingController>().fetchTourDetail(widget.name,l10n.error_dataLoadingFailed);
      context.read<TravelBookingController>().initData(l10n.form_defaultDeparture, l10n.form_defaultDestination);
    });
    _sectionKeys;
  }
  @override
  Widget build(BuildContext context){
    final controller = context.read<TravelBookingController>();
    final state = context.watch<TravelBookingController>().state;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      endDrawer: AppDrawer(
        onTabSelected: controller.updateTab,
        onHomeSelected: controller.resetSearch,
        onTabFlightSelected: (_) =>
            controller.updateTab(TravelTab.flight),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              child: Stack(
                children: [
                  SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomAppBar(image: ImageLink.logoAppHeaderBackgroundWhite,backgroundColor: kPrimaryColor,),
                        AppLayoutSpacing.customAppBarAndTourName,
                        Padding(
                          padding: AppLayoutSpacing.paddingTourDetailName,
                          child: Text(
                            widget.name,
                            style: AppStyles.tourNameInTourDetail,
                          ),
                        ),
                        AppLayoutSpacing.headerNamePosition,
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ImageCarousel(images: state.tour.tourDetail.images,),
            _buildTabs(),
            Padding(
              key: _introKey,
              padding: AppLayoutSpacing.paddingBriefTourDetail,
              child: HtmlWidget(
                state.tour.tourDetail.brief.toString(),
                textStyle: AppStyles.briefTourDetail,
                onTapUrl: (url) async {
                  return true;
                },
              ),
            ),
            AppLayoutSpacing.section,
            HighlightSection(detail:  state.tour.tourDetail),
            AppLayoutSpacing.section,
            ScheduleSection(key: _scheduleKey ,detail: state.tour.tourDetail),
            AppLayoutSpacing.section,
            Padding(
              padding: AppLayoutSpacing.paddingConsultationSection,
              child: Card(
                color: kFormFieldBackground,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: AppLayoutSpacing.paddingConsultationForm,
                  child: ConsultationFormScreen(tourSid: state.tour.tourDetail.sid,location: widget.location, date: widget.date),
                ),
              ),
            ),
            AppLayoutSpacing.section,
            ReviewSection(key: _reviewKey,detail: state.tour.tourDetail),
            AppLayoutSpacing.section,
            FaqSection(key: _faqKey, faqs: state.tour.tourDetail.faqs,),
            AppLayoutSpacing.section,
            RelatedTourSection(tourDetail: state.tour.tourDetail,),
            AppLayoutSpacing.footer,
            AppFooter(),
          ],
        ),
      ),
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
      // Tăng nhẹ chiều cao nếu cần để chứa cả text và scrollbar
      height: AppSizes.tabSection,
      color: Colors.white,
      child: RawScrollbar( // Sử dụng RawScrollbar để tùy biến sâu hơn
        controller: _tabScrollController,
        thumbVisibility: true,
        trackVisibility: true,
        thickness: 3,
        radius: const Radius.circular(8),
        thumbColor: kPrimaryColor.withOpacity(0.5),
        // Di chuyển thanh scroll xuống sát mép dưới cùng, không đè lên nội dung
        padding: const EdgeInsets.only(bottom: 2),
        child: SingleChildScrollView(
          controller: _tabScrollController,
          scrollDirection: Axis.horizontal,
          // Quan trọng: Padding bottom ở đây tạo khoảng trống cho thanh scroll
          padding: AppLayoutSpacing.paddingTabSection.copyWith(bottom: 10),
          child: Row(
            children: List.generate(tabs.length, (index) {
              final isActive = _currentTab == index;
              return GestureDetector(
                onTap: () => _scrollToSection(index),
                child: Padding(
                  key: _tabKeys[index],
                  padding: AppLayoutSpacing.paddingTabItem,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        tabs[index],
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isActive ? kPrimaryColor : kTextColor,
                        ),
                      ),
                      const SizedBox(height: 4), // Khoảng cách giữa chữ và underline
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        height: AppSizes.heightUnderline,
                        width: isActive ? 30 : 0,
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
    final position = box.localToGlobal(
      Offset.zero,
      ancestor: context.findRenderObject(),
    );

    _scrollController.animateTo(
      _scrollController.offset + position.dy - AppSizes.tabSection,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );

    setState(() => _currentTab = index);

    // 👇 CANH TAB NGANG CHÍNH XÁC THEO TEXT
    _scrollTabToCenter(index);
  }

  void _scrollTabToCenter(int index) {
    final keyContext = _tabKeys[index].currentContext;
    if (keyContext == null) return;

    final box = keyContext.findRenderObject() as RenderBox;
    final position = box.localToGlobal(Offset.zero);
    final size = box.size;

    final screenWidth = MediaQuery.of(context).size.width;

    final offset = _tabScrollController.offset +
        position.dx -
        (screenWidth / 2 - size.width / 2);

    _tabScrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final scrollOffset = _scrollController.offset;
    int newIndex = _currentTab;

    // Xác định section đang hiển thị
    for (int i = 0; i < _sectionKeys.length; i++) {
      final context = _sectionKeys[i].currentContext;
      if (context == null) continue;

      final box = context.findRenderObject() as RenderBox;
      final position = box.localToGlobal(
          Offset.zero,
          ancestor: this.context.findRenderObject()
      );

      // Thêm khoảng đệm (offset) để việc chuyển tab nhạy hơn
      final sectionTop = scrollOffset + position.dy - AppSizes.tabSection - 20;

      if (scrollOffset >= sectionTop) {
        newIndex = i;
      }
    }

    // QUAN TRỌNG: Chỉ setState khi tab thực sự thay đổi
    if (newIndex != _currentTab) {
      setState(() {
        _currentTab = newIndex;
      });
      _scrollTabToCenter(newIndex);
    }
  }


}

