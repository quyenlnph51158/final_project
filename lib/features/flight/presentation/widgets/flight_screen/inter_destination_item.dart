import 'package:final_project/core/data/model/international_destination_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/responsive_layout.dart';

class DestinationItem extends StatelessWidget {
  final InternationalDestinationModel destination;
  final double itemWidth;

  const DestinationItem({
    super.key,
    required this.destination,
    required this.itemWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.rw(4.0)),
      // **Không sử dụng InkWell/GestureDetector**
      child: Container(
        width: itemWidth,
        height: context.rh(200),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.sp(8)),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Hình ảnh
            Image.network(
              destination.imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.error, color: Colors.red),
                );
              },
            ),

            // 2. Lớp phủ (Overlay)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.0),
                    Colors.black.withOpacity(0.6),
                  ],
                ),
              ),
            ),

            // 3. Tên điểm đến (Định vị ở dưới cùng)
            Positioned(
              bottom: context.rh(10.0),
              left: context.rh(10.0),
              right: context.rh(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    destination.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: context.sp(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: context.rw(8.0) / 2,
                    ),
                    width: context.rw(50),
                    height: context.rh(3),
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
