import 'package:final_project/features/tour/data/models/reviews_tourdetail.dart';
import 'package:final_project/features/tour/data/models/schedules_tourdetail.dart';
import 'package:final_project/features/tour/data/models/tour_detail_faqs.dart';

import '../../../../core/data/constants/faqs_tour_detail_data.dart';

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
  final List<TourDetailFaqs> faqs;

  const TourDetail({
    required this.id,
    required this.sid,
    required this.name,
    required this.brief,
    required this.image,
    required this.images,
    required this.reviews,
    required this.schedules,
    required this.extensions,
    required this.faqs,
  });
  factory TourDetail.fromJson(Map<String,dynamic> json){
    final List<dynamic>? imageList = json['images'];

    List<String> images = [];

    if (imageList != null) {
      // Ánh xạ từng phần tử sang String và chuyển thành List<String>
      // Lưu ý: Sử dụng .map((e) => e.toString()).toList() để đảm bảo tất cả phần tử là String
      images = imageList.map((e) => e.toString()).toList();
    }
    final List<dynamic>? faqJson = json['faqs'] as List<dynamic>?;
    List<TourDetailFaqs> faqsResult;

    // 3. Logic kiểm tra dữ liệu rỗng
    if (faqJson == null || faqJson.isEmpty || _isAllFieldsNull(faqJson)) {
      // Nếu API không trả về hoặc trả về mảng rỗng -> Lấy dữ liệu tĩnh
      faqsResult = FaqsTourDetailData.faqs;
      print("faqs null");
    } else {
      // Nếu có dữ liệu từ API -> Map sang Model
      faqsResult = faqJson
          .map((i) => TourDetailFaqs.fromJson(i as Map<String, dynamic>))
          .toList();
      print("faqs has data");
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
      faqs: faqsResult,
    );
  }
  // Hàm bổ trợ để kiểm tra xem có phải tất cả các FAQ trả về đều bị null nội dung không
  static bool _isAllFieldsNull(List<dynamic> list) {
    for (var item in list) {
      if (item is Map<String, dynamic>) {
        // Nếu tìm thấy ít nhất 1 câu có dữ liệu thì coi như danh sách hợp lệ
        if (item['question'] != null && item['answer'] != null) {
          return false;
        }
      }
    }
    return true; // Tất cả đều null question/answer
  }
}