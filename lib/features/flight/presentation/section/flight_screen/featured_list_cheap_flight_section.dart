import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../../../app/l10n/app_localizations.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/utils/responsive_layout.dart';
import '../../../data/models/cheap_flight.dart';
import '../../controller/flight_controller.dart';
import 'package:flutter/material.dart';

class FeaturedListCheapFlightSection extends StatelessWidget {
  const FeaturedListCheapFlightSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = context.watch<FlightController>();
    final state = controller.state;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.padding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state.ui.isLoading)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: context.rh(40.0),
                ),
                child: CircularProgressIndicator(color: kPrimaryColor),
              ),
            )
          // TRƯỜNG HỢP: LOAD XONG VÀ CÓ DATA
          else if (state.data.listCheapFlight.isNotEmpty)
            Column(
              children: state.data.listCheapFlight.map((flight) {
                return Padding(
                  padding: EdgeInsets.only(bottom: context.rh(12)), // Khoảng cách giữa các card
                  child: CheapFlightCard(flight: flight),
                );
              }).toList(),
            )
          // TRƯỜNG HỢP: LOAD XONG NHƯNG KHÔNG CÓ DATA
          else
            Center(
              child: Padding(
                padding: EdgeInsets.all(context.rh(40.0)),
                child: Text(
                  l10n.flight_noFlightsFound,
                  style: TextStyle(
                    fontSize: context.sp(24),
                    // Điều chỉnh lại 24 cho phù hợp đa số màn hình
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CheapFlightCard extends StatelessWidget {
  final CheapFlight flight;

  const CheapFlightCard({super.key, required this.flight});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = context.read<FlightController>();

    final originCode = flight.origin?.code;
    final originName = flight.origin?.desc;
    final destinationCode = flight.destination?.code;
    final destinationName = flight.destination?.desc;

    return Card(
      color: kBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.sp(16)),
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
            originCode ?? '',
            destinationCode ?? '',
            originName ?? '',
            destinationName ?? '',
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
      padding: EdgeInsets.all(context.rw(12.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${l10n.flight_from}$originName ${l10n.flight_to}$destinationName',
            style: TextStyle(fontSize: context.sp(16), fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: context.rw(8.0) / 2),

          _flightType(context, l10n),

          Divider(height: 24.0),

          Text(
            l10n.flight_label_only_from,
            style: TextStyle(color: Colors.grey, fontSize: context.sp(13)),
          ),

          SizedBox(height: context.rw(8.0) / 2),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                flight.price.toString(),
                style: TextStyle(
                  fontSize: context.sp(18),
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),

              SizedBox(
                height: context.rh(40),
                child: ElevatedButton(
                  onPressed: () {
                    // controller.departureCodeSelected(
                    //   originCode,
                    //   destinationCode,
                    //   originName,
                    //   destinationName,
                    //   FlightTab.flight,
                    //   l10n,
                    // );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kBackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(context.sp(8)),
                    ),
                    side: const BorderSide(
                      color: kBorderColor,
                      width: 1.0,
                    ),
                  ),
                  child: Text(
                    l10n.general_detailButton,
                    style: TextStyle(color: Colors.grey, fontSize: context.sp(13)).copyWith(color: kTextColor),
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
        top: Radius.circular(context.sp(12.0)),
      ),
      child: Image.network(
        flight.image ?? '',
        height: context.rh(180),
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: context.rh(180),
          color: Colors.grey,
          alignment: Alignment.center,
          child: const Icon(Icons.error, color: Colors.white),
        ),
      ),
    );
  }

  Widget _flightType(BuildContext context, AppLocalizations l10n) {
    final String type = flight.type ?? '';
    return Row(
      children: [
        Icon(
          Icons.access_time,
          size: context.icon(16),
          color: Colors.grey,
        ),
        SizedBox(width: context.rw(4.0)),
        Text(
          type == 'OW'
              ? l10n.form_tripOneWay
              : type == 'RT'
              ? l10n.form_tripRoundTrip
              : type,
          style: TextStyle(color: Colors.grey, fontSize: context.sp(13)),
        ),
      ],
    );
  }
}
