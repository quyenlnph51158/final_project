import 'package:flutter/material.dart';
import 'package:provider/provider.dart';// Import của bạn...
import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:final_project/core/constants/image_link.dart';
import 'package:final_project/features/flight/presentation/widgets/flight_result_card/button_continue.dart';
import 'package:final_project/features/train/presentation/form/input_passenger_form.dart';
import 'package:final_project/features/train/presentation/modals/train_filter_bottom_sheet.dart';
import 'package:final_project/features/train/presentation/section/header_train_result.dart';
import 'package:final_project/features/train/presentation/widgets/train_ticket_card.dart';
import 'package:final_project/shared/footer/app_footer.dart';
import 'package:final_project/shared/header/custom_app_bar.dart';
import '../../../../shared/header/app_drawer.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../../data/models/train_model.dart';
import '../controller/train_controller.dart';

class TrainResultScreen extends StatefulWidget {
  const TrainResultScreen({super.key});

  @override
  State<TrainResultScreen> createState() => _TrainResultScreenState();
}

class _TrainResultScreenState extends State<TrainResultScreen> {
  bool isFillingInfoPassenger = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<TrainController>();
      controller.fetchTrain();
      controller.scrollToKey(controller.departureTrainList);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TrainController>();
    final state = controller.state;
    final l10n = AppLocalizations.of(context)!;

    // 1. Tính toán dữ liệu hiển thị (Dọn dẹp logic)
    final bool isRoundTrip = state.form.isRoundTrip;
    final bool isViewingReturn = state.ui.isViewingReturnTrain;

    final String currentStation = isRoundTrip
        ? (isViewingReturn
        ? "${state.form.Destination} ${l10n.to} ${state.form.Departure}"
        : "${state.form.Departure} ${l10n.to} ${state.form.Destination}")
        : "${state.form.Departure} ${l10n.to} ${state.form.Destination}";

    final List<TrainModel> currentTrains = (isRoundTrip && isViewingReturn)
        ? (state.data.ReturnListTrain ?? [])
        : (state.data.DepartureListTrain ?? []);

