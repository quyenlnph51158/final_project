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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

    List<TrainModel> currentTrains;
    String currentStation;

    if (state.form.isRoundTrip) {
      currentStation = state.ui.isViewingReturnTrain
          ? " ${state.form.Destination} ${l10n.to} ${state.form.Departure}"
          : " ${state.form.Departure} ${l10n.to} ${state.form.Destination}";
      currentTrains = state.ui.isViewingReturnTrain
          ? state.data.ReturnListTrain ?? []
          : state.data.DepartureListTrain ?? [];
    } else {
      currentStation =
          "${state.form.Departure} ${l10n.to} ${state.form.Destination}";
      currentTrains = state.data.DepartureListTrain ?? [];
    }

    return Scaffold(
      endDrawer: const AppDrawer(),
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          controller: controller.scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 1. APP BAR
            const SliverToBoxAdapter(
              child: CustomAppBar(
                image: ImageLink.logoAppHeaderBackgroundWhite,
                backgroundColor: kPrimaryColor,
              ),
            ),

            // 2. HEADER TÌM KIẾM
            const SliverToBoxAdapter(child: HeaderTrainResult()),

            if (isFillingInfoPassenger) ...[
              const SliverToBoxAdapter(child: InputPassengerForm()),
            ] else ...[
              // 3. NÚT LỌC (Sử dụng rh và rw thay cho %)
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.padding,
                  vertical: context.rh(8), // Cố định 8px theo tỷ lệ thiết kế
                ),
                sliver: SliverToBoxAdapter(
                  child: InkWell(
                    onTap: () => TrainFilterBottomSheet.show(context),
                    borderRadius: BorderRadius.circular(context.radius * 2),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: context.rh(10)),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFEDED),
                        borderRadius: BorderRadius.circular(context.radius * 2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.tune_rounded,
                            size: context.icon(18),
                            color: kTextColor,
                          ),
                          SizedBox(width: context.rw(8)),
                          Text(
                            l10n.filter,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: context.sp(16),
                              color: kTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // 4. CHUYẾN ĐI ĐÃ CHỌN
              if (state.ui.isSelectedDepartureTrain) ...[
                _buildTitle(
                  context,
                  l10n.selected_trip_from_to(
                    state.form.Departure,
                    state.form.Destination,
                  ),
                ),
                _buildTextChangeButton(
                  context,
                  l10n,
                  onTap: controller.backToSelectDepartureTrain,
                ),
                SliverToBoxAdapter(
                  child: TrainTicketCard(
                    key: const ValueKey('_selected_departure'),
                    train: state.data.SelectedDepartureTrain!,
                    seat: state.data.SelectedDepartureSeatClass,
                  ),
                ),
              ],

              if (state.ui.isSelectedReturnTrain) ...[
                _buildTitle(
                  context,
                  l10n.selected_trip_from_to(
                    state.form.Destination,
                    state.form.Departure,
                  ),
                ),
                _buildTextChangeButton(
                  context,
                  l10n,
                  onTap: controller.backToSelectReturnTrain,
                ),
                SliverToBoxAdapter(
                  child: TrainTicketCard(
                    key: const ValueKey('selected_return'),
                    train: state.data.SelectedReturnTrain!,
                    seat: state.data.SelectedReturnSeatClass,
                  ),
                ),
              ],

              // 5. DANH SÁCH KẾT QUẢ
              if ((state.form.isRoundTrip &&
                      (!state.ui.isSelectedDepartureTrain ||
                          !state.ui.isSelectedReturnTrain)) ||
                  (!state.form.isRoundTrip &&
                      !state.ui.isSelectedDepartureTrain)) ...[
                if (!state.ui.isSelectedDepartureTrain)
                  _buildTitle(
                    context,
                    l10n.select_trip_from(currentStation),
                    key: controller.departureTrainList,
                  ),
                if (state.form.isRoundTrip &&
                    state.ui.isSelectedDepartureTrain &&
                    !state.ui.isSelectedReturnTrain)
                  _buildTitle(
                    context,
                    l10n.select_trip_from(currentStation),
                    key: controller.returnTrainList,
                  ),

                if (state.ui.isLoading)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: CircularProgressIndicator(color: kPrimaryColor),
                    ),
                  )
                else if (currentTrains.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        l10n.no_trains_found,
                        style: TextStyle(
                          fontSize: context.sp(15),
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return TrainTicketCard(
                        key: ValueKey(
                          '${currentTrains[index].trainCode}_${state.ui.isViewingReturnTrain}',
                        ),
                        train: currentTrains[index],
                      );
                    }, childCount: currentTrains.length),
                  ),
              ],

              // 6. NÚT TIẾP TỤC
              if (state.form.isRoundTrip) ...[
                if (state.ui.isSelectedDepartureTrain &&
                    state.ui.isSelectedReturnTrain)
                  _buildStickyButton(
                    key: controller.continueButton,
                    context,
                    child: ContinueButton(
                      onPressed: () =>
                          setState(() => isFillingInfoPassenger = true),

                    ),
                  ),
              ] else ...[
                if (state.ui.isSelectedDepartureTrain)
                  _buildStickyButton(
                    key: controller.continueButton,
                    context,
                    child: ContinueButton(
                      onPressed: () =>
                          setState(() => isFillingInfoPassenger = true),
                    ),
                  ),
              ],
            ],
            SliverToBoxAdapter(child: SizedBox(height: context.rh(35))),
            const SliverToBoxAdapter(child: AppFooter()),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER (Đã tối ưu pixel-scale) ---

  Widget _buildTitle(BuildContext context, String content, {Key? key}) {
    return SliverToBoxAdapter(
      key: key,
      child: Padding(
        padding: EdgeInsets.only(
          left: context.padding,
          right: context.padding,
          top: context.rh(20),
          bottom: context.rh(8),
        ),
        child: Text(
          content,
          style: TextStyle(
            fontSize: context.sp(18),
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1D2939),
          ),
        ),
      ),
    );
  }

  Widget _buildTextChangeButton(
    BuildContext context,
    AppLocalizations l10n, {
    required VoidCallback onTap,
  }) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.padding,
          vertical: context.rh(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: EdgeInsets.all(context.rw(4)),
                child: Text(
                  l10n.text_change_btn,
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: context.sp(14),
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStickyButton(BuildContext context, {required Widget child, Key? key}) {
    return SliverToBoxAdapter(
      child: Container(
        key: key,
        padding: EdgeInsets.all(context.padding),
        decoration: const BoxDecoration(color: kBackgroundColor),
        child: child,
      ),
    );
  }
}
