import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class AppShape {

  static final card =  RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0)
  );

  static final imageInCard = BorderRadius.vertical(top: Radius.circular(12.0));
  static final reviewCard = BorderRadius.circular(8.0);
  static final backGroundHeader = BorderRadius.vertical(bottom: Radius.circular(20));
  static final containerForm = BoxDecoration(
    color: kFormBackgroundColor,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 10,
        offset: const Offset(0, 5),
      ),
    ],
  );
  //=================================Tour Screen==================
  static final boxForm = BoxDecoration(
    color: kFormBackgroundColor,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 10,
        offset: const Offset(0, 5),
      ),
    ],
  );
  //=================================AboutUs======================
  static final  aboutUsButton = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10));
  //===============================Tour Detail====================
  static final imageLoad = BorderRadius.circular(12);
  static final scheduleItem = BorderRadius.circular(20);
  static final departureDate = BoxDecoration(
    color: Colors.grey.shade100,
    borderRadius: BorderRadius.circular(20),
  );
  static final departurePoint = BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(20),
  );
  //==========================ShowList==============
 static final borderSearchBox = OutlineInputBorder(
     borderRadius: BorderRadius.circular(10),
     borderSide: const BorderSide(color: kBorderColor));
 static final selectList = RoundedRectangleBorder(
     borderRadius: BorderRadius.vertical(top: Radius.circular(20)));
 static final selectionField = OutlineInputBorder(
   borderRadius: BorderRadius.circular(8),
   borderSide: const BorderSide(color: kFormBackgroundColor),
 );

}