import 'package:final_project/core/constants/app_icons.dart';
import 'package:final_project/core/design/tour/app_sizes.dart';
import 'package:final_project/core/design/tour/app_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchButton extends StatelessWidget{
  final String text;
  final VoidCallback onPressed;
  const SearchButton({super.key, required this.text, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppSizes.searchButton,
      child: ElevatedButton.icon(
        style: AppStyles.searchButton,
        icon: AppIcons.iconSearch,
        label: Text(
          text,
          style: AppStyles.textSearchButton,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
