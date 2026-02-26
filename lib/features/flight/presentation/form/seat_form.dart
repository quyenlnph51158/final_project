import 'package:final_project/features/flight/presentation/controller/flight_controller.dart';
import 'package:final_project/features/flight/presentation/widgets/flight_screen/search_flight_button.dart';
import 'package:flutter/material.dart';
import '../../../../../../../app/l10n/app_localizations.dart';
import '../../../../core/design/flight/flight_layout_spacing.dart';
import '../inputs/code_seat_input.dart';
import 'package:provider/provider.dart';

class FormCodeSeat extends StatelessWidget {
  const FormCodeSeat({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _codeSeatController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        SizedBox(height: FlightLayoutSpacing.gapInputVertical(context)),
        CodeSeatInput(
          label: l10n.flight_enterYourSeatCode,
          hint: l10n.flight_seatCode,
          controller: _codeSeatController,
          isEmail: false,
        ),
        SizedBox(height: FlightLayoutSpacing.gapInputVertical(context)),
        CodeSeatInput(
          label: l10n.flight_enterYourEmail,
          hint: l10n.footer_emailTitle,
          controller: _emailController,
          isEmail: true,
        ),
        SizedBox(height: FlightLayoutSpacing.gapActionBottom(context)),
        SearchFlightButton(text: l10n.form_searchFlightButton),
      ],
    );
  }
}
