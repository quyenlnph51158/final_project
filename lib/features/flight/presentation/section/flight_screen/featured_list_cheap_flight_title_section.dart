import 'package:flutter/material.dart';
import '../../../../../app/l10n/app_localizations.dart';
import '../../../../../core/utils/responsive_layout.dart'; // Import extension mới

class FeaturedListCheapFlightTitleSection extends StatelessWidget {
  const FeaturedListCheapFlightTitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SliverToBoxAdapter(
      child: Padding(
        // Sử dụng context.padding để thẳng hàng tuyệt đối với các Card bên dưới
        padding: EdgeInsets.symmetric(horizontal: context.padding),
        child: Column(
          children: [
            // Thay đổi từ AppLayoutSpacing sang rh để kiểm soát pixel chính xác
            // rh(32) tương đương khoảng cách giữa các section lớn
            SizedBox(height: context.rh(32)),

            Text(
              l10n.flight_viewLatestDeals,
              textAlign: TextAlign.center,
              style: TextStyle(
                // Sử dụng sp() để font không bị vỡ khi người dùng chỉnh font hệ thống
                fontSize: context.sp(22),
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1D2939),
                letterSpacing: -0.5,
              ),
            ),

            // Thay h(4) bằng rh(24) cho khoảng cách sau tiêu đề ổn định
            SizedBox(height: context.rh(24)),
          ],
        ),
      ),
    );
  }
}