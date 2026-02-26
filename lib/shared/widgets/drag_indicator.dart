import 'package:flutter/material.dart';

class DragIndicator extends StatelessWidget {
  final double width;
  final double height;
  final Color? color;

  const DragIndicator({
    super.key,
    this.width = 40,
    this.height = 5,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color ?? Colors.grey[300],
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }
}
