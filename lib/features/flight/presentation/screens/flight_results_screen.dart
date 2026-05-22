import 'package:final_project/core/constants/app_icons.dart';
import 'package:final_project/core/design/flight/flight_size.dart'
    hide FlightTab;
import 'package:final_project/features/flight/presentation/modals/flight_filter_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Constants & Assets
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/image_link.dart';
import '../../../../core/design/flight/flight_layout_spacing.dart';
import '../../../../core/design/flight/flight_style.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../../../../app/l10n/app_localizations.dart';

// Controller & Models
import 'package:final_project/features/flight/presentation/controller/flight_controller.dart';

// Sections & Widgets
import 'package:final_project/features/flight/presentation/section/flight_result_screen/flight_info_result.dart';
import 'package:final_project/features/flight/presentation/section/flight_result_screen/selected_flight_ticket_section.dart';
import 'package:final_project/features/flight/presentation/section/flight_result_screen/ticket_flight_section.dart';
import 'package:final_project/shared/footer/app_footer.dart';
import 'package:final_project/shared/header/app_drawer.dart';
import 'package:final_project/shared/header/custom_app_bar.dart';
import '../form/passenger_info_form.dart';
import '../widgets/flight_result_card/button_continue.dart';
import 'flight_screen.dart';

class FlightResultsScreen extends StatefulWidget {
  const FlightResultsScreen({super.key});

  @override
  State<FlightResultsScreen> createState() => _FlightResultsScreenState();
}

