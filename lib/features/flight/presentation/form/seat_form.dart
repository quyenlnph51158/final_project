import 'package:final_project/features/flight/presentation/controller/flight_controller.dart';
import 'package:final_project/features/flight/presentation/widgets/search_flight_button.dart';
import 'package:flutter/material.dart';
import '../../../../../../../app/l10n/app_localizations.dart';
import '../inputs/code_seat_input.dart';
import 'package:provider/provider.dart';

class FormCodeSeat extends StatelessWidget {
  const FormCodeSeat({super.key,});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _codeSeatController= TextEditingController(text: 'Mã đặt chỗ');
    final TextEditingController _emailController=TextEditingController(text: 'Email');
    final l10n = AppLocalizations.of(context)!;
    final controller= context.read<FlightController>();
    final state=context.watch<FlightController>();
    return Column(
      children: [
        const SizedBox(height: 20),
        CodeSeatInput(
          label: l10n.flight_enterYourSeatCode,
          hint: l10n.flight_seatCode,
          controller: _codeSeatController,
        ),
        const SizedBox(height: 20),
        CodeSeatInput(
          label: l10n.flight_enterYourEmail,
          hint: l10n.footer_emailTitle,
          controller: _emailController,
        ),
        const SizedBox(height: 32),
        SearchFlightButton(
          text: l10n.form_searchFlightButton,
        ),
      ],
    );
  }
}
