import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:final_project/features/train/data/models/carrier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../../../core/utils/responsive_layout.dart';

class DetailDeviceBottomSheet extends StatelessWidget {
  final Carrier carrier;

  const DetailDeviceBottomSheet({super.key, required this.carrier});

  static Future<void> show(BuildContext context, Carrier carrier) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => DetailDeviceBottomSheet(carrier: carrier),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      // Sử dụng rh để giới hạn chiều cao tối đa ổn định trên mọi tỷ lệ màn hình
      constraints: BoxConstraints(
        maxHeight: context.rh(730), // Thay cho h(90)
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
          // --- HANDLE BAR (UX chuẩn vuốt chạm) ---
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
                    carrier.name ?? "",
                    style: TextStyle(
                      fontSize: context.sp(18),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
          SizedBox(height: context.rh(8)),
          const Divider(height: 1),

          // --- CONTENT: Ảnh và Văn bản ---
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(context.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Danh sách ảnh
                  if (carrier.fileLinks != null)
                    ...carrier.fileLinks!.map(
                      (e) => _buildImageItem(context, e),
                    ),

                  SizedBox(height: context.rh(8)),

                  // Văn bản mô tả (Render từ HTML)
                  HtmlWidget(
                    carrier.content ?? "",
                    textStyle: TextStyle(
                      fontSize: context.sp(14.5),
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: context.rh(16)),
                ],
              ),
            ),
          ),

          // --- FOOTER: Nút Đã hiểu ---
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.all(context.padding),
              child: SizedBox(
                width: double.infinity,
                height: context.rh(48).clamp(45.0, 55.0),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF2F4F5),
                    foregroundColor: const Color(0xFF006B7A),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(context.radius),
                    ),
                  ),
                  child: Text(
                    l10n.understood,
                    style: TextStyle(
                      fontSize: context.sp(16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget phụ trợ để tạo ảnh có bo góc responsive
  Widget _buildImageItem(BuildContext context, String url) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.rh(12)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.radius),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          // Chiều cao ảnh cố định theo pixel scale để không bị kéo giãn trên máy dài
          height: context.rh(180).clamp(150.0, 250.0),
          width: double.infinity,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: context.rh(180).clamp(150.0, 250.0),
              color: Colors.grey[100],
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) => Container(
            height: context.rh(180).clamp(150.0, 250.0),
            color: Colors.grey[200],
            child: const Icon(Icons.broken_image, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
