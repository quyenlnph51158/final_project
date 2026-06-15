import 'package:final_project/features/flight/presentation/form/seat_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../controller/flight_controller.dart';
import '../widgets/flight_screen/flight_tabs_widget.dart';
import 'flight_form.dart';
import 'package:flutter/material.dart';

class SearchForm extends StatelessWidget {
  const SearchForm({super.key});

  @override
  Widget build(BuildContext context) {
    Widget currentForm;
    // Lắng nghe sự thay đổi từ controller
    final state = context.watch<FlightController>().state;
    if (state.ui.selectedFlightTab == FlightTab.flight) {
      currentForm = FlightForm();
    } else {
      currentForm = FormCodeSeat();
    }

    return Container(
      padding: EdgeInsets.all(context.padding),
      decoration: BoxDecoration(
        color: kFormBackgroundColor,
        borderRadius: BorderRadius.circular(context.sp(16)),
        // Đồng bộ bo góc 12.0
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 5), // Đổ bóng xuống dưới
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FlightTabsWidget(),
          SizedBox(height: context.rh(16.0)),
          currentForm,
        ],
      ),
    );
  }
}
