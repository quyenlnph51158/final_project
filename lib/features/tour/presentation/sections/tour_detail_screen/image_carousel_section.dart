import 'dart:async';
import 'package:flutter/material.dart';
import 'package:final_project/core/constants/app_icons.dart';
import 'package:final_project/core/constants/colors.dart';
import '../../../../../core/utils/responsive_layout.dart';

class ImageCarousel extends StatefulWidget {
  final List<String> images;
  final double height;

  const ImageCarousel({super.key, required this.images, required this.height});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentIndex = 0;

  // Tạo một con số lớn để giả lập vòng lặp vô tận
  static const int _infiniteCount = 10000;
  static const _autoScrollDuration = Duration(seconds: 4);

  @override
  void initState() {
    super.initState();
    // Bắt đầu từ giữa danh sách để có thể vuốt trái/phải ngay lập tức
    final int initialPage = widget.images.isNotEmpty
        ? (_infiniteCount ~/ 2) - ((_infiniteCount ~/ 2) % widget.images.length)
        : 0;
    _pageController = PageController(initialPage: initialPage);
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    if (widget.images.length <= 1) return;
    _timer?.cancel();
    _timer = Timer.periodic(_autoScrollDuration, (_) {
      if (_pageController.hasClients) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container(
        height: widget.height,
        color: kImageEmptyIconColor,
        child: Center(child: AppIcons.imageEmpty),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: GestureDetector(
            onPanDown: (_) => _timer?.cancel(),
            onPanEnd: (_) => _startAutoScroll(),
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length > 1 ? _infiniteCount : 1,
              onPageChanged: (index) {
                setState(() => _currentIndex = index % widget.images.length);
              },
              itemBuilder: (context, index) {
                final realIndex = index % widget.images.length;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.rw(10)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.images[realIndex],
                      fit: BoxFit.cover,
                      loadingBuilder: (_, child, progress) =>
                      progress == null ? child : const Center(child: CircularProgressIndicator()),
                      errorBuilder: (_, __, ___) => Center(child: AppIcons.imageError),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(height: context.rh(8)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.images.length,
                (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: context.rw(4)),
              width: _currentIndex == index ? context.rw(18.0) : context.rw(8.0),
              height: context.rh(8.0),
              decoration: BoxDecoration(
                color: _currentIndex == index ? kActiveIndicator : kInactiveIndicator,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}