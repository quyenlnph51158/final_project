import '../model/promotion_model.dart';

class PromotionData {
  static const List<PromotionModel> promotions = [
    PromotionModel(
      title: 'Du Thuyền Với Bữa Tối Trên Tàu Saigon Princess',
      imageUrl:
      'https://www.wonderingvietnam.com/assets/img/common/deal_1.png',
      discount: '15%',
      type: PromotionType.cruise,
    ),
    PromotionModel(
      title: 'Phòng lưu trú tại Bakhan Resort và xe vận chuyển',
      imageUrl:
      'https://www.wonderingvietnam.com/assets/img/common/deal_2.png',
      discount: '25%',
      type: PromotionType.resort,
    ),
    PromotionModel(
      title: 'Khám phá Vịnh Hạ Long 2N1Đ trên Du thuyền',
      imageUrl:
      'https://www.wonderingvietnam.com/assets/img/common/deal_3.png',
      discount: '20%',
      type: PromotionType.cruise,
    ),
  ];
}
