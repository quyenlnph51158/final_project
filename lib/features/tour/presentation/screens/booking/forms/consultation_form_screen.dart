import 'package:flutter/material.dart';
import 'package:final_project/features/tour/data/service/consulation_service.dart';
import 'package:final_project/features/tour/data/models/response/tour_api_response_model.dart';
import 'package:final_project/features/tour/data/models/request/tour_request.dart';
import 'package:final_project/app/l10n/app_localizations.dart';

import '../../../../../../../core/constants/colors.dart';


class ConsultationFormScreen extends StatefulWidget {
  final String? tourSid;
  final String location;
  final String date;
  const ConsultationFormScreen({
    super.key,
    this.location= 'Hà Nội',
    this.date= '04-12-2025',
    this.tourSid,
  });

  @override
  State<ConsultationFormScreen> createState() => _ConsultationFormState();
}

class _ConsultationFormState extends State<ConsultationFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ConsultationService consultationService=ConsultationService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    debugPrint('ConsultationFormScreen INIT: ${hashCode}');
  }

  @override
  void dispose() {
    // 4. GIẢI PHÓNG TẤT CẢ CÁC CONTROLLER ĐỂ TRÁNH RÒ RỈ BỘ NHỚ
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate() || _isLoading) {
      return;
    }

    setState(() {
      _isLoading = true; // Bắt đầu loading
    });

    // 1. TẠO REQUEST MODEL (Dữ liệu cố định và mock cho các trường chưa có trong form)
    final TourRequest request = TourRequest(
      // Dữ liệu từ form
      fullName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      note: _noteController.text.trim(),

      // Dữ liệu từ Widget properties
      tourSid: widget.tourSid,
      startDate: widget.date, // Giả định widget.date đã ở format 'd-m-Y'
      departurePoint: widget.location,
      srand: '1',
      stime: '1',
      stoken: '1',
      sf: '1',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.form_consultation_submitting_snackbar)),
    );

    // 2. GỌI SERVICE VÀ XỬ LÝ PHẢN HỒI
    final ApiResponse response = await ConsultationService().submitTourRequest(request);

    // Tắt trạng thái loading bất kể kết quả
    setState(() {
      _isLoading = false;
    });

    if (response.status == 1) {
      // THÀNH CÔNG
      _formKey.currentState!.reset(); // Đặt lại form
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.form_consultation_success_msg(response.message)),
          backgroundColor: Colors.green.shade700,
        ),
      );
    } else {
      // LỖI (Bao gồm lỗi xác thực 422)
      String errorMessage = response.message;
      if (response.errors != null && response.errors!.isNotEmpty) {
        // Trích xuất lỗi xác thực đầu tiên
        // response.errors có dạng {'email': ['Email không hợp lệ'], ...}
        final errorKey = response.errors!.keys.first;
        final firstError = (response.errors![errorKey] as List).first;
        errorMessage = l10n.form_consultation_validation_error(firstError);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Ngày khởi hành & Điểm khởi hành
          _buildDepartureInfo(),
          const SizedBox(height: 20),
          // 2. Các trường thông tin cá nhân
          _buildTextField(controller: _nameController,label: l10n.form_consultation_name_label, hint: l10n.form_consultation_name_hint),
          const SizedBox(height: 15),
          _buildTextField(controller: _phoneController,label: l10n.form_consultation_phone_label, hint: l10n.form_consultation_phone_hint, keyboardType: TextInputType.phone),
          const SizedBox(height: 15),
          _buildTextField(controller: _emailController,label: l10n.form_consultation_email_label, hint: l10n.form_consultation_email_hint, keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 15),
          _buildTextField(controller: _noteController,label: l10n.form_consultation_note_label, hint: l10n.form_consultation_note_hint, maxLines: 3),
          const SizedBox(height: 25),
          // 3. Chính sách và Ưu đãi
          _buildPolicyAndBooking(),
          const SizedBox(height: 25),
          // 4. Nút Gửi Form
          _buildSubmitButton(),
        ],
      ),
    );
  }

  // --- Widget Builders ---

  Widget _buildDepartureInfo() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Ngày khởi hành
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.form_consultation_departure_date,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: kHeaderTextColorr),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: kIconColorr),
                  SizedBox(width: 8),
                  Text(widget.date, style: TextStyle(color: kHeaderTextColorr)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Điểm khởi hành
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.form_consultation_departure_point,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: kHeaderTextColorr),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: kIconColorr),
                  SizedBox(width: 8),
                  Text(widget.location, style: TextStyle(color: kHeaderTextColorr)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller, // <<< CẦN THÊM VÀO ĐÂY
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    // Chỉ cần trường nhập liệu, không cần label nổi bật
    final l10n = AppLocalizations.of(context)!;
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: kPrimaryColorr, width: 2),
        ),
      ),
      // Giả lập logic kiểm tra nhập liệu cơ bản
      validator: (value) {
        if (value == null || value.isEmpty) {
          return l10n.form_consultation_required_error(label);
        }
        return null;
      },
    );
  }

  Widget _buildPolicyAndBooking() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chính sách hủy
        Row(
          children: [
            const Icon(Icons.refresh, color: Colors.blueGrey, size: 20),
            const SizedBox(width: 8),
            Text(
              l10n.form_consultation_policy_cancel,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const Text(' - ', style: TextStyle(color: Colors.grey)),
            GestureDetector(
              onTap: () {
                // Xử lý khi xem chi tiết
              },
              child: Text(
                l10n.form_consultation_view_detail,
                style: TextStyle(
                  color: kIconColorr, // Màu xanh đậm
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),

        // Đặt trước và thanh toán sau
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Icon(Icons.check_circle, color: kIconColorr, size: 20),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text.rich(
                TextSpan(
                  text: l10n.form_consultation_book_now_pay_later,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                    TextSpan(
                      text: l10n.form_consultation_flexible_desc,
                      style: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey),
                    ),
                  ],
                ),
                style: TextStyle(fontSize: 14.5),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: kButtonColorr, // Màu xanh teal
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: _submitForm,

        child: Text(
          l10n.form_consultation_submit_button,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}