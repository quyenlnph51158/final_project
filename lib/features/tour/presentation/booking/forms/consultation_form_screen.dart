import 'package:final_project/core/constants/app_icons.dart';
import 'package:final_project/core/design/tour/tour_layout_spacing.dart';
import 'package:final_project/core/design/tour/tour_shape.dart';
import 'package:final_project/core/design/tour/tour_styles.dart';
import 'package:final_project/features/tour/presentation/controller/travel_booking_controller.dart';
import 'package:flutter/material.dart';
import 'package:final_project/features/tour/data/service/consulation_service.dart';
import 'package:final_project/features/tour/data/models/response/tour_api_response_model.dart';
import 'package:final_project/features/tour/data/models/request/tour_request.dart';
import 'package:final_project/app/l10n/app_localizations.dart';
import '../../../../../../../core/constants/colors.dart';
import '../../../../policy/presentation/screens/policy_screen.dart';
import 'package:provider/provider.dart';


class ConsultationFormScreen extends StatefulWidget {
  const ConsultationFormScreen({
    super.key,
  });

  @override
  State<ConsultationFormScreen> createState() => _ConsultationFormState();
}

class _ConsultationFormState extends State<ConsultationFormScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
    final state = context.watch<TravelBookingController>().state;
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
      tourSid: state.tour.tourDetail.sid,
      startDate: state.form.selectedDate, // Giả định widget.date đã ở format 'd-m-Y'
      departurePoint: state.form.departure,
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
    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });


    if (response.status == 1) {
      // THÀNH CÔNG
      _formKey.currentState!.reset(); // Đặt lại form
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.form_consultation_success_msg(response.message)),
          backgroundColor: kBackGroundSuccessFullResponse,
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
          backgroundColor: kError,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
        color: Colors.white, // Background of the form
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Ngày khởi hành & Điểm khởi hành
                  _buildDepartureInfo(),
                  TourLayoutSpacing.departureInfoAndField,
                  // 2. Các trường thông tin cá nhân
                  _buildTextField(controller: _nameController,label: l10n.form_consultation_name_label, hint: l10n.form_consultation_name_hint, requiredField: true),
                  TourLayoutSpacing.field,
                  _buildTextField(controller: _phoneController,label: l10n.form_consultation_phone_label, hint: l10n.form_consultation_phone_hint, keyboardType: TextInputType.phone, requiredField: true),
                  TourLayoutSpacing.field,
                  _buildTextField(controller: _emailController,label: l10n.form_consultation_email_label, hint: l10n.form_consultation_email_hint, keyboardType: TextInputType.emailAddress, requiredField: true),
                  TourLayoutSpacing.field,
                  _buildTextField(controller: _noteController,label: l10n.form_consultation_note_label, hint: l10n.form_consultation_note_hint,requiredField: false , maxLines: 3),
                  TourLayoutSpacing.fieldAndPolicyOrButton,
                  // 3. Chính sách và Ưu đãi
                  _buildPolicyAndBooking(),
                  TourLayoutSpacing.fieldAndPolicyOrButton,
                  // 4. Nút Gửi Form
                  _buildSubmitButton(),
                ],
              ),
            )
        )
    );
  }

  // --- Widget Builders ---
  Widget _buildDepartureInfo() {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<TravelBookingController>().state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Ngày khởi hành
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.form_consultation_departure_date,
              style: AppStyles.labelDepartureDate(context),
            ),
            Container(
              padding: TourLayoutSpacing.paddingDepartureDate(context),
              decoration: AppShape.departureDate,
              child: Row(
                children: [
                  AppIcons.iconCalenderToday,
                  TourLayoutSpacing.iconAndValue,
                  Text(state.form.selectedDate, style: TextStyle(color: kTextColor)),
                ],
              ),
            ),
          ],
        ),
        TourLayoutSpacing.departureDateAndDeparturePoint,

        // Điểm khởi hành
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.form_consultation_departure_point,
              style: AppStyles.labelDeparturePoint(context),
            ),
            Container(
              padding: TourLayoutSpacing.paddingDeparturePoint(context),
              decoration: AppShape.departurePoint,
              child: Row(
                children: [
                  AppIcons.iconLocation,
                  TourLayoutSpacing.iconAndValue,
                  Text(state.form.departure, style: TextStyle(color: kTextColor)),
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
    required bool requiredField,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    // Chỉ cần trường nhập liệu, không cần label nổi bật
    final l10n = AppLocalizations.of(context)!;
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: TourLayoutSpacing.paddingContentInField(context),
        border: AppShape.selectionField,
      ),
      // Giả lập logic kiểm tra nhập liệu cơ bản
      validator: (value) {
        if ((value == null || value.isEmpty) && requiredField==true) {
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
            AppIcons.iconRefresh,
            const SizedBox(width: 8),
            Text(
              l10n.form_consultation_policy_cancel,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const Text(' - ', style: TextStyle(color: kTextColor)),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PolicyScreen(postId: 1),
                  ),
                );
              },
              child: Text(
                l10n.form_consultation_view_detail,
                style: AppStyles.viewDetailPolicy,
              ),
            ),
          ],
        ),
        TourLayoutSpacing.field,

        // Đặt trước và thanh toán sau
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: TourLayoutSpacing.iconCancellation(context),
              child: AppIcons.check_circle,
            ),
            TourLayoutSpacing.IconCancellationAndText,

            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PolicyScreen(postId: 8),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.form_consultation_book_now_pay_later,
                      style: AppStyles.textBookNowAndPayLater(context),
                    ),
                    TourLayoutSpacing.textBookNowAndFlexibleText,
                    Text(
                      l10n.form_consultation_flexible_desc,
                      style: AppStyles.textFlexibleDesc(context),

                    ),
                  ],
                ),
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
        style: AppStyles.submitButton,
        onPressed: _submitForm,
        child: Text(
          l10n.form_consultation_submit_button,
          style: AppStyles.textSubmitButton(context),
        ),
      ),
    );
  }
}