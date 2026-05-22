import 'package:final_project/core/design/tour/tour_shape.dart';
import 'package:final_project/core/design/tour/tour_styles.dart';
import 'package:final_project/features/tour/presentation/controller/travel_booking_controller.dart';
import 'package:flutter/material.dart';
import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constants/image_link.dart';
import '../../../../../core/design/shared/app_layout_spacing.dart';
import '../../../../../core/design/tour/tour_layout_spacing.dart';
import '../../widgets/about_us_item.dart';

class AboutUsSection extends StatelessWidget{
  const AboutUsSection({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller=context.watch<TravelBookingController>();
    return Padding(
      padding: TourLayoutSpacing.aboutUsSection(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            l10n.home_aboutUsVibes,
            style: AppStyles.aboutUsVibe(context),
          ),
          Text(
            '${l10n.home_aboutUsTitleLine1}\n${l10n.home_aboutUsTitleLine2}',
            textAlign: TextAlign.center,
            style: AppStyles.aboutUsTitle(context),
          ),
          SizedBox(height: TourLayoutSpacing.labelandcontent(context)),
          Padding(
            padding: TourLayoutSpacing.aboutUsDescription(context),
            child: Text(
              l10n.home_aboutUsDescription,
              textAlign: TextAlign.center,
              style: AppStyles.aboutUsdescription(context),
            ),
          ),
          SizedBox(height: TourLayoutSpacing.itemAndButtonAboutUs(context)),
          AboutUsItem(
            icon: Icons.map_outlined,
            title: l10n.home_aboutUsGuideTitle,
            subtitle: l10n.home_aboutUsGuideSubtitle,
          ),
          SharedAppLayoutSpacing.item,
          AboutUsItem(
            icon: Icons.track_changes_outlined,
            title:  l10n.home_aboutUsMissionTitle,
            subtitle:  l10n.home_aboutUsMissionSubtitle,
          ),
          SizedBox(height: TourLayoutSpacing.itemAndButtonAboutUs(context)),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                controller.scrollToTop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                padding: TourLayoutSpacing.labelButtonAboutUs(context),
                shape: AppShape.aboutUsButton,
              ),
              child: Text(
                l10n.home_exploreButton,
                style: AppStyles.labelButtonAboutUs(context),
              ),
            ),
          ),
          SizedBox(height: TourLayoutSpacing.buttonAboutUsAndCoFounder(context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                    ImageLink.avatarCoFounder),
              ),
              SizedBox(height: TourLayoutSpacing.imageAndIformation(context)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.general_coFounderName,
                      style: AppStyles.nameCoFounder),
                  Text(l10n.general_coFounderRole, style: AppStyles.coFounderRole),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}