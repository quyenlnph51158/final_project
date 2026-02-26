import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../app/l10n/app_localizations.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/design/flight/flight_divider.dart';
import '../../../../../core/design/flight/flight_layout_spacing.dart';
import '../../../../../core/design/flight/flight_shape.dart';
import '../../../../../core/design/flight/flight_size.dart';
import '../../../../../core/design/flight/flight_style.dart';
import '../../../../../core/utils/responsive_layout.dart';
import '../../../data/models/list_cheap_flight.dart';
import '../../controller/flight_controller.dart';

class CheapFlightCard extends StatelessWidget {
  final ListCheapFlight flight;

  const CheapFlightCard({super.key, required this.flight});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = context.read<FlightController>();

    final originCode = flight.originAirportObject.value;
    final originName = flight.originAirportObject.desc;
    final destinationCode = flight.destinationAirportObject.value;
    final destinationName = flight.destinationAirportObject.desc;

    return Card(
      color: kBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: FlightShape.borderRadiusLarge(context),
      ),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _image(context),
          _content(
            context,
            l10n,
            controller,
            originCode,
            destinationCode,
            originName,
            destinationName,
          ),
        ],
      ),
    );
  }

  /// ================= CONTENT =================
  Widget _content(
    BuildContext context,
    AppLocalizations l10n,
    FlightController controller,
    String originCode,
    String destinationCode,
    String originName,
    String destinationName,
  ) {
    return Padding(
      padding: EdgeInsets.all(FlightLayoutSpacing.cardPadding(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${l10n.flight_from}$originName ${l10n.flight_to}$destinationName',
            style: FlightStyle.cardTitle(context),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: FlightLayoutSpacing.gapSmall(context) / 2),

          _flightType(context, l10n),

          Divider(height: FlightDivider.dividerHeight),

          Text(
            l10n.flight_label_only_from,
            style: FlightStyle.labelGrey(context),
          ),

          SizedBox(height: FlightLayoutSpacing.gapSmall(context) / 2),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                flight.price.toString(),
                style: FlightStyle.priceBold(context),
              ),

              SizedBox(
                height: FlightSize.btnSmallHeight(context),
                child: ElevatedButton(
                  onPressed: () {
                    controller.departureCodeSelected(
                      originCode,
                      destinationCode,
                      originName,
                      destinationName,
                      FlightTab.flight,
                      l10n,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kBackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: FlightShape.borderRadiusSmall(context),
                    ),
                    side: const BorderSide(
                      color: kBorderColor,
                      width: FlightShape.borderThin,
                    ),
                  ),
                  child: Text(
                    l10n.general_detailButton,
                    style: FlightStyle.labelGrey(
                      context,
                    ).copyWith(color: kTextColor),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ================= IMAGE =================
  Widget _image(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(FlightShape.radiusLarge(context)),
      ),
      child: Image.network(
        flight.image,
        height: FlightSize.cheapFlightImageHeight(context),
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: FlightSize.cheapFlightImageHeight(context),
          color: Colors.grey,
          alignment: Alignment.center,
          child: const Icon(Icons.error, color: Colors.white),
        ),
      ),
    );
  }

  Widget _flightType(BuildContext context, AppLocalizations l10n) {
    return Row(
      children: [
        Icon(
          Icons.access_time,
          size: FlightSize.iconSizeSmall(context),
          color: Colors.grey,
        ),
        SizedBox(width: FlightLayoutSpacing.iconTextGap),
        Text(
          flight.type == 'OW'
              ? l10n.form_tripOneWay
              : flight.type == 'RT'
              ? l10n.form_tripRoundTrip
              : flight.type,
          style: FlightStyle.labelGrey(context),
        ),
      ],
    );
  }
}
