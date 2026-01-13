// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appName => 'Final Project';

  @override
  String get general_hotline => 'Đường dây nóng';

  @override
  String get general_hotlineNumber => '+84 90 111 81 85';

  @override
  String get general_emailInfo => 'booking@wonderingvietnam.com';

  @override
  String get general_workingHours => 'Giờ làm việc';

  @override
  String get general_workingTime => 'Từ 8:00 Sáng - 22:00 Tối';

  @override
  String get general_sendButton => 'Gửi';

  @override
  String get general_copyright => 'Bản quyền © 2025 Đã đăng ký';

  @override
  String get general_visaPayment => 'VISA';

  @override
  String get general_coFounder => 'Đồng sáng lập';

  @override
  String get general_readMore => 'Đọc thêm';

  @override
  String get general_allReviews => 'Tất cả đánh giá';

  @override
  String get general_anonymousCustomer => 'Khách hàng ẩn danh';

  @override
  String get general_selectTicket => 'Chọn vé';

  @override
  String get general_lowestPrice => 'Giá thấp nhất';

  @override
  String get general_bookingButton => 'ĐẶT VÉ';

  @override
  String get general_changeButton => 'Đổi';

  @override
  String get general_consultationButton => 'NHẬN TƯ VẤN';

  @override
  String get general_detailButton => 'Chi tiết';

  @override
  String get general_passengerLabel => 'Hành khách và hạng vé';

  @override
  String get general_totalPassengers => 'Hành khách';

  @override
  String get general_coFounderName => 'Tiêu Quỳnh';

  @override
  String get general_coFounderRole => 'Co Founder';

  @override
  String get general_viewAllTours => 'XEM TẤT CẢ';

  @override
  String get general_close => 'Đóng';

  @override
  String get general_select => 'Chọn';

  @override
  String get general_reviews => 'Đánh giá';

  @override
  String get error_title => 'Đã xảy ra lỗi';

  @override
  String get error_noDataFound => 'Không tìm thấy dữ liệu.';

  @override
  String get error_retryButton => 'Thử lại';

  @override
  String get error_loadingData => 'Đang tải dữ liệu...';

  @override
  String get error_dataLoadingFailed => 'Không thể tải dữ liệu: ';

  @override
  String get error_tourListLoadingFailed => 'Lỗi tải Tour List: ';

  @override
  String get error_categoryLoadingFailed => 'Lỗi tải danh mục: ';

  @override
  String get error_flightDataLoadingFailed =>
      'Không thể tải dữ liệu chuyến bay: ';

  @override
  String get error_flightSearchMissingInput =>
      'Vui lòng nhập đầy đủ điểm đi và điểm đến.';

  @override
  String get error_flightSearchConnectionFailed =>
      'Đã xảy ra lỗi khi kết nối: ';

  @override
  String get error_tourNotFound => 'Không tìm thấy tour nào phù hợp.';

  @override
  String get error_image_load => 'Lỗi tải ảnh';

  @override
  String get error_airportDataLoadingFailed =>
      'Không thể tải dữ liệu sân bay: ';

  @override
  String get error_flight_date_invalid => 'Ngày trở về phải sau ngày đi.';

  @override
  String get error_flight_seat_not_implemented =>
      'Chức năng tìm kiếm Mã chỗ ngồi chưa được triển khai.';

  @override
  String get error_flightOutboundDataLoadingFailed =>
      'Không thể tải dữ liệu chuyến bay chiều đi!!!';

  @override
  String get error_flightReturnDataLoadingFailed =>
      'Không thể tải dữ liệu chuyến bay chiều về!!!';

  @override
  String get tab_search => 'Tìm kiếm';

  @override
  String get tab_cancel => 'Hủy';

  @override
  String get tab_itinerary => 'Hành trình';

  @override
  String get tab_tour => 'Tour Du Lịch';

  @override
  String get tab_flight => 'Vé Máy Bay';

  @override
  String get tab_train => 'Tàu Hỏa';

  @override
  String get tab_checkSchedule => 'Tra cứu lịch trình';

  @override
  String get search_loading => 'Đang tìm kiếm...';

  @override
  String get policy_loadDataFailed => 'Lỗi tải dữ liệu:';

  @override
  String get policy_detail => 'Chi tiết Chính sách';

  @override
  String get policy_loadDataPolicyFailed =>
      'Không tìm thấy dữ liệu chính sách.';

  @override
  String get policy_loadDetailPolicyFailed =>
      'Không thể tải chi tiết chính sách:';

  @override
  String policy_searchCodeArticleCode(Object postId) {
    return 'Không tìm thấy mã bài viết $postId.';
  }

  @override
  String train_directOfMove(
    Object arrivalStation,
    Object departureStation,
    Object trainCompany,
  ) {
    return 'Đã chọn: $trainCompany ($departureStation → $arrivalStation)';
  }

  @override
  String get tour_detail_read_all_reviews => 'Đọc tất cả đánh giá';

  @override
  String get tour_detail_based_on => 'Dựa trên';

  @override
  String get tour_detail_reviews_count => 'đánh giá';

  @override
  String get tour_detail_no_images => 'Không có ảnh';

  @override
  String get tour_detail_itinerary => 'Lịch trình';

  @override
  String get tour_detail_highlights => 'Điểm nhấn';

  @override
  String get tour_detail_featured_sub => 'Dành cho bạn';

  @override
  String get tour_detail_featured_main => 'Tour nổi bật';

  @override
  String get tour_detail_no_tours => 'Không tìm thấy tour nào phù hợp.';

  @override
  String get tour_detail_prev => 'Trước';

  @override
  String get tour_detail_next => 'Sau';

  @override
  String tour_detail_page_info(Object current, Object total) {
    return 'Trang $current / $total';
  }

  @override
  String get reviews_all_title => 'Tất cả đánh giá';

  @override
  String get reviews_summary => 'Tổng quan đánh giá';

  @override
  String get reviews_filter_all => 'Tất cả';

  @override
  String reviews_filter_star(Object count) {
    return ' sao ($count)';
  }

  @override
  String get menu_homeTitle => 'TRANG CHỦ';

  @override
  String get menu_tourTitle => 'TOUR';

  @override
  String get menu_flightTitle => 'VÉ MÁY BAY';

  @override
  String get menu_trainTitle => 'VÉ TÀU HỎA';

  @override
  String get menu_blogTitle => 'BLOG';

  @override
  String get menu_bookNowButton => 'ĐẶT NGAY';

  @override
  String get menu_navigatingToBook => 'Đang chuyển đến trang đặt ngay';

  @override
  String get menu_tabTour => 'Tour';

  @override
  String get menu_tabFlight => 'Máy bay';

  @override
  String get menu_tabTrain => 'Tàu';

  @override
  String get form_defaultDestination => 'Điểm đến';

  @override
  String get form_defaultDeparture => 'Hà Nội';

  @override
  String get form_defaultReturnDate => 'Chưa chọn';

  @override
  String get form_defaultClass => 'Phổ thông';

  @override
  String get form_classPremiumEconomy => 'Phổ thông đặc biệt';

  @override
  String get form_classBusiness => 'Thương gia';

  @override
  String get form_classFirst => 'Hạng nhất';

  @override
  String get form_searchTourButton => 'Tìm kiếm Tour';

  @override
  String get form_searchFlightButton => 'Tìm kiếm chuyến bay';

  @override
  String get form_searchTrainButton => 'Tìm kiếm vé tàu';

  @override
  String get form_confirmButton => 'Xác nhận';

  @override
  String get form_tripRoundTrip => 'Khứ hồi';

  @override
  String get form_tripOneWay => 'Một chiều';

  @override
  String get form_labelDestination => 'Điểm đến';

  @override
  String get form_labelDepartureDate => 'Ngày khởi hành';

  @override
  String get form_labelDeparturePlace => 'Điểm khởi hành';

  @override
  String get form_labelFlightWhereGo => 'Bạn muốn đi đâu?';

  @override
  String get form_labelFlightWhereArrive => 'Đến ?';

  @override
  String get form_labelFlightDeparture => 'Khởi hành từ';

  @override
  String get form_labelFlightArrival => 'Đến tại';

  @override
  String get form_labelFlightReturnDate => 'Ngày trở lại';

  @override
  String get form_labelTrainDeparture => 'Khởi hành từ Ga';

  @override
  String get form_labelTrainArrival => 'Đến Ga tại';

  @override
  String get form_labelTrainWhereArrive => 'Đến Ga nào?';

  @override
  String get form_labelSearchHint => 'Tìm kiếm...';

  @override
  String get form_labelAdult => 'Người lớn';

  @override
  String get form_labelAdultSubtitle => '11+ tuổi';

  @override
  String get form_labelChild => 'Trẻ em';

  @override
  String get form_labelChildSubtitle => '2 - 11 tuổi';

  @override
  String get form_labelInfant => 'Em bé';

  @override
  String get form_labelInfantSubtitle => 'Dưới 2 tuổi (Ngồi lòng)';

  @override
  String get form_labelTicketClass => 'Hạng vé';

  @override
  String get form_modalSelectDestination => 'Chọn Điểm Đến';

  @override
  String get form_modalSelectAirportDeparture => 'Chọn Sân bay Khởi hành';

  @override
  String get form_modalSelectAirportArrival => 'Chọn Sân bay Đến';

  @override
  String get form_modalSelectStationDeparture => 'Chọn Ga Tàu Khởi hành';

  @override
  String get form_modalSelectStationArrival => 'Chọn Ga Tàu Đến';

  @override
  String get form_modalPassengerTitle => 'Hành khách & Hạng vé';

  @override
  String get form_modalSearchLocationHint => 'Tìm kiếm địa điểm...';

  @override
  String get form_selectDestinationHint => 'Chọn Điểm đến';

  @override
  String get flight_screen_header_title => 'Tìm kiếm chuyến bay phù hợp';

  @override
  String get flight_screen_service_title =>
      'Nâng tầm dịch vụ của bạn với\n những tiện ích bổ sung';

  @override
  String get flight_screen_top_destinations => 'Những điểm quốc tế hàng đầu';

  @override
  String get flight_feature_luggage_title => 'Hành lý xách tay miễn phí 7 kg';

  @override
  String get flight_feature_luggage_sub =>
      'Mang theo tối đa 7 kg hành lý xách tay \n miễn phí.';

  @override
  String get flight_feature_online_checkin_title =>
      'Có thể làm thủ tục trực tuyến';

  @override
  String get flight_feature_online_checkin_sub =>
      'Dễ dàng làm thủ tục trực tuyến chỉ trong\n vài bước, tiết kiệm thời gian.';

  @override
  String get flight_feature_checkin_available_title =>
      'Thủ tục làm check-in có sẵn';

  @override
  String get flight_feature_checkin_available_sub =>
      'Bắt đầu làm thủ tục check-in từ 180 phút \n trước giờ khởi hành.';

  @override
  String get flight_error_fill_info =>
      'Vui lòng điền đủ thông tin Khởi hành, Đến, và Ngày đi.';

  @override
  String get flight_error_return_date => 'Ngày trờ về phải sau ngày đi.';

  @override
  String get flight_error_empty_seat_code =>
      'Vui lòng không để trống Mã đặt chỗ và Email.';

  @override
  String get flight_label_only_from => 'Chỉ từ';

  @override
  String get flight_results_outbound => 'Chiều đi';

  @override
  String get flight_results_return => 'Chiều về';

  @override
  String flight_results_selected_outbound(Object flightCode, Object time) {
    return 'Chiều đi đã chọn: $flightCode - $time';
  }

  @override
  String flight_results_found_count(Object count) {
    return '$count kết quả tìm thấy';
  }

  @override
  String flight_results_selecting_return(Object code) {
    return 'Đã chọn chuyến đi $code. Đang tải chuyến bay chiều về...';
  }

  @override
  String flight_results_selected_final(
    Object code,
    Object seatClass,
    Object type,
  ) {
    return 'Đã chọn chuyến $type $code, Hạng ghế: $seatClass';
  }

  @override
  String flight_results_duration_min(Object minutes) {
    return '$minutes phút';
  }

  @override
  String flight_results_duration_hour(Object hours, Object minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String get flight_returnDate => 'Ngày về';

  @override
  String get flight_arrivalToWhichAirport => 'Đến sân bay nào?';

  @override
  String get flight_arrivalAtTheAirport => 'Đến sân bay tại';

  @override
  String get flight_bookingCode => 'Mã đặt chỗ';

  @override
  String get flight_seatCode => 'Mã chỗ ngồi';

  @override
  String get flight_enterYourBookingCode => 'Nhập mã đặt chỗ của bạn';

  @override
  String get flight_enterYourSeatCode => 'Nhập mã chỗ ngồi của bạn';

  @override
  String get flight_enterYourEmail => 'Nhập email của bạn';

  @override
  String get flight_viewLatestDeals => 'Xem những ưu đãi khởi hành \n mới nhất';

  @override
  String get flight_noFlightsFound => 'Không tìm thấy chuyến bay nào phù hợp.';

  @override
  String get flight_from => 'Từ ';

  @override
  String get flight_to => ' đến ';

  @override
  String get flight_extraServices => 'Dịch vụ bổ sung';

  @override
  String get flight_searchNameOrCodeAirport =>
      'Tìm kiếm tên hoặc mã sân bay ...';

  @override
  String flight_resultFlightDate(Object date) {
    return 'Ngày: $date';
  }

  @override
  String get flight_stopNo => 'điểm dừng';

  @override
  String get flight_directFlight => 'Bay thẳng';

  @override
  String get flight_selectReturnTicket => 'Chọn vé về';

  @override
  String get flight_selectOutboundTicket => 'Chọn vé đi';

  @override
  String get flight_shrink => 'Gấp gọn';

  @override
  String get flight_readDetailPolicyTicket => 'Xem chi tiết chính sách vé';

  @override
  String get flight_luggage => 'Hành lý';

  @override
  String get flight_change => 'Thay đổi';

  @override
  String get flight_returnTicket => 'Hoàn vé';

  @override
  String get flight_selectReturnFlight => 'Chọn chuyến bay chiều về';

  @override
  String get form_consultation_departure_date => 'Ngày khởi hành';

  @override
  String get form_consultation_departure_point => 'Điểm khởi hành';

  @override
  String get form_consultation_name_label => 'Họ và tên';

  @override
  String get form_consultation_name_hint => 'Nhập họ và tên';

  @override
  String get form_consultation_phone_label => 'Số điện thoại';

  @override
  String get form_consultation_phone_hint => 'Nhập số điện thoại';

  @override
  String get form_consultation_email_label => 'Email';

  @override
  String get form_consultation_email_hint => 'Nhập Email';

  @override
  String get form_consultation_note_label => 'Yêu cầu đặc biệt';

  @override
  String get form_consultation_note_hint => 'Ghi chú thêm (nếu có)';

  @override
  String get form_consultation_policy_cancel => 'Chính sách hủy';

  @override
  String get form_consultation_view_detail => 'Xem chi tiết.';

  @override
  String get form_consultation_book_now_pay_later =>
      'Đặt trước và thanh toán sau';

  @override
  String get form_consultation_flexible_desc =>
      ' - Đảm bảo vị trí của bạn trong khi vẫn linh hoạt.';

  @override
  String get form_consultation_submit_button => 'NHẬN TƯ VẤN';

  @override
  String get form_consultation_submitting_snackbar =>
      'Đang gửi yêu cầu tư vấn...';

  @override
  String form_consultation_success_msg(Object message) {
    return 'Thành công: $message';
  }

  @override
  String form_consultation_validation_error(Object error) {
    return 'Lỗi xác thực: $error';
  }

  @override
  String form_consultation_required_error(Object field) {
    return 'Vui lòng nhập $field';
  }

  @override
  String get form_consultation_app_title_mock => 'Kết quả chuyến bay';

  @override
  String get header_titleLine1 => 'Để mỗi chuyến đi là ';

  @override
  String get header_titleLine2 => 'một trải nghiệm thú vị';

  @override
  String get home_tourSectionTitleVibes => 'Dành cho bạn';

  @override
  String get home_tourSectionTitleFeatured => 'Tour nổi bật';

  @override
  String get home_tourSectionTitleSearch => 'Tour du lịch';

  @override
  String get home_tourSearchSnackbar => 'Hiển thị Tour nổi bật.';

  @override
  String get home_destinationSnackbar => 'Đã chọn:';

  @override
  String get home_promotionSectionVibes => 'Ưu đãi';

  @override
  String get home_promotionSectionTitle => 'Dành cho bạn';

  @override
  String get home_promotionSnackbar => 'Bạn đã chọn ưu đãi:';

  @override
  String get home_destinationsTitle => '🔥 Danh mục Tour';

  @override
  String get home_aboutUsVibes => 'Giới thiệu';

  @override
  String get home_aboutUsTitleLine1 => 'Chào mừng bạn đến với';

  @override
  String get home_aboutUsTitleLine2 => 'Wondering Vietnam';

  @override
  String get home_aboutUsDescription =>
      'Wondering hoạt động trong lĩnh vực du lịch, vé máy bay và tổ chức sự kiện tại Việt Nam. Chúng tôi luôn mang đến dịch vụ chỉn chu, tận tâm với mong muốn \"mỗi chuyến đi là một câu chuyện trải nghiệm xứng đáng\". Đội ngũ nhân viên không ngừng trau dồi chuyên môn và nâng cao chất lượng phục vụ.';

  @override
  String get home_aboutUsGuideTitle => 'Hướng dẫn';

  @override
  String get home_aboutUsGuideSubtitle =>
      'Kết nối dịch vụ rộng khắp trong và ngoài nước';

  @override
  String get home_aboutUsMissionTitle => 'Tầm nhìn & Sứ mệnh';

  @override
  String get home_aboutUsMissionSubtitle =>
      'Nâng cao trải nghiệm du lịch xứng đáng.';

  @override
  String get home_exploreButton => 'Bắt đầu khám phá';

  @override
  String get home_exploreSnackbar => 'Bắt đầu khám phá...';

  @override
  String get home_trainSearchSnackbar => 'Đang tìm kiếm... (\$text)';

  @override
  String get footer_contact => 'Liên hệ';

  @override
  String get footer_introduce => 'Giới thiệu';

  @override
  String get footer_socialMediaConnect => 'Kết nối';

  @override
  String get footer_informationTitle => 'Thông tin';

  @override
  String get footer_newsTitle => 'Tin tức';

  @override
  String get footer_cancellationPolicy => 'Chính sách hoàn hủy';

  @override
  String get footer_guideTitle => 'Hướng dẫn';

  @override
  String get footer_registerOffer => 'Đăng ký ưu đãi';

  @override
  String get footer_policyFlight => 'Vé máy bay';

  @override
  String get footer_policyTour => 'Tour du lịch';

  @override
  String get footer_policyTrain => 'Vé tàu';

  @override
  String get footer_policyCruise => 'Du thuyền';

  @override
  String get footer_introDescription =>
      'Wondering Vietnam chuyên cung cấp và tư vấn các dịch vụ tour du lịch Việt Nam và Quốc tế.';

  @override
  String get footer_addressDetail =>
      'Địa chỉ: SH0212P1, Tòa Park 1, Vinhomes TimesCity Park Hill, 458 Minh Khai, Vĩnh Tuy, Hà Nội';

  @override
  String get footer_contactDetail =>
      'Hotline/Zalo: +84 90 111 81 85 / +84 76 979 8833';

  @override
  String get footer_emailDetail => 'Email: booking@wonderingvietnam.com';

  @override
  String get footer_emailTitle => 'Email';

  @override
  String get footer_registerOfferDescription =>
      'Để lại email để nhận được thông tin ưu đãi sớm nhất nhé.';

  @override
  String get footer_emailSentSnackbar => 'Đã gửi email đăng ký ưu đãi!';

  @override
  String get social_facebook => 'Facebook';

  @override
  String get social_instagram => 'Instagram';

  @override
  String get social_tiktok => 'Tiktok';

  @override
  String get social_whatsapp => 'WhatsApp';
}
