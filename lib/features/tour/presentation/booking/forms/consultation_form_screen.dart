import 'package:final_project/core/design/tour/tour_shape.dart';
import 'package:final_project/features/tour/presentation/controller/travel_booking_controller.dart';
import 'package:flutter/material.dart';
import 'package:final_project/features/tour/data/service/consulation_service.dart';
import 'package:final_project/features/tour/data/models/response/tour_api_response_model.dart';
import 'package:final_project/features/tour/data/models/request/tour_request.dart';
import 'package:final_project/app/l10n/app_localizations.dart';
import '../../../../../../../core/constants/colors.dart';
import '../../../../../core/utils/responsive_layout.dart';
import '../../../../policy/presentation/screens/policy_screen.dart';
import 'package:provider/provider.dart';

class ConsultationFormScreen extends StatefulWidget {
  const ConsultationFormScreen({super.key});

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
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  // --- Logic submit giữ nguyên ---
  void _submitForm() async {
    final l10n = AppLocalizations.of(context)!;
    final state = context.read<TravelBookingController>().state;
    if (!_formKey.currentState!.validate() || _isLoading) return;

    setState(() => _isLoading = true);
    final TourRequest request = TourRequest(
      fullName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      note: _noteController.text.trim(),
      tourSid: state.tour.tourDetail.sid,
      startDate: state.form.selectedDate,
      departurePoint: state.form.departure,
      srand: '1',
      stime: '1',
      stoken: '1',
      sf: '1',
    );

    final ApiResponse response = await ConsultationService().submitTourRequest(
      request,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (response.status == 1) {
      _formKey.currentState!.reset();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.form_consultation_success_msg(response.message)),
          backgroundColor: kBackGroundSuccessFullResponse,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
          backgroundColor: kError,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Cố định khoảng cách dọc giữa các field theo pixel thiết kế (khoảng 12-16px)
    final double fieldGap = context.rh(14);

    return Card(
      color: Colors.white,
      elevation: 2,
      // Dùng radius chuẩn (10 hoặc 14)
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.radius),
      ),
      child: Padding(
        // Dùng context.padding (12 hoặc 16) để thẳng hàng lề toàn app
        padding: EdgeInsets.all(context.padding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDepartureInfo(),

              SizedBox(height: context.rh(20)), // Khoảng cách sau header

              _buildTextField(
                controller: _nameController,
                label: l10n.form_consultation_name_label,
                hint: l10n.form_consultation_name_hint,
                requiredField: true,
              ),
              SizedBox(height: fieldGap),

              _buildTextField(
                controller: _phoneController,
                label: l10n.form_consultation_phone_label,
                hint: l10n.form_consultation_phone_hint,
                keyboardType: TextInputType.phone,
                requiredField: true,
              ),
              SizedBox(height: fieldGap),

              _buildTextField(
                controller: _emailController,
                label: l10n.form_consultation_email_label,
                hint: l10n.form_consultation_email_hint,
                keyboardType: TextInputType.emailAddress,
                requiredField: true,
              ),
              SizedBox(height: fieldGap),

              _buildTextField(
                controller: _noteController,
                label: l10n.form_consultation_note_label,
                hint: l10n.form_consultation_note_hint,
                requiredField: false,
                maxLines: 3,
              ),

              SizedBox(height: context.rh(24)),
              _buildPolicyAndBooking(),
              SizedBox(height: context.rh(24)),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDepartureInfo() {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<TravelBookingController>().state;

    return Column(
      children: [
        _buildInfoRow(
          l10n.form_consultation_departure_date,
          state.form.selectedDate,
          Icons.calendar_today,
        ),
        SizedBox(height: context.rh(12)),
        _buildInfoRow(
          l10n.form_consultation_departure_point,
          state.form.departure,
          Icons.location_on,
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: context.sp(14), color: Colors.blueGrey),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.rw(10),
            vertical: context.rh(6),
          ),
          decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(context.radius / 2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: context.icon(14), color: kPrimaryColor),
              SizedBox(width: context.rw(6)),
              Text(
                value,
                style: TextStyle(
                  color: kTextColor,
                  fontSize: context.sp(13),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool requiredField,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: TextStyle(fontSize: context.sp(14), color: kTextColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: context.sp(13), color: Colors.blueGrey),
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: context.sp(13),
          color: Colors.grey.shade400,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.rw(16),
          vertical: context.rh(14),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.radius * 0.6),
          borderSide: const BorderSide(color: kBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.radius * 0.6),
          borderSide: const BorderSide(color: kBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.radius * 0.6),
          borderSide: const BorderSide(color: kPrimaryColor, width: 1.5),
        ),
      ),
      validator: (value) {
        if ((value == null || value.isEmpty) && requiredField) {
          return l10n.form_consultation_required_error(label);
        }
        return null;
      },
    );
  }

  Widget _buildPolicyAndBooking() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.refresh, size: context.icon(18), color: Colors.blueGrey),
            SizedBox(width: context.rw(8)),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: context.sp(13), color: kTextColor),
                  children: [
                    TextSpan(text: l10n.form_consultation_policy_cancel),
                    const TextSpan(text: ' - '),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PolicyScreen(postId: 1),
                          ),
                        ),
                        child: Text(
                          l10n.form_consultation_view_detail,
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: context.rh(12)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.check_circle,
              size: context.icon(18),
              color: kBackGroundSuccessFullResponse,
            ),
            SizedBox(width: context.rw(8)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.form_consultation_book_now_pay_later,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: context.sp(13),
                      color: kTextColor,
                    ),
                  ),
                  SizedBox(height: context.rh(2)),
                  Text(
                    l10n.form_consultation_flexible_desc,
                    style: TextStyle(
                      fontSize: context.sp(12),
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
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
      // Nút bấm cao 48px chuẩn UX trên mọi máy thật
      height: context.rh(48).clamp(45.0, 55.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.radius),
          ),
          elevation: 0,
        ),
        onPressed: _isLoading ? null : _submitForm,
        child: _isLoading
            ? SizedBox(
                height: context.rh(20),
                width: context.rh(20),
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                l10n.form_consultation_submit_button,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: context.sp(16),
                ),
              ),
      ),
    );
  }
}
