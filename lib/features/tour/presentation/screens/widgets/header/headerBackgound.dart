import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/constants/colors.dart';

class HeaderBackground extends StatelessWidget{
  final double height;
  final String? image;
  const HeaderBackground({super.key,
    required this.height,
    this.image,
  });
  @override
  Widget build(BuildContext context){
    final bool hasImage = image != null && image!.isNotEmpty;
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        image: DecorationImage(
          image: NetworkImage(hasImage
              ? image!
              : 'https://picsum.photos/seed/travel/800/600',),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black38,
            BlendMode.darken,
          ),
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
    );
  }
}