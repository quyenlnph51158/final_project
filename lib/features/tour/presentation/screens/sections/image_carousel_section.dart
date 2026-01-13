import 'dart:async';
import 'package:final_project/features/tour/data/models/tour_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../app/l10n/app_localizations.dart';

class ImageCarousel extends StatefulWidget {
  final TourDetail tourDetail;

  const ImageCarousel({
    super.key,
    required this.tourDetail,
  });

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  late final PageController _pageController;
  Timer? _timer;
  int _imagePageIndex = 0;

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

  void _startAutoScroll() {
    if (_timer != null && _timer!.isActive) return;

    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_pageController.hasClients) return;

      final nextPage =
          (_imagePageIndex + 1) % widget.tourDetail.images.length;

      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (widget.tourDetail.images.isEmpty) {
      return Container(
        height: 200,
        color: Colors.grey.shade200,
        child: Center(child: Text(l10n.tour_detail_no_images)),
      );
    }
    return Container(
      height: 250,
      width: double.infinity,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.tourDetail.images.length,
        onPageChanged: (index) {
          setState(() {
            _imagePageIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.tourDetail.images[index],
                fit: BoxFit.cover,
                // Xử lý khi ảnh lỗi hoặc đang tải
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}