import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class AppIcons {
  //===========================Tour=====================================
  static const tourCardItemStar= Icon(
    Icons.star,
    size: 18,
    color: Colors.amber, // Màu vàng cho icon sao
  );
  static const duration = Icon(Icons.access_time, size: 16, color: Colors.grey);
  static const error = Icon(Icons.error, color: Colors.white);
  static const star = Icon(Icons.star, color: Colors.amber, size: 20);
  static const half_star = Icon(Icons.star_half, color: Colors.amber, size: 20);
  static const star_border = Icon(Icons.star_border, color: Colors.amber, size: 20);
  static const check_circle = Icon(
    Icons.check_circle,
    color: Colors.teal,
    size: 20,
  );
  static const imageEmpty = Icon(Icons.image_not_supported, size: 50);
  static const imageError = Icon(
    Icons.broken_image,
    size: 50,
    color: Colors.grey,
  );
  static const backReview = Icons.arrow_back_ios;
  static const forwardReview = Icons.arrow_forward_ios;
  static const expandedDescriptionSchedule = Icon(
    Icons.keyboard_arrow_down,
    color: Colors.black,
  );
  static const iconCalenderToday = Icon(Icons.calendar_today, size: 16, color: kPrimaryColor);
  static const iconLocation = Icon(Icons.location_on, size: 16, color: kPrimaryColor);
  static const iconRefresh = Icon(Icons.refresh, color: Colors.blueGrey, size: 20);
  static const iconSearch = Icon(Icons.search, color: Colors.white);
  static const iconCheck = Icon(Icons.check, color: kPrimaryColor);
  static const iconLocationCity = Icon(Icons.location_city, size: 35);
  static const iconSearchBox = Icon(Icons.search, color: kPrimaryColor);
  static const iconRemoveCounter = Icon(Icons.remove_circle_outline, color: kPrimaryColor);
  static const iconAddCounter = Icon(Icons.add_circle_outline, color: kPrimaryColor);

}