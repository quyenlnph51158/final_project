import 'package:final_project/features/tour/presentation/controller/travel_booking_controller.dart';
import 'package:flutter/material.dart';
import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constants/image_link.dart';
import '../../../../../core/utils/responsive_layout.dart';
import '../../widgets/about_us_item.dart';

class AboutUsSection extends StatelessWidget {
  const AboutUsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = context.watch<TravelBookingController>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(l10n.home_aboutUsVibes, style: GoogleFonts.bonheurRoyale(fontSize: context.sp(40), color: kPrimaryColor)),
          Text(
            '${l10n.home_aboutUsTitleLine1}\n${l10n.home_aboutUsTitleLine2}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: context.sp(28),
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              height: 1.2,
            ),
          ),
          SizedBox(height: context.rh(16)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.rw(8)),
            child: Text(
              l10n.home_aboutUsDescription,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: context.sp(14), color: Colors.grey),
            ),
          ),
          SizedBox(height: context.rh(32)),
          AboutUsItem(
            icon: Icons.map_outlined,
            title: l10n.home_aboutUsGuideTitle,
            subtitle: l10n.home_aboutUsGuideSubtitle,
          ),
          SizedBox(height: context.rh(12)),
          AboutUsItem(
            icon: Icons.track_changes_outlined,
            title: l10n.home_aboutUsMissionTitle,
            subtitle: l10n.home_aboutUsMissionSubtitle,
          ),
          SizedBox(height: context.rh(32)),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                controller.scrollToTop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                padding: EdgeInsets.symmetric(vertical: context.rh(16)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                l10n.home_exploreButton,
                style: TextStyle(color: Colors.white, fontSize: context.sp(18)),
              ),
            ),
          ),
          SizedBox(height: context.rh(16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(ImageLink.avatarCoFounder),
              ),
              SizedBox(height: context.rh(8)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.general_coFounderName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    l10n.general_coFounderRole,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
