import 'package:final_project/features/tour/data/models/tour_detail_faqs.dart';

class FaqsTourDetailData {
  static const List<TourDetailFaqs> faqs = [
    TourDetailFaqs(
        id: 1,
        question: "Nếu tour bị hủy do khách quan (thời tiết, thiên tai, quốc tang,…) thì có được hoàn tiền không?",
        answer: "Nếu do bất khả kháng (thiên tai, dịch bệnh,...), công ty sẽ hoàn lại tiền nhưng có thể trừ các chi phí đã thanh toán cho đối tác (khách sạn, vé máy bay...) mà không thể hoàn hủy. Một số dịch vụ cần phụ thuộc vào chính sách hoàn/hủy/thay đổi từ phía nhà cung cấp. Nếu do lỗi của công ty, Quý khách sẽ được hoàn tiền 100% hoặc đổi sang tour khác theo yêu cầu."
    ),
    TourDetailFaqs(
        id: 2,
        question: "Các phương thức thanh toán khả dụng?",
        answer: """
        Wondering Vietnam cung cấp các phương thức đặt cọc/thanh toán tour như sau:<br>
        <ul>
          <li>Thanh toán trực tiếp tại Văn phòng Wondering Vietnam</li>
          <li>Chuyển khoản thanh toán trực tuyến qua tài khoản ngân hàng (E-banking)</li>
        </ul>
        """
    ),
    TourDetailFaqs(
        id: 3,
        question: "Thông tin cá nhân có được bảo mật không?",
        answer: "Wondering Vietnam cam kết không tiết lộ bất kỳ thông tin của Quý khách cho bên thứ 3 nào, ngoại trừ một số thông tin cần thiết cho các đối tác khách sạn để họ thực hiện việc đăng ký tạm trú theo quy định tại địa phương."
    ),
    TourDetailFaqs(
        id: 4,
        question: "Có thể đưa ra các yêu cầu đặc biệt về phòng lưu trú, ăn uống,… không?",
        answer: "Quý khách có thể liên hệ trực tiếp hoặc điền thông tin vào phần “Yêu cầu khác” khi đặt tour."
    ),
    TourDetailFaqs(
        id: 5,
        question: "Có thể xuất hóa đơn VAT không?",
        answer: "Wondering Vietnam sẽ xuất hóa đơn VAT theo đúng quy định của Bộ Tài chính."
    ),
  ];

}