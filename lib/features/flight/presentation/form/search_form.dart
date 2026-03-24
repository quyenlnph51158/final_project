import 'package:final_project/features/flight/presentation/form/seat_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../../app/l10n/app_localizations.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/design/flight/flight_elevation.dart';
import '../../../../core/design/flight/flight_layout_spacing.dart';
import '../../../../core/design/flight/flight_shape.dart';
import '../controller/flight_controller.dart';
import '../widgets/flight_screen/flight_tabs_widget.dart';
import 'flight_form.dart';
import 'package:flutter/material.dart';

class SearchForm extends StatelessWidget {
  const SearchForm({super.key});

  @override
  Widget build(BuildContext context) {
    Widget currentForm;
    final l10n = AppLocalizations.of(context)!;
    // Lắng nghe sự thay đổi từ controller
    final controller = context.read<FlightController>();
    final state = context.watch<FlightController>().state;
    if (state.ui.selectedFlightTab == FlightTab.flight) {
      currentForm = FlightForm();
    } else {
      currentForm = FormCodeSeat();
    }

    return Container(
      padding: EdgeInsets.all(FlightLayoutSpacing.formInnerPadding(context)),
      decoration: BoxDecoration(
        color: kFormBackgroundColor,
        borderRadius: FlightShape.borderRadiusLarge(context),
        // Đồng bộ bo góc 12.0
        boxShadow: FlightElevation.formShadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FlightTabsWidget(),
          SizedBox(height: FlightLayoutSpacing.gapTabToForm(context)),
          currentForm,
        ],
      ),
    );
  }
}
