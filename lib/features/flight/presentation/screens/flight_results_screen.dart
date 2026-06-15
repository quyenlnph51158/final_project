import 'package:final_project/features/flight/presentation/screens/select_flight_ticket_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/l10n/app_localizations.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/image_link.dart';
// Controller & State
import 'package:final_project/features/flight/presentation/controller/flight_controller.dart';
// Sections & Widgets
import 'package:final_project/features/flight/presentation/section/flight_result_screen/flight_info_result.dart';
import 'package:final_project/shared/footer/app_footer.dart';
import 'package:final_project/shared/header/app_drawer.dart';
import 'package:final_project/shared/header/custom_app_bar.dart';
import '../form/passenger_info_form.dart';
import 'flight_booking_summary_screen.dart';
import 'flight_screen.dart';

class FlightResultsScreen extends StatefulWidget {
  const FlightResultsScreen({super.key});

  @override
  State<FlightResultsScreen> createState() => _FlightResultsScreenState();
}

class _FlightResultsScreenState extends State<FlightResultsScreen> {
  int currentStep = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Gọi fetchFlights ngay khi vào màn hình
      context.read<FlightController>().fetchFlights(AppLocalizations.of(context)!);
    });
  }


  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FlightController>();



    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (currentStep == 2) {
          setState(() => currentStep = 1); // Từ Tóm tắt về Nhập thông tin
          return;
        }
        if (currentStep == 1) {
          setState(() => currentStep = 0); // Từ Nhập thông tin về Chọn vé
          return;
        }
        // Nếu đang ở bước chọn vé -> Reset controller và về màn hình tìm kiếm chính
        controller.backToSearch();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const FlightScreen()),
              (route) => false,
        );
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        endDrawer: AppDrawer(),
        body: SafeArea(
          child: CustomScrollView(
            controller: controller.scrollController,
            slivers: [
              // 1. APP BAR
              SliverToBoxAdapter(
                child: CustomAppBar(
                  image: ImageLink.logoAppHeaderBackgroundWhite,
                  backgroundColor: kPrimaryColor,
                ),
              ),

              // 2. TÓM TẮT TIÊU CHÍ TÌM KIẾM (Header đen HAN-SGN)
              const SliverToBoxAdapter(child: FlightInfoResult()),

              SliverToBoxAdapter(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildCurrentStep(controller),
                ),
              ),

              // 8. FOOTER
              const SliverToBoxAdapter(child: AppFooter()),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildCurrentStep(FlightController controller) {
    switch (currentStep) {
      case 0:
        return FlightStepSelector(
          key: const ValueKey(0),
          onContinue: () {
            setState(() => currentStep = 1);
            controller.scrollToTop();
          },
        );
      case 1:
        return PassengerInfoForm(
          key: const ValueKey(1),
          onSuccess: () {
            // Callback này được gọi sau khi API tạo booking thành công
            setState(() => currentStep = 2);
            controller.scrollToTop();
          },
        );
      case 2:
        return const FlightBookingSummaryScreen(
          key: ValueKey(2),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}