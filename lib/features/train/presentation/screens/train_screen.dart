import 'package:final_project/features/train/presentation/section/category_section.dart';
import 'package:final_project/features/train/presentation/section/promotion_section.dart';
import 'package:final_project/features/train/presentation/section/favorite_destination_section.dart';
import 'package:final_project/features/train/presentation/section/train_header_section.dart';
import 'package:final_project/shared/footer/app_footer.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../../../../shared/header/app_drawer.dart';

class TrainScreen extends StatefulWidget {
  const TrainScreen({super.key});

  @override
  State<TrainScreen> createState() => _TrainScreenState();
}

class _TrainScreenState extends State<TrainScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        // Màu nền đồng bộ để tránh lộ khoảng trắng khi cuộn trên máy thật
        backgroundColor: Colors.white,

        endDrawer: AppDrawer(),

        body: CustomScrollView(
          controller: _scrollController,
          // BouncingScrollPhysics mang lại cảm giác cao cấp trên iOS/Android thật
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 1. Header (Nền ảnh + Form tìm kiếm)
            const SliverToBoxAdapter(child: TrainHeaderSection()),

            // 2. Điểm đến yêu thích
            const SliverToBoxAdapter(child: FavoriteDestinationSection()),

            // 3. Chương trình khuyến mãi (Section này có nền xám riêng)
            const SliverToBoxAdapter(child: PromotionSection()),

            // 4. Các danh mục (Bán chạy, Hoạt động...)
            const SliverToBoxAdapter(child: CategorySection()),

            // 5. Khoảng đệm trước khi tới Footer
            // Thay h(2) bằng rh(16) để khoảng cách ổn định trên mọi máy thật
            SliverToBoxAdapter(child: SizedBox(height: context.rh(16))),

            // 6. Footer thông tin ứng dụng
            const SliverToBoxAdapter(child: AppFooter()),
          ],
        ),
      ),
    );
  }
}
