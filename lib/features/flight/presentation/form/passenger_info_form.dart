import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_search/dropdown_search.dart';

// Constants & UI Configs
import '../../../../core/constants/colors.dart';
import '../../../../core/design/flight/flight_layout_spacing.dart';
import '../../../../core/design/flight/flight_shape.dart';
import '../../../../core/design/flight/flight_size.dart';
import '../../../../core/design/flight/flight_style.dart';
import '../../../../core/utils/date_picker.dart';
import '../../../../core/utils/responsive_layout.dart'; // Import extension

// Controller & Models
import '../controller/flight_controller.dart';
import '../inputs/date_input_formatter.dart';
import '../modals/tip_for_enter_name.dart';
import '../../../../core/data/model/country_code_model.dart';
import '../../../../core/data/constants/country_code_data.dart';

class PassengerInfoForm extends StatefulWidget {
  const PassengerInfoForm({super.key});

  @override
  State<PassengerInfoForm> createState() => _PassengerInfoFormState();
}

class _PassengerInfoFormState extends State<PassengerInfoForm> {
  final Map<String, TextEditingController> _dateControllers = {};

  @override
  void dispose() {
    for (var controller in _dateControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  TextEditingController _getController(String key) {
    if (!_dateControllers.containsKey(key)) {
      _dateControllers[key] = TextEditingController();
    }
    return _dateControllers[key]!;
  }

  @override
  Widget build(BuildContext context) {
    final flightController = context.watch<FlightController>();
    final state = flightController.state;
    final int adultCount = state.criteria.adultCount;
    final int childCount = state.criteria.childCount;
    final int infantCount = state.criteria.infantCount;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.symmetric(
        // Sử dụng rw cho padding ngang
        horizontal: context.rw(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.rh(20)), // Khoảng cách header responsive
          Text(
            l10n.enter_passenger_info,
            style: FlightStyle.sectionHeader(context).copyWith(
              fontSize: context.sp(18), // Responsive font size
            ),
          ),
          SizedBox(height: context.rh(16)),

          // 1. KHỐI THÔNG TIN CÁ NHÂN
          _buildInfoBox(
            l10n,
            title: l10n.personal_info,
            description: l10n.passenger_name_note,
            child: Column(
              children: [
                for (int i = 1; i <= adultCount; i++)
                  _buildPassengerInputGroup(l10n, context, '${l10n.adult} $i', isInfant: false),
                for (int i = 1; i <= childCount; i++)
                  _buildPassengerInputGroup(l10n, context, '${l10n.child} $i', isInfant: false),
                for (int i = 1; i <= infantCount; i++)
                  _buildPassengerInputGroup(l10n, context, '${l10n.infant} $i', isInfant: true, adultCount: adultCount),
              ],
            ),
            tip: l10n.tip_enter_name,
          ),
          SizedBox(height: context.rh(20)),

          // 2. KHỐI THÔNG TIN LIÊN HỆ
          _buildInfoBox(
            l10n,
            title: l10n.contact_info,
            description: l10n.contact_note,
            child: _buildContactSection(context),
          ),

          SizedBox(height: context.rh(24)),
          // 3. NÚT TIẾP TỤC
          _buildContinueButton(context, l10n),

          SizedBox(height: context.rh(40)),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel(l10n.country_code),
                  SizedBox(height: context.rh(8)),
                  _buildCountryPicker(context),
                ],
              ),
            ),
            SizedBox(width: context.rw(12)), // Responsive gap giữa input
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel(l10n.phone_number),
                  SizedBox(height: context.rh(8)),
                  TextField(
                    decoration: _inputDecoration(context, l10n.phone_number),
                    keyboardType: TextInputType.phone,
                    style: TextStyle(fontSize: context.sp(14)),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: context.rh(16)),
        _buildLabel(l10n.email),
        SizedBox(height: context.rh(8)),
        TextField(
          decoration: _inputDecoration(context, l10n.email),
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(fontSize: context.sp(14)),
        ),
        SizedBox(height: context.rh(16)),
        _buildLabel(l10n.special_request),
        SizedBox(height: context.rh(8)),
        TextField(
          decoration: _inputDecoration(context, l10n.request_content),
          maxLines: 3,
          style: TextStyle(fontSize: context.sp(14)),
        ),
      ],
    );
  }

  Widget _buildCountryPicker(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DropdownSearch<CountryCodeModel>(
      items: (filter, loadProps) => CountryCodeData.countries,
      compareFn: (item, selectedItem) => item.code == selectedItem.code,
      dropdownBuilder: (context, selectedItem) {
        return Container(
          height: context.rh(48), // Responsive height
          alignment: Alignment.centerLeft,
          child: Text(
            selectedItem != null ? "${selectedItem.flag} ${selectedItem.dialCode}" : "Chọn",
            style: TextStyle(fontSize: context.sp(14)),
          ),
        );
      },
      popupProps: PopupProps.menu(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: _inputDecoration(context, l10n.search).copyWith(
            prefixIcon: Icon(Icons.search, size: context.icon(20)),
          ),
        ),
        itemBuilder: (context, country, isSelected, isHighlighted) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: context.rw(12), vertical: context.rh(8)),
            child: Row(
              children: [
                Text(country.flag, style: TextStyle(fontSize: context.sp(20))),
                SizedBox(width: context.rw(12)),
                Expanded(child: Text(country.name, style: TextStyle(fontSize: context.sp(14)), overflow: TextOverflow.ellipsis)),
                Text(country.dialCode, style: TextStyle(fontSize: context.sp(14), fontWeight: FontWeight.bold)),
              ],
            ),
          );
        },
      ),
      onChanged: (newValue) {},
    );
  }

  Widget _buildContinueButton(BuildContext context, AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      height: context.rh(50), // Chiều cao nút responsive
      child: ElevatedButton(
        onPressed: () {
          // Trigger logic thanh toán OnePAY tại đây
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.rw(8)),
          ),
        ),
        child: Text(
          l10n.continue_button,
          style: TextStyle(fontSize: context.sp(16), fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildInfoBox(AppLocalizations l10n, {required String title, required String description, required Widget child, String? tip}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.rw(16)),
      decoration: BoxDecoration(
        color: kBackgroundColor,
        borderRadius: BorderRadius.circular(context.rw(12)),
        border: Border.all(color: kBorderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: context.sp(16), fontWeight: FontWeight.bold)),
          Divider(height: context.rh(24), color: kBorderColor.withOpacity(0.5)),
          Text(description, style: TextStyle(fontSize: context.sp(13), color: Colors.grey[700])),
          if (tip != null && tip.isNotEmpty) ...[
            SizedBox(height: context.rh(8)),
            GestureDetector(
              onTap: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const TipForEnterName(),
              ),
              child: Text(tip, style: TextStyle(fontSize: context.sp(13), color: kPrimaryColor, decoration: TextDecoration.underline)),
            ),
          ],
          SizedBox(height: context.rh(16)),
          child,
        ],
      ),
    );
  }

  Widget _buildPassengerInputGroup(AppLocalizations l10n, BuildContext context, String label, {required bool isInfant, int? adultCount}) {
    final controller = _getController(label);
    return Padding(
      padding: EdgeInsets.only(bottom: context.rh(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: context.sp(15), fontWeight: FontWeight.bold, color: kPrimaryColor)),
          SizedBox(height: context.rh(12)),
          _buildLabel(l10n.salutation),
          DropdownButtonFormField<String>(
            decoration: _inputDecoration(context, l10n.select_salutation),
            items: l10n.titles.split(',').map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(fontSize: context.sp(14))))).toList(),
            onChanged: (v) {},
          ),
          SizedBox(height: context.rh(12)),
          _buildLabel(l10n.last_name_passport),
          TextField(decoration: _inputDecoration(context, l10n.example_last_name), style: TextStyle(fontSize: context.sp(14))),
          SizedBox(height: context.rh(12)),
          _buildLabel(l10n.first_middle_name_passport),
          TextField(decoration: _inputDecoration(context, l10n.example_first_middle_name), style: TextStyle(fontSize: context.sp(14))),
          SizedBox(height: context.rh(12)),
          _buildLabel(l10n.birthday),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: TextStyle(fontSize: context.sp(14)),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(8), DateInputFormatter()],
            decoration: _inputDecoration(context, 'dd-mm-yyyy').copyWith(
              suffixIcon: IconButton(
                icon: Icon(Icons.calendar_today_outlined, size: context.icon(18)),
                onPressed: () => _handlePickDate(context, controller),
              ),
            ),
          ),
          if (isInfant && adultCount != null && adultCount > 0) ...[
            SizedBox(height: context.rh(12)),
            _buildLabel(l10n.accompanying_adult),
            DropdownButtonFormField<String>(
              decoration: _inputDecoration(context, l10n.select_accompanying_adult),
              items: List.generate(adultCount, (index) => DropdownMenuItem(value: 'Adult $index', child: Text('${l10n.adult} ${index + 1}', style: TextStyle(fontSize: context.sp(14))))).toList(),
              onChanged: (v) {},
            ),
          ],
          SizedBox(height: context.rh(20)),
          _buildFrequentFlyerCard(l10n),
          Padding(
            padding: EdgeInsets.symmetric(vertical: context.rh(16)),
            child: Divider(color: kBorderColor.withOpacity(0.5)),
          ),
        ],
      ),
    );
  }

  Widget _buildFrequentFlyerCard(AppLocalizations l10n) {
    return Container(
      padding: EdgeInsets.all(context.rw(12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.rw(10)),
        border: Border.all(color: kBorderColor, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.card_membership, size: context.icon(18), color: kTextColor),
              SizedBox(width: context.rw(8)),
              Text(l10n.frequent_flyer_card, style: TextStyle(fontSize: context.sp(14), fontWeight: FontWeight.w600)),
            ],
          ),
          Divider(height: context.rh(20)),
          _buildLabel(l10n.airline),
          DropdownButtonFormField<String>(
            decoration: _inputDecoration(context, l10n.select_airline),
            items: ['Vietnam Airlines', 'Bamboo Airways', 'Vietjet Air'].map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(fontSize: context.sp(14))))).toList(),
            onChanged: (v) {},
          ),
          SizedBox(height: context.rh(12)),
          _buildLabel(l10n.card_number),
          TextField(decoration: _inputDecoration(context, l10n.enter_card_number), style: TextStyle(fontSize: context.sp(14))),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.rh(4)),
      child: Text(text, style: TextStyle(fontSize: context.sp(13), fontWeight: FontWeight.w500, color: Colors.black87)),
    );
  }

  InputDecoration _inputDecoration(BuildContext context, String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      hintStyle: TextStyle(fontSize: context.sp(13), color: Colors.grey),
      contentPadding: EdgeInsets.symmetric(
        horizontal: context.rw(12),
        vertical: context.rh(12),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(context.rw(8)), borderSide: const BorderSide(color: kBorderColor)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(context.rw(8)), borderSide: const BorderSide(color: kBorderColor)),
    );
  }

  void _handlePickDate(BuildContext context, TextEditingController controller) {
    DatePicker.pickDate(
      context: context,
      onDateSelected: (formattedDate, originalDate) {
        setState(() => controller.text = formattedDate);
      },
    );
  }
}