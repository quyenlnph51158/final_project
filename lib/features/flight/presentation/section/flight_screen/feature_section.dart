import 'package:flutter/material.dart';
import '../../../../../app/l10n/app_localizations.dart';
import '../../../../../core/utils/responsive_layout.dart'; // Import extension mới
import '../../widgets/flight_screen/flight_feature_card.dart';

class FlightFeatureSection extends StatelessWidget {
  const FlightFeatureSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Danh sách các thẻ tính năng
    final List<Widget> cards = [
      FlightFeatureCard(
        icon: Icons.luggage_outlined,
        title: l10n.flight_feature_luggage_title,
        subtitle: l10n.flight_feature_luggage_sub,
      ),
      FlightFeatureCard(
        icon: Icons.flight_takeoff,
        title: l10n.flight_feature_online_checkin_title,
        subtitle: l10n.flight_feature_online_checkin_sub,
      ),
      FlightFeatureCard(
        icon: Icons.flight_rounded,
        title: l10n.flight_feature_checkin_available_title,
        subtitle: l10n.flight_feature_checkin_available_sub,
      ),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(
        // Sử dụng lề chuẩn 12/16px đã qua rw để thẳng hàng toàn app
        horizontal: context.padding,
        // Thay h(2) bằng rh(24) để khoảng cách dọc ổn định
        vertical: context.rh(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // TIÊU ĐỀ PHẦN
          Text(
            l10n.flight_screen_service_title,
            textAlign: TextAlign.center,
            style: TextStyle(
              // sp(18) có clamp giúp font không bị vỡ trên máy thật
              fontSize: context.sp(18),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1D2939),
              letterSpacing: -0.5,
            ),
          ),

          // Thay h(2) bằng rh(20) cho khoảng nghỉ sau tiêu đề
          SizedBox(height: context.rh(20)),

          // DANH SÁCH CÁC THẺ
          Column(
            children: cards.map((card) {
              return Padding(
                padding: EdgeInsets.only(
                  // Thay h(1.5) bằng rh(12) để card không bị dãn quá thưa trên máy Pro Max
                  bottom: context.rh(12),
                ),
                child: card,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
