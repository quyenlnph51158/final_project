import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../app/l10n/app_localizations.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/image_link.dart';
import '../../../../../core/design/flight/flight_layout_spacing.dart';
import '../../../../../core/design/flight/flight_size.dart';
import '../../../../../core/design/shared/app_layout_spacing.dart';
import '../../../../../core/design/shared/app_style.dart';
import '../../../../../shared/header/custom_app_bar.dart';
import '../../../../tour/presentation/widgets/header/header_back_ground.dart';
import '../../controller/flight_controller.dart';
import '../../form/search_form.dart';

class FlightHeaderSection extends StatelessWidget {
  const FlightHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. SELECT only necessary UI state for performance
    final selectedTab = context.select(
      (FlightController c) => c.state.ui.selectedFlightTab,
    );

    final headerHeight = FlightSize.headerBackgroundHeight(context);

    final double horizontalPadding =
        FlightLayoutSpacing.headerHorizontalPadding;

    // 4. FORM HEIGHT CALCULATION (Fixing the Monitor Fit)
    double formHeight = FlightSize.searchFormHeight(selectedTab);
    const double topOffset = FlightSize.formTopOffset;
    // 5. TOTAL HEIGHT (Fixing the Hit-Test/Click problem)
    // We must ensure this SizedBox is big enough to cover the WHOLE form
    final double totalHeight = headerHeight + formHeight;

    return SizedBox(
      height: totalHeight,
      child: Stack(
        // IMPORTANT: Allow the children to receive touch events even if overlapping
        clipBehavior: Clip.none,
        children: [
          // BACKGROUND IMAGE
          HeaderBackground(
            height: headerHeight,
            image: ImageLink.flightScreenBackgroundHeader,
          ),

          // TOP SECTION: AppBar and Title
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomAppBar(),
                  Padding(
                    padding: SharedAppLayoutSpacing.paddingForm,
                    child: Text(
                      AppLocalizations.of(context)!.flight_screen_header_title,
                      style: SharedAppStyle.titleHeader(context),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // FORM SECTION: Positioned correctly for all viewports
          Positioned(
            // Pull the form up into the header background (Negative Offset)
            top: headerHeight - topOffset,
            left: horizontalPadding,
            right: horizontalPadding,
            // Wrap in Material to ensure touch events are handled correctly
            child: const Material(
              color: Colors.transparent,
              child: SearchForm(),
            ),
          ),
        ],
      ),
    );
  }
}
