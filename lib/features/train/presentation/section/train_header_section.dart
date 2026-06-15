import 'package:final_project/core/constants/image_link.dart';
import 'package:final_project/features/train/presentation/form/train_form.dart';
import 'package:flutter/material.dart';
import '../../../../../shared/header/custom_app_bar.dart';
import '../../../../../../app/l10n/app_localizations.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../../../tour/presentation/widgets/header/header_back_ground.dart';

class TrainHeaderSection extends StatelessWidget {
  const TrainHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. TÍNH TOÁN CHIỀU CAO THEO PIXEL THIẾT KẾ (Base height 812)

    // Chiều cao nền ảnh: Thiết kế khoảng 250px
    final double headerBgHeight = context.rh(250).clamp(200.0, 320.0);

    // Chiều cao ước tính của Form: Thiết kế khoảng 480px
    final double formHeight = context.rh(480).clamp(400.0, 560.0);

    // Khoảng cách đè lên nền (Overlap): Thiết kế khoảng 40px
    final double overlapOffset = context.rh(40).clamp(20.0, 60.0);

    // Tổng chiều cao thực tế của toàn bộ khu vực Header
    final double totalHeaderAreaHeight =
        (headerBgHeight - overlapOffset) + formHeight;

    return SizedBox(
      width: double.infinity,
      height: totalHeaderAreaHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // A. LỚP NỀN ẢNH (BACKGROUND)
          HeaderBackground(
            height: headerBgHeight,
            image: ImageLink.TrainScreenBackgroundHeader,
          ),

          // B. PHẦN ĐỈNH: APPBAR VÀ TIÊU ĐỀ
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomAppBar(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.padding,
                      // Thay h(0.5) bằng rh(4) để khoảng cách dọc ổn định
                      vertical: context.rh(4),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.train_headerTitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: context.sp(22),
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                            offset: Offset(0, context.rh(2)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // C. PHẦN FORM TÌM KIẾM (TRAIN FORM)
          Positioned(
            top: headerBgHeight - overlapOffset,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.padding),
              child: Container(
                padding: EdgeInsets.all(context.padding),
                decoration: BoxDecoration(
                  color: kFormBackgroundColor,
                  borderRadius: BorderRadius.circular(context.radius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      // Tăng nhẹ độ đậm cho máy thật
                      blurRadius: 20,
                      offset: Offset(0, context.rh(10)),
                    ),
                  ],
                ),
                child: const Material(
                  color: Colors.transparent,
                  child: TrainForm(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