    return Scaffold(
      endDrawer: const AppDrawer(),
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          controller: controller.scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            // --- PHẦN CỐ ĐỊNH ---
            const SliverToBoxAdapter(child: CustomAppBar(
              image: ImageLink.logoAppHeaderBackgroundWhite,
              backgroundColor: kPrimaryColor,
            )),
            const SliverToBoxAdapter(child: HeaderTrainResult()),

            // --- PHẦN NỘI DUNG THAY ĐỔI ---
            if (isFillingInfoPassenger)
              const SliverToBoxAdapter(child: InputPassengerForm())
            else ...[
              _buildFilterButton(context, l10n),
              ..._buildSelectedTicketsSection(context, state, l10n, controller),
              ..._buildTrainListSection(context, state, l10n, controller, currentTrains, currentStation),
              _buildContinueButtonSection(context, state, controller),
            ],

            // --- FOOTER ---
            SliverToBoxAdapter(child: SizedBox(height: context.rh(35))),
            const SliverToBoxAdapter(child: AppFooter()),
          ],
        ),
      ),
    );
  }

  // 2. Tách nút Lọc
  Widget _buildFilterButton(BuildContext context, AppLocalizations l10n) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: context.padding, vertical: context.rh(8)),
      sliver: SliverToBoxAdapter(
        child: InkWell(
          onTap: () => TrainFilterBottomSheet.show(context),
          borderRadius: BorderRadius.circular(context.radius * 2),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: context.rh(10)),
            decoration: BoxDecoration(
              color: const Color(0xFFEFEDED),
              borderRadius: BorderRadius.circular(context.radius * 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.tune_rounded, size: context.icon(18), color: kTextColor),
                SizedBox(width: context.rw(8)),
                Text(l10n.filter, style: TextStyle(fontWeight: FontWeight.bold, fontSize: context.sp(16), color: kTextColor)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 3. Tách phần vé đã chọn (Departure/Return)
  List<Widget> _buildSelectedTicketsSection(BuildContext context, dynamic state, AppLocalizations l10n, TrainController controller) {
    return [
      if (state.ui.isSelectedDepartureTrain) ...[
        _buildTitle(context, l10n.selected_trip_from_to(state.form.Departure, state.form.Destination)),
        _buildTextChangeButton(context, l10n, onTap: controller.backToSelectDepartureTrain),
        SliverToBoxAdapter(
          child: TrainTicketCard(
            key: const ValueKey('_selected_departure'),
            train: state.data.SelectedDepartureTrain!,
            seat: state.data.SelectedDepartureSeatClass,
          ),
        ),
      ],
      if (state.ui.isSelectedReturnTrain) ...[
        _buildTitle(context, l10n.selected_trip_from_to(state.form.Destination, state.form.Departure)),
        _buildTextChangeButton(context, l10n, onTap: controller.backToSelectReturnTrain),
        SliverToBoxAdapter(
          child: TrainTicketCard(
            key: const ValueKey('selected_return'),
            train: state.data.SelectedReturnTrain!,
            seat: state.data.SelectedReturnSeatClass,
          ),
        ),
      ],
    ];
  }

  // 4. Tách danh sách kết quả tìm kiếm
  List<Widget> _buildTrainListSection(BuildContext context, dynamic state, AppLocalizations l10n, TrainController controller, List<TrainModel> trains, String stationText) {
    // Điều kiện để hiển thị danh sách (Chưa chọn xong vé)
    bool shouldShowList = (state.form.isRoundTrip && (!state.ui.isSelectedDepartureTrain || !state.ui.isSelectedReturnTrain)) ||
        (!state.form.isRoundTrip && !state.ui.isSelectedDepartureTrain);

    if (!shouldShowList) return [];

    return [
      _buildTitle(
          context,
          l10n.select_trip_from(stationText),
          key: state.ui.isSelectedDepartureTrain ? controller.returnTrainList : controller.departureTrainList
      ),

      if (state.ui.isLoading)
        const SliverFillRemaining(hasScrollBody: false, child: Center(child: CircularProgressIndicator(color: kPrimaryColor)))
      else if (trains.isEmpty)
        SliverFillRemaining(hasScrollBody: false, child: Center(child: Text(l10n.no_trains_found, style: TextStyle(fontSize: context.sp(15), color: Colors.grey))))
      else
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) => TrainTicketCard(
              key: ValueKey('${trains[index].trainCode}_${state.ui.isViewingReturnTrain}'),
              train: trains[index],
            ),
            childCount: trains.length,
          ),
        ),
    ];
  }

  // 5. Tách nút Tiếp tục
  Widget _buildContinueButtonSection(BuildContext context, dynamic state, TrainController controller) {
    bool canContinue = state.form.isRoundTrip
        ? (state.ui.isSelectedDepartureTrain && state.ui.isSelectedReturnTrain)
        : state.ui.isSelectedDepartureTrain;

    if (!canContinue) return const SliverToBoxAdapter(child: SizedBox.shrink());

    return _buildStickyButton(
      context,
      key: controller.continueButton,
      child: ContinueButton(
        onPressed: () => setState(() => isFillingInfoPassenger = true),
      ),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildTitle(BuildContext context, String content, {Key? key}) {
    return SliverToBoxAdapter(
      key: key,
      child: Padding(
        padding: EdgeInsets.fromLTRB(context.padding, context.rh(20), context.padding, context.rh(8)),
        child: Text(content, style: TextStyle(fontSize: context.sp(18), fontWeight: FontWeight.bold, color: const Color(0xFF1D2939))),
      ),
    );
  }

  Widget _buildTextChangeButton(BuildContext context, AppLocalizations l10n, {required VoidCallback onTap}) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.padding, vertical: context.rh(4)),
        child: Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: EdgeInsets.all(context.rw(4)),
              child: Text(
                l10n.text_change_btn,
                style: TextStyle(color: kPrimaryColor, fontSize: context.sp(14), fontWeight: FontWeight.w600, decoration: TextDecoration.underline),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStickyButton(BuildContext context, {required Widget child, Key? key}) {
    return SliverToBoxAdapter(
      key: key,
      child: Container(
        padding: EdgeInsets.all(context.padding),
        decoration: const BoxDecoration(color: kBackgroundColor),
        child: child,
      ),
    );
  }
}