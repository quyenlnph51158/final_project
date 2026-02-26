import 'package:final_project/features/flight/presentation/form/seat_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../../app/l10n/app_localizations.dart';
import '../../../../core/constants/colors.dart';
import '../controller/flight_controller.dart';
import '../widgets/flight_tabs_widget.dart';
import 'flight_form.dart';
import 'package:flutter/material.dart';

class SearchForm extends StatelessWidget{
  const SearchForm({super.key});
  @override
  Widget build(BuildContext context) {
    Widget currentForm;
    final l10n = AppLocalizations.of(context)!;
    // Lắng nghe sự thay đổi từ controller
    final controller = context.read<FlightController>();
    final state = context.watch<FlightController>().state;
    if(state.selectedFlightTab==FlightTab.flight){
      currentForm=FlightForm();
    }
    else{
      currentForm=FormCodeSeat();
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: kFormBackgroundColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FlightTabsWidget(),
            const SizedBox(height: 16),
            currentForm,
          ]
      ),
    );
  }
}