import '../model/location_model.dart';

class ListCityData {
  // Hàm lấy danh sách dựa theo mã ngôn ngữ (vi hoặc en)
  static List<LocationModel> getLocations(String languageCode) {
    return languageCode.toLowerCase() == 'vi' ? vietnameseLocations : englishLocations;
  }

  static const List<LocationModel> vietnameseLocations = [
    LocationModel(id: 2, name: "Sa Pa", province: "Lào Cai", code: "S2", value: "S2", label: "Sa Pa, Việt Nam", desc: "Sa Pa", country: "Việt Nam"),
    LocationModel(id: 1, name: "Hà Nội", province: "Hà Nội", code: "H1", value: "H1", label: "Hà Nội, Việt Nam", desc: "Hà Nội", country: "Việt Nam"),
    LocationModel(id: 3, name: "Hải Phòng", province: "Hải Phòng", code: "HP3", value: "HP3", label: "Hải Phòng, Việt Nam", desc: "Hải Phòng", country: "Việt Nam"),
    LocationModel(id: 21, name: "Ninh Bình", province: "Ninh Bình", code: "NB2", value: "NB2", label: "Ninh Bình, Việt Nam", desc: "Ninh Bình", country: "Việt Nam"),
    LocationModel(id: 22, name: "Đồng Hới", province: "Quảng Bình", code: "DH2", value: "DH2", label: "Đồng Hới, Việt Nam", desc: "Đồng Hới", country: "Việt Nam"),
    LocationModel(id: 11, name: "Vinh", province: "Nghệ An", code: "V1", value: "V1", label: "Vinh, Việt Nam", desc: "Vinh", country: "Việt Nam"),
    LocationModel(id: 7, name: "Huế", province: "Thừa Thiên Huế", code: "H7", value: "H7", label: "Huế, Việt Nam", desc: "Huế", country: "Việt Nam"),
    LocationModel(id: 6, name: "Đà Nẵng", province: "Đà Nẵng", code: "DN6", value: "DN6", label: "Đà Nẵng, Việt Nam", desc: "Đà Nẵng", country: "Việt Nam"),
    LocationModel(id: 23, name: "Diêu Trì", province: "Bình Định", code: "DT2", value: "DT2", label: "Diêu Trì, Việt Nam", desc: "Diêu Trì", country: "Việt Nam"),
    LocationModel(id: 25, name: "Quy Nhơn", province: "Bình Định", code: "QN2", value: "QN2", label: "Quy Nhơn, Việt Nam", desc: "Quy Nhơn", country: "Việt Nam"),
    LocationModel(id: 24, name: "Tuy Hòa", province: "Phú Yên", code: "TH2", value: "TH2", label: "Tuy Hòa, Việt Nam", desc: "Tuy Hòa", country: "Việt Nam"),
    LocationModel(id: 5, name: "Nha Trang", province: "Khánh Hòa", code: "NT5", value: "NT5", label: "Nha Trang, Việt Nam", desc: "Nha Trang", country: "Việt Nam"),
    LocationModel(id: 26, name: "Tháp Chàm", province: "Ninh Thuận", code: "TC2", value: "TC2", label: "Tháp Chàm, Việt Nam", desc: "Tháp Chàm", country: "Việt Nam"),
    LocationModel(id: 27, name: "Bình Thuận", province: "Bình Thuận", code: "BT2", value: "BT2", label: "Bình Thuận, Việt Nam", desc: "Bình Thuận", country: "Việt Nam"),
    LocationModel(id: 28, name: "Sài Gòn", province: "Hồ Chí Minh", code: "SG2", value: "SG2", label: "Sài Gòn, Việt Nam", desc: "Sài Gòn", country: "Việt Nam"),
    LocationModel(id: 29, name: "Phan Thiết", province: "Bình Thuận", code: "PT2", value: "PT2", label: "Phan Thiết, Việt Nam", desc: "Phan Thiết", country: "Việt Nam"),
  ];

  static const List<LocationModel> englishLocations = [
    LocationModel(id: 2, name: "Sapa", province: "Sapa", code: "S2", value: "S2", label: "Sapa, Vietnam", desc: "Sapa", country: "Vietnam"),
    LocationModel(id: 1, name: "Hanoi", province: "Hanoi", code: "H1", value: "H1", label: "Hanoi, Vietnam", desc: "Hanoi", country: "Vietnam"),
    LocationModel(id: 3, name: "Hai Phong", province: "Hai Phong", code: "HP3", value: "HP3", label: "Hai Phong, Vietnam", desc: "Hai Phong", country: "Vietnam"),
    LocationModel(id: 21, name: "Ninh Binh", province: "Ninh Binh", code: "NB2", value: "NB2", label: "Ninh Binh, Vietnam", desc: "Ninh Binh", country: "Vietnam"),
    LocationModel(id: 22, name: "Dong Hoi", province: "Dong Hoi", code: "DH2", value: "DH2", label: "Dong Hoi, Vietnam", desc: "Dong Hoi", country: "Vietnam"),
    LocationModel(id: 11, name: "Vinh", province: "Vinh", code: "V1", value: "V1", label: "Vinh, Vietnam", desc: "Vinh", country: "Vietnam"),
    LocationModel(id: 7, name: "Hue", province: "Hue", code: "H7", value: "H7", label: "Hue, Vietnam", desc: "Hue", country: "Vietnam"),
    LocationModel(id: 6, name: "Da Nang", province: "Da Nang", code: "DN6", value: "DN6", label: "Da Nang, Vietnam", desc: "Da Nang", country: "Vietnam"),
    LocationModel(id: 23, name: "Dieu Tri", province: "Dieu Tri", code: "DT2", value: "DT2", label: "Dieu Tri, Vietnam", desc: "Dieu Tri", country: "Vietnam"),
    LocationModel(id: 25, name: "Quy Nhon", province: "Quy Nhon", code: "QN2", value: "QN2", label: "Quy Nhon, Vietnam", desc: "Quy Nhon", country: "Vietnam"),
    LocationModel(id: 24, name: "Tuy Hoa", province: "Tuy Hoa", code: "TH2", value: "TH2", label: "Tuy Hoa, Vietnam", desc: "Tuy Hoa", country: "Vietnam"),
    LocationModel(id: 5, name: "Nha Trang", province: "Nha Trang", code: "NT5", value: "NT5", label: "Nha Trang, Vietnam", desc: "Nha Trang", country: "Vietnam"),
    LocationModel(id: 26, name: "Thap Cham", province: "Thap Cham", code: "TC2", value: "TC2", label: "Thap Cham, Vietnam", desc: "Thap Cham", country: "Vietnam"),
    LocationModel(id: 27, name: "Binh Thuan", province: "Binh Thuan", code: "BT2", value: "BT2", label: "Binh Thuan, Vietnam", desc: "Binh Thuan", country: "Vietnam"),
    LocationModel(id: 28, name: "Sai Gon", province: "Sai Gon", code: "SG2", value: "SG2", label: "Sai Gon, Vietnam", desc: "Sai Gon", country: "Vietnam"),
    LocationModel(id: 29, name: "Phan Thiet", province: "Phan Thiet", code: "PT2", value: "PT2", label: "Phan Thiet, Vietnam", desc: "Phan Thiet", country: "Vietnam"),
  ];
}