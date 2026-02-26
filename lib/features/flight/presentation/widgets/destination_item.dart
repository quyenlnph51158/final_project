import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DestinationItem extends StatelessWidget{
  final Map<String, dynamic> destination;
  final double itemWidth;
  const DestinationItem({
    super.key,
    required this.destination,
    required this.itemWidth
  });
  @override
  Widget build(BuildContext context) {
    double widthFactor = 0;
    double heightFactor = 0;
    switch (destination['type']) {
      case 'special':
        widthFactor = 2.1;
        heightFactor = 1.2;
        break;
      case 'normal':
        widthFactor=1.0;
        heightFactor=1.5;
      default:
        widthFactor = 1.0;
        heightFactor = 1.0;
        break;
    }

    double finalWidth = itemWidth * widthFactor;
    double finalHeight = itemWidth * heightFactor;

    return Padding(
      padding: const EdgeInsets.all(4.0),
      // **Không sử dụng InkWell/GestureDetector**
      child: Container(
        width: finalWidth,
        height: finalHeight,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Hình ảnh
            Image.network(
              destination['imageUrl'],
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Icon(Icons.error, color: Colors.red));
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
              bottom: 10,
              left: 10,
              right: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    destination['name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 50,
                    height: 3,
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