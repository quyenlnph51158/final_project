import 'package:final_project/features/tour/data/models/reviews_tourdetail.dart';
import 'package:final_project/features/tour/data/models/schedules_tourdetail.dart';

class TourDetail {
  final int id;
  final String sid;
  final String name;
  final String brief;
  final String image;
  final List<String> images;
  final List<Reviews> reviews;
  final List<SchedulesTourDetail> schedules;
  final List<String> extensions;

  const TourDetail({
    required this.id,
    required this.sid,
    required this.name,
    required this.brief,
    required this.image,
    required this.images,
    required this.reviews,
    required this.schedules,
    required this.extensions
  });
  factory TourDetail.fromJson(Map<String,dynamic> json){
    final List<dynamic>? imageList = json['images'];

    List<String> images = [];

    if (imageList != null) {
      // Ánh xạ từng phần tử sang String và chuyển thành List<String>
      // Lưu ý: Sử dụng .map((e) => e.toString()).toList() để đảm bảo tất cả phần tử là String
      images = imageList.map((e) => e.toString()).toList();
    }
    return TourDetail(
      id: json['id'] as int? ?? 0,
      sid: json['sid'] as String? ?? '',
      name: json['name']?.toString() ?? '',
      brief: json['brief']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      images: images,
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((i) => Reviews.fromJson(i as Map<String, dynamic>))
          .toList() ?? [],
      schedules: (json['schedules'] as List<dynamic>?)
          ?.map((i) => SchedulesTourDetail.fromJson(i as Map<String, dynamic>))
          .toList() ?? [],
      extensions: (json['extensions'] as List<dynamic>?)?.map((i) => i.toString()).toList() ?? [],
    );
  }
}