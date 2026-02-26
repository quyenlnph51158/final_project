import 'package:final_project/core/constants/image_link.dart';
import 'package:final_project/core/design/tour/app_shape.dart';
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
              : ImageLink.defaultHeaderBackground,),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            kBackGroundHeaderFilter,
            BlendMode.darken,
          ),
        ),
        borderRadius: AppShape.backGroundHeader,
      ),
    );
  }
}