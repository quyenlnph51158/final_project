import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_layout.dart';

class VipSeatExplanationBottomSheet extends StatelessWidget {
  const VipSeatExplanationBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => const VipSeatExplanationBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      // Sử dụng rh để giới hạn chiều cao tối đa ổn định trên mọi tỷ lệ màn hình
      constraints: BoxConstraints(
        maxHeight: context.rh(
          700,
        ), // Thay cho 90% (h(90)) để tránh bị quá dài trên máy thật
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.radius * 1.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- HANDLE BAR: Thanh nhỏ phía trên (UX chuẩn vuốt chạm) ---
          Container(
            margin: EdgeInsets.symmetric(vertical: context.rh(12)),
            width: context.rw(40),
            height: context.rh(4),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(context.radius),
            ),
          ),

          // --- HEADER: Tiêu đề và nút đóng ---
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.padding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    l10n.vip_seat_explanation_title,
                    style: TextStyle(
                      fontSize: context.sp(20),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    size: context.icon(24),
                    color: Colors.grey,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          SizedBox(height: context.rh(12)),
          const Divider(height: 1),

          // --- BODY: Nội dung giải thích ---
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(context.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNormalText(context, l10n.vip_seat_intro),
                  SizedBox(height: context.rh(20)),

                  _buildSectionTitle(context, l10n.vip_2_berth_title),
                  _buildNormalText(context, l10n.vip_2_berth_desc),
                  SizedBox(height: context.rh(20)),

                  _buildSectionTitle(context, l10n.queen_size_title),
                  _buildNormalText(context, l10n.queen_size_desc),
                  SizedBox(height: context.rh(20)),

                  _buildSectionTitle(context, l10n.king_size_title),
                  _buildNormalText(context, l10n.king_size_desc),
                  SizedBox(height: context.rh(20)),

                  _buildSectionTitle(context, l10n.note_title),
                  _buildNormalText(context, l10n.note_desc),

                  // Khoảng đệm an toàn dưới cùng dựa trên rh
                  SizedBox(height: context.rh(40)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.rh(8)),
      child: Text(
        title,
        style: TextStyle(
          fontSize: context.sp(16),
          fontWeight: FontWeight.bold,
          color: kTextColor,
        ),
      ),
    );
  }

  Widget _buildNormalText(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: context.sp(14),
        color: Colors.black.withOpacity(0.75),
        height: 1.5,
      ),
      textAlign: TextAlign.justify,
    );
  }
}