class _FlightResultsScreenState extends State<FlightResultsScreen> {
  // Local UI state
  bool isFillingInfoPassenger = false;

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to trigger side effects after build
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadFlights());
  }

  void _loadFlights() {
    final l10n = AppLocalizations.of(context)!;
    final controller = context.read<FlightController>();
    final criteria = controller.state.criteria;

    controller.fetchFlights(
      l10n,
      criteria.departureCode,
      criteria.destinationCode,
      criteria.departureDate,
      criteria.returnDate,
      criteria.adultCount,
      criteria.childCount,
      criteria.infantCount,
    );
  }

  // --- LOGIC GETTERS (Keeps the build method clean) ---

  bool get _shouldShowFlightList {
    final state = context.read<FlightController>().state;
    if (isFillingInfoPassenger) return false;

    // Show list if outbound isn't selected...
    if (!state.ui.isSelectedOutboundFlight) return true;

    // ...OR if it's a round trip and return isn't selected
    if (state.criteria.roundTrip == true && !state.ui.isSelectedReturnFlight)
      return true;

    return false;
  }

  bool get _isSelectionComplete {
    final state = context.read<FlightController>().state;
    if (isFillingInfoPassenger) return false;

    final outboundReady = state.ui.isSelectedOutboundFlight;
    final returnReady = state.ui.isSelectedReturnFlight;

    if (state.criteria.roundTrip == true) {
      return outboundReady && returnReady;
    } else {
      return outboundReady;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = context.read<FlightController>();
    final state = context.watch<FlightController>().state;

    // Determine header labels based on flight direction
    final dep = state.ui.isViewingReturnFlights
        ? state.criteria.destination
        : state.criteria.departure;
    final des = state.ui.isViewingReturnFlights
        ? state.criteria.departure
        : state.criteria.destination;

    return PopScope(
      canPop: false, // không cho phép quay lại trang trước
      onPopInvokedWithResult: (didPop, result) async {
        // didPop ở đây thường là false vì ta đã chặn ở trên
        if (didPop) return;

        // 1. Thực hiện logic dọn dẹp dữ liệu trong Controller
        // Đảm bảo backToSearch() xóa sạch các lựa chọn cũ để tránh đè dữ liệu
        context.read<FlightController>().backToSearch();

        // 2. Chuyển hướng sang trang FlightScreen
        // pushAndRemoveUntil sẽ xóa toàn bộ lịch sử các trang trước đó,
        // tránh việc người dùng lại vuốt ngược từ FlightScreen ra trang kết quả cũ.
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const FlightScreen()),
          (route) => false, // Xóa sạch các route cũ trong stack
        );
      },
      child: Scaffold(
        endDrawer: AppDrawer(
          onTabSelected: (_) => controller.updateTab(FlightTab.flight),
          onHomeSelected: controller.resetSearch,
          onTabFlightSelected: controller.updateTab,
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: CustomScrollView(
            controller: controller.scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: CustomAppBar(
                  image: ImageLink.logoAppHeaderBackgroundWhite,
                  backgroundColor: kPrimaryColor,
                ),
              ),
              // 2. SEARCH SUMMARY
              const SliverToBoxAdapter(child: FlightInfoResult()),
              if (state.data.internationalFlights.isEmpty)
                if (!isFillingInfoPassenger) ...[
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: FlightSize.horizontalPadding(context),
                    ),

                    sliver: SliverToBoxAdapter(
                      // Đảm bảo đặt trong SliverToBoxAdapter nếu dùng Container trực tiếp trong CustomScrollView
                      child: InkWell(
                        // Thêm InkWell để có hiệu ứng nhấn (Ripple Effect)
                        onTap: () {
                          showFlightFilter(context);
                        },
                        borderRadius: BorderRadius.circular(30),
                        // Khớp với hình dạng của Container
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: FlightSize.verticalPadding(context),
                            horizontal: FlightSize.horizontalPadding(context),
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8E7E7),
                            // Bạn có thể thay bằng FlightColor.grey50 nếu có
                            borderRadius: BorderRadius.circular(
                              30,
                            ), // Hoặc FlightShape.borderRadiusLarge(context)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icon Lọc (Thay vì dùng Stack trống)
                              Icon(
                                Icons.tune_rounded,
                                // Hoặc dùng SvgPicture nếu có file svg
                                size: FlightSize.filterIconSize(context),
                                color: kTextColor,
                              ),
                              SizedBox(
                                width: FlightSize.elementSpacing(context),
                              ),
                              // Thay cho thuộc tính 'spacing' nếu Flutter version cũ hơn 3.24
                              Text(
                                AppLocalizations.of(context)!.filter,
                                style: FlightStyle.sectionTitleBold(context)
                                    .copyWith(
                                      fontSize: context.sp(14),
                                      color: kTextColor,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],

              // 3. SELECTED TICKETS (Outbound / Return)
              if (!isFillingInfoPassenger) ...[
                // Ưu tiên hiển thị Cặp vé quốc tế
                if (state.ui.isSelectedInternationalFlight == true)
                  SelectedFlightTicketSection(
                    intlPair: state.data.selectedInternationalFlight,
                    isOutbound: true,
                  ),

                // Nếu không có quốc tế thì hiện nội địa (Đi / Về)
                if (state.ui.isSelectedInternationalFlight == false) ...[
                  if (state.ui.isSelectedOutboundFlight)
                    SelectedFlightTicketSection(
                      flight: state.data.selectedOutboundFlight,
                      inventory: state.data.selectedOutboundInventory,
                      isOutbound: true,
                    ),
                  if (state.ui.isSelectedReturnFlight)
                    SelectedFlightTicketSection(
                      flight: state.data.selectedReturnFlight,
                      inventory: state.data.selectedReturnInventory,
                      isOutbound: false,
                    ),
                ],
              ],

              // 4. FLIGHT SELECTION LIST
              if (_shouldShowFlightList) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: FlightLayoutSpacing.resultHeaderPadding(context),
                    child: Text(
                      l10n.flight_from_to(dep, des),
                      style: FlightStyle.sectionTitleBold(context),
                    ),
                  ),
                ),
                state.ui.isLoading
                    ? const SliverFillRemaining(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: kPrimaryColor,
                          ),
                        ),
                      )
                    : TicketFlightSection(
                        isViewingReturn: state.ui.isViewingReturnFlights,
                      ),
              ],

              // 5. PASSENGER FORM
              if (isFillingInfoPassenger)
                const SliverToBoxAdapter(child: PassengerInfoForm()),

              // 6. ACTION BUTTON
              if (_isSelectionComplete)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: FlightLayoutSpacing.actionButtonPadding(context),
                    child: ContinueButton(
                      onPressed: () =>
                          setState(() => isFillingInfoPassenger = true),
                    ),
                  ),
                ),

              // 7. FOOTER
              const SliverToBoxAdapter(child: AppFooter()),
            ],
          ),
        ),
      ),
    );
  }
}
