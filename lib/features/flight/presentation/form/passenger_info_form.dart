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
import '../../../../core/utils/responsive_layout.dart';

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

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: FlightLayoutSpacing.screenHorizontalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: FlightLayoutSpacing.gapHeader(context)),
          Text(
            'Nhập thông tin khách hàng',
            style: FlightStyle.sectionHeader(context),
          ),
          SizedBox(height: FlightLayoutSpacing.gapSection(context)),

          // 1. KHỐI THÔNG TIN CÁ NHÂN
          _buildInfoBox(
            title: 'Thông tin cá nhân',
            description: '* Vui lòng đảm bảo rằng bạn nhập tên như trên hộ chiếu. Số ký tự tối đa là 32.',
            child: Column(
              children: [
                for (int i = 1; i <= adultCount; i++)
                  _buildPassengerInputGroup(context, 'Người lớn $i', isInfant: false),
                for (int i = 1; i <= childCount; i++)
                  _buildPassengerInputGroup(context, 'Trẻ em $i', isInfant: false),
                for (int i = 1; i <= infantCount; i++)
                  _buildPassengerInputGroup(context, 'Em bé $i', isInfant: true, adultCount: adultCount),
              ],
            ),
            tip: 'Mẹo nhập tên',
          ),
          SizedBox(height: FlightLayoutSpacing.gapSection(context)),

          // 2. KHỐI THÔNG TIN LIÊN HỆ
          _buildInfoBox(
            title: 'Thông tin liên hệ',
            description: '* Vui lòng điền thông tin để nhận thông báo hành trình.',
            child: _buildContactSection(context),
          ),

          SizedBox(height: FlightLayoutSpacing.gapPassengerGroup),
          // 3. NÚT TIẾP TỤC
          _buildContinueButton(context),

          SizedBox(height: FlightLayoutSpacing.gapFooter(context)),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
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
                  _buildLabel('Mã quốc gia'),
                  SizedBox(height: FlightLayoutSpacing.gapLabel(context)),
                  _buildCountryPicker(context),
                ],
              ),
            ),
            SizedBox(width: FlightLayoutSpacing.gapInputHorizontal(context)),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Số điện thoại'),
                  SizedBox(height: FlightLayoutSpacing.gapLabel(context)),
                  TextField(
                    decoration: _inputDecoration(context, 'Số điện thoại'),
                    keyboardType: TextInputType.phone,
                    style: FlightStyle.fieldValue(context),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: FlightLayoutSpacing.gapInput(context)),
        _buildLabel('Email'),
        SizedBox(height: FlightLayoutSpacing.gapLabel(context)),
        TextField(
          decoration: _inputDecoration(context, 'Email'),
          keyboardType: TextInputType.emailAddress,
          style: FlightStyle.fieldValue(context),
        ),
        SizedBox(height: FlightLayoutSpacing.gapInput(context)),
        _buildLabel('Yêu cầu đặc biệt'),
        SizedBox(height: FlightLayoutSpacing.gapLabel(context)),
        TextField(
          decoration: _inputDecoration(context, 'Nội dung'),
          maxLines: 3,
          style: FlightStyle.fieldValue(context),        ),
      ],
    );
  }

  Widget _buildCountryPicker(BuildContext context) {
    return DropdownSearch<CountryCodeModel>(
      items: (filter, loadProps) => CountryCodeData.countries,
      compareFn: (item, selectedItem) => item.code == selectedItem.code,
      dropdownBuilder: (context, selectedItem) {
        return Container(
          height: FlightLayoutSpacing.dropdownBuilderHeight,
          alignment: Alignment.centerLeft,
          child: Text(
            selectedItem != null ? "${selectedItem.flag} ${selectedItem.dialCode}" : "Chọn",
            style: FlightStyle.fieldValue(context),
          ),
        );
      },
      popupProps: PopupProps.menu(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: _inputDecoration(context, 'Tìm tên...').copyWith(
            prefixIcon: Icon(Icons.search, size: FlightSize.iconSizeSmall(context)),
          ),
        ),
        itemBuilder: (context, country, isSelected, isHighlighted) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Text(country.flag, style: FlightStyle.countryFlag(context)),
                const SizedBox(width: 12),
                Expanded(child: Text(country.name, style: FlightStyle.countryName(context), overflow: TextOverflow.ellipsis)),
                Text(country.dialCode, style: FlightStyle.countryDialCode(context)),
              ],
            ),
          );
        },
      ),
      onChanged: (newValue) {},
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: FlightSize.btnContinueHeight(context),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: FlightShape.borderRadiusSmall(context),
          ),
        ),
        child: Text(
          'Tiếp tục',
          style: FlightStyle.buttonLarge(context),
        ),
      ),
    );
  }

  Widget _buildInfoBox({required String title, required String description, required Widget child, String? tip}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(FlightLayoutSpacing.cardPaddingInner),
      decoration: BoxDecoration(
        color: kBackgroundColor,
        borderRadius: FlightShape.borderRadiusLarge(context),
        border: Border.all(color: kBorderColor, width: FlightShape.borderThin),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: FlightStyle.infoBoxTitle(context)),
          Divider(height: FlightLayoutSpacing.gapDivider(context), color: kBorderColor.withOpacity(0.5)),
          Text(description, style: FlightStyle.infoBoxDescription(context)),
          if (tip != null && tip.isNotEmpty) ...[
            SizedBox(height: FlightLayoutSpacing.gapLabel(context)),
            GestureDetector(
              onTap: () => showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(borderRadius: FlightShape.borderRadiusBottomSheet),
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const TipForEnterName(),
              ),
              child: Text(tip, style: FlightStyle.linkButton(context)),
            ),
          ],
          SizedBox(height: FlightLayoutSpacing.gapInput(context)),
          child,
        ],
      ),
    );
  }

  Widget _buildPassengerInputGroup(BuildContext context, String label, {required bool isInfant, int? adultCount}) {
    final controller = _getController(label);
    return Padding(
      padding: const EdgeInsets.only(bottom: FlightLayoutSpacing.gapPassengerGroup),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: FlightStyle.passengerGroupLabel(context)),
          SizedBox(height: FlightLayoutSpacing.gapInput(context)),
          _buildLabel('Danh xưng'),
          DropdownButtonFormField<String>(
            decoration: _inputDecoration(context, 'Chọn danh xưng'),
            style: TextStyle(fontSize: context.sp(16), color: Colors.black),
            items: ['Ông', 'Bà', 'Cô', 'Anh', 'Chị'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (v) {},
          ),
          SizedBox(height: FlightLayoutSpacing.gapInput(context)),
          _buildLabel('Họ (như trên hộ chiếu)'),
          TextField(decoration: _inputDecoration(context, 'VD: NGUYEN'), style: FlightStyle.fieldValue(context)),
          SizedBox(height: FlightLayoutSpacing.gapInput(context)),
          _buildLabel('Tên đệm & Tên (như trên hộ chiếu)'),
          TextField(decoration: _inputDecoration(context, 'VD: VAN AN'), style: FlightStyle.fieldValue(context)),
          SizedBox(height: FlightLayoutSpacing.gapInput(context)),
          _buildLabel('Ngày sinh'),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: FlightStyle.fieldValue(context),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(8), DateInputFormatter()],
            decoration: _inputDecoration(context, 'dd-mm-yyyy').copyWith(
              suffixIcon: IconButton(
                icon: Icon(Icons.calendar_today_outlined, size: FlightSize.iconSizeSmall(context)),
                onPressed: () => _handlePickDate(context, controller),
              ),
            ),
          ),
          if (isInfant && adultCount != null && adultCount > 0) ...[
            SizedBox(height: FlightLayoutSpacing.gapInput(context)),
            _buildLabel('Đi cùng người lớn'),
            DropdownButtonFormField<String>(
              decoration: _inputDecoration(context, 'Chọn người lớn đi cùng'),
              items: List.generate(adultCount, (index) => DropdownMenuItem(value: 'Adult $index', child: Text('Người lớn ${index + 1}'))).toList(),
              onChanged: (v) {},
            ),
          ],
          SizedBox(height: FlightLayoutSpacing.gapSection(context)),
          _buildFrequentFlyerCard(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: FlightLayoutSpacing.gapPassengerGroup),
            child: Divider(color: kBorderColor.withOpacity(0.5)),
          ),
        ],
      ),
    );
  }

  Widget _buildFrequentFlyerCard() {
    return Container(
      padding: const EdgeInsets.all(FlightLayoutSpacing.cardPaddingInner),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: FlightShape.borderRadiusLarge(context),
        border: Border.all(color: kBorderColor, width: FlightShape.borderThin),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.card_membership, size: FlightSize.iconSizeSmall(context), color: kTextColor),
              const SizedBox(width: 8),
              Text('Thẻ bay thường xuyên', style: FlightStyle.frequentFlyerTitle(context)),
            ],
          ),
          const Divider(height: FlightLayoutSpacing.gapPassengerGroup),
          _buildLabel('Hãng bay'),
          DropdownButtonFormField<String>(
            decoration: _inputDecoration(context, 'Chọn hãng bay'),
            items: ['Vietnam Airlines', 'Bamboo Airways', 'Vietjet Air'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (v) {},
          ),
          SizedBox(height: FlightLayoutSpacing.gapInput(context)),
          _buildLabel('Số thẻ'),
          TextField(decoration: _inputDecoration(context, 'Nhập số thẻ'), style: FlightStyle.fieldValue(context)),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: FlightLayoutSpacing.gapLabel(context)),
      child: Text(text, style: FlightStyle.inputLabel(context)),
    );
  }

  InputDecoration _inputDecoration(BuildContext context, String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      hintStyle: FlightStyle.hintStyle(context),
      contentPadding: EdgeInsets.symmetric(
        horizontal: FlightSize.inputContentPaddingH,
        vertical: FlightSize.inputContentPaddingV,
      ),
      border: FlightShape.inputOutlineBorder(context),
      enabledBorder: FlightShape.inputOutlineBorder(context),
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
