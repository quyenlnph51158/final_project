import 'dart:async';
import 'package:final_project/core/constants/app_icons.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:final_project/core/design/tour/app_shape.dart';
import 'package:final_project/core/design/tour/app_sizes.dart';
import 'package:flutter/material.dart';
import '../../../../core/design/tour/app_layout_spacing.dart';

class ImageCarousel extends StatefulWidget {
  final List<String> images;
  final double height;

  const ImageCarousel({
    super.key,
    required this.images,
    this.height = AppSizes.imageDescription,
  });

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentIndex = 0;

  static const _autoScrollDuration = Duration(seconds: 4);
  static const _animationDuration = Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // ================= AUTO SCROLL =================
  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(_autoScrollDuration, (_) {
      if (!mounted || !_pageController.hasClients) return;

      final lastIndex = widget.images.length - 1;

      if (_currentIndex < lastIndex) {
        _pageController.animateToPage(
          _currentIndex + 1,
          duration: _animationDuration,
          curve: Curves.easeInOut,
        );
      } else {
        // Về đầu KHÔNG animation
        _pageController.jumpToPage(0);
      }
    });
  }

  void _pauseAutoScroll() {
    _timer?.cancel();
  }

  void _resumeAutoScroll() {
    _startAutoScroll();
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container(
        height: widget.height,
        color: kImageEmptyIconColor,
        child: Center(
          child: AppIcons.imageEmpty,
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: widget.height,
          width: double.infinity,
          child: GestureDetector(
            onPanDown: (_) => _pauseAutoScroll(), // user chạm → dừng
            onPanCancel: _resumeAutoScroll,
            onPanEnd: (_) => _resumeAutoScroll(),
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: AppLayoutSpacing.paddingImageCarousel,
                  child: ClipRRect(
                    borderRadius: AppShape.imageLoad,
                    child: Image.network(
                      widget.images[index],
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      errorBuilder: (_, __, ___) => Center(
                        child: AppIcons.imageError,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        AppLayoutSpacing.imageAndLengthLoad,

        // ================= INDICATOR =================
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.images.length,
                (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              margin: AppLayoutSpacing.marginIndicator,
              width: _currentIndex == index ? AppSizes.wActiveIdicator : AppSizes.wInActiveIndicator,
              height: AppSizes.hIndicator,
              decoration: BoxDecoration(
                color: _currentIndex == index
                    ? kActiveIndicator
                    : kInactiveIndicator,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
