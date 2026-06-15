import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:final_project/core/utils/remove_diacritics_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_search/dropdown_search.dart';

// Constants & UI Configs
import '../../../../core/constants/colors.dart';
import '../../../../core/utils/date_picker.dart';
import '../../../../core/utils/responsive_layout.dart';

// Controller & Models
import '../controller/flight_controller.dart';
import '../inputs/date_input_formatter.dart';
import '../modals/tip_for_enter_name.dart';
import '../../../../core/data/model/country_code_model.dart';
import '../../../../core/data/constants/country_code_data.dart';
import '../../data/models/request/flight_booking_request.dart';
import '../screens/flight_booking_summary_screen.dart';

class PassengerInfoForm extends StatefulWidget {
  final VoidCallback onSuccess;
  const PassengerInfoForm({super.key, required this.onSuccess});

  @override
  State<PassengerInfoForm> createState() => _PassengerInfoFormState();
}

class _PassengerInfoFormState extends State<PassengerInfoForm> {
  final _formKey = GlobalKey<FormState>();

  // --- CONTROLLERS CHO THÔNG TIN LIÊN HỆ ---
  final TextEditingController _contactNameController = TextEditingController();
  final TextEditingController _contactPhoneController = TextEditingController();
  final TextEditingController _contactEmailController = TextEditingController();
  final TextEditingController _contactConfirmEmailController = TextEditingController();
  final TextEditingController _specialRequestController = TextEditingController();
  CountryCodeModel? _selectedCountryCode;

  bool _isSpecialRequestEnabled = false;

  // --- MAPS LƯU TRỮ CONTROLLER CHO TỪNG HÀNH KHÁCH ---
  final Map<String, TextEditingController> _firstNameControllers = {};
  final Map<String, TextEditingController> _lastNameControllers = {};
  final Map<String, TextEditingController> _birthdayControllers = {};
  final Map<String, TextEditingController> _cardNumberControllers = {};
  final Map<String, TextEditingController> _passportControllers = {};
  final Map<String, bool> _showFrequentFlyer = {};


  // --- MAPS LƯU TRỮ GIÁ TRỊ DROPDOWN ---
  final Map<String, String?> _selectedSalutations = {};
  final Map<String, String?> _selectedAirlines = {};
  final Map<String, String?> _selectedAccompanyingAdults = {};
  final Map<String, CountryCodeModel?> _selectedNationalities = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Khởi tạo controllers dựa trên số lượng khách từ FlightController
    final state = context.read<FlightController>().state;
    _initPassengerFields('adults', state.criteria.adultCount);
    _initPassengerFields('children', state.criteria.childCount);
    _initPassengerFields('infant', state.criteria.infantCount);

    _selectedCountryCode ??= CountryCodeData.countries.firstWhere((c) => c.code == 'VN');
  }

  void _initPassengerFields(String type, int count) {
    for (int i = 1; i <= count; i++) {
      final key = "${type}_$i";
      _firstNameControllers.putIfAbsent(key, () => TextEditingController());
      _lastNameControllers.putIfAbsent(key, () => TextEditingController());
      _birthdayControllers.putIfAbsent(key, () => TextEditingController());
      _cardNumberControllers.putIfAbsent(key, () => TextEditingController());
      _passportControllers.putIfAbsent(key, () => TextEditingController());
      _selectedNationalities[key] = CountryCodeData.countries.firstWhere((c) => c.code == 'VN');
      _showFrequentFlyer[key] = false;
    }
  }

  @override
  void dispose() {
    _contactNameController.dispose();
    _contactPhoneController.dispose();
    _contactEmailController.dispose();
    _specialRequestController.dispose();
    for (var c in _firstNameControllers.values) {
      c.dispose();
    }
    for (var c in _lastNameControllers.values) {
      c.dispose();
    }
    for (var c in _birthdayControllers.values) {
      c.dispose();
    }
    for (var c in _cardNumberControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flightController = context.watch<FlightController>();
    final state = flightController.state;
    final l10n = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.rw(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.rh(20)),
            Text(
              l10n.enter_passenger_info,
              style: TextStyle(
                color: kTextColor,
                fontSize: context.sp(20),
                fontWeight: FontWeight.w700,
              ).copyWith(fontSize: context.sp(18)),
            ),
            SizedBox(height: context.rh(16)),

            // 1. KHỐI THÔNG TIN CÁ NHÂN
            _buildInfoBox(
              l10n,
              title: l10n.personal_info,
              description: l10n.passenger_name_note,
              child: Column(
                children: [
                  ..._buildPassengerList('adults', state.criteria.adultCount, l10n.adult, l10n),
                  ..._buildPassengerList('children', state.criteria.childCount, l10n.child, l10n),
                  ..._buildPassengerList('infant', state.criteria.infantCount, l10n.infant, l10n, adultCount: state.criteria.adultCount),
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
              child: _buildContactSection(context, l10n),
            ),

            SizedBox(height: context.rh(24)),
            // 3. NÚT TIẾP TỤC
            _buildContinueButton(context, l10n),

            SizedBox(height: context.rh(40)),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPassengerList(String type, int count, String label, AppLocalizations l10n, {int? adultCount}) {
    return List.generate(count, (i) => _buildPassengerInputGroup(
        l10n,
        context,
        '$label ${i + 1}',
        isInfant: type == 'infant',
        key: '${type}_${i + 1}',
        adultCount: adultCount
    ));
  }

  Widget _buildContactSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(l10n.country_code),
        _buildCountryPicker(context, l10n),
        SizedBox(height: context.rh(16)),
        _buildLabel("Tên người liên hệ"),
        TextFormField(
          controller: _contactNameController,
          decoration: _inputDecoration(context, "Nhập họ tên"),
          validator: (v) => v!.isEmpty ? "Vui lòng nhập tên" : null,
          inputFormatters: [RemoveDiacriticsFormatter()],
          style: TextStyle(fontSize: context.sp(14)),
        ),
        SizedBox(height: context.rh(16)),
        _buildLabel(l10n.phone_number),
        TextFormField(
          controller: _contactPhoneController,
          decoration: _inputDecoration(context, l10n.phone_number),
          keyboardType: TextInputType.phone,
          validator: (v) => v!.isEmpty ? "Vui lòng nhập số điện thoại" : null,
          style: TextStyle(fontSize: context.sp(14)),
        ),
        SizedBox(height: context.rh(16)),
        _buildLabel(l10n.email),
        TextFormField(
          controller: _contactEmailController,
          decoration: _inputDecoration(context, l10n.email),
          keyboardType: TextInputType.emailAddress,
          validator: (v) => !v!.contains('@') ? "Email không hợp lệ" : null,
          style: TextStyle(fontSize: context.sp(14)),
        ),
        SizedBox(height: context.rh(16)),
        _buildLabel(l10n.confirm_email),
        TextFormField(
          controller: _contactConfirmEmailController,
          decoration: _inputDecoration(context, l10n.email),
          keyboardType: TextInputType.emailAddress,
          validator: (v) => !v!.contains('@') ? "Email không hợp lệ" : null,
          style: TextStyle(fontSize: context.sp(14)),
        ),
        SizedBox(height: context.rh(16)),
        Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: _isSpecialRequestEnabled,
                activeColor: kPrimaryColor,
                onChanged: (val) {
                  setState(() {
                    _isSpecialRequestEnabled = val ?? false;
                    if (!_isSpecialRequestEnabled) {
                      _specialRequestController.clear();
                    }
                  });
                },
              ),
            ),
            SizedBox(width: context.rw(8)),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isSpecialRequestEnabled = !_isSpecialRequestEnabled;
                  if (!_isSpecialRequestEnabled) _specialRequestController.clear();
                });
              },
              child: _buildLabel(l10n.special_request),
            ),
          ],
        ),

        if (_isSpecialRequestEnabled) ...[
          SizedBox(height: context.rh(8)),
          TextFormField(
            controller: _specialRequestController,
            decoration: _inputDecoration(context, l10n.request_content),
            maxLines: 3,
            style: TextStyle(fontSize: context.sp(14)),
          ),
        ],
      ],
    );
  }

  Widget _buildPassengerInputGroup(
      AppLocalizations l10n,
      BuildContext context,
      String displayLabel, {
        required bool isInfant,
        required String key,
        int? adultCount,
      }) {
    // --- BƯỚC 1: CHUẨN HÓA DANH SÁCH (TRIM KHOẢNG TRẮNG) ---
    final List<String> salutationOptions = l10n.titles
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty) // Lọc bỏ các phần tử rỗng nếu lỡ tay để dấu phẩy ở cuối
        .toList();

    // --- BƯỚC 2: KIỂM TRA GIÁ TRỊ HIỆN TẠI ---
    String? currentValue = _selectedSalutations[key];

    // Nếu "Mr" không nằm trong ["Ông", "Bà"] thì phải reset về null ngay
    if (currentValue != null && !salutationOptions.contains(currentValue)) {
      currentValue = null;
    }
    return Padding(
      padding: EdgeInsets.only(bottom: context.rh(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(displayLabel, style: TextStyle(fontSize: context.sp(15), fontWeight: FontWeight.bold, color: kPrimaryColor)),
          SizedBox(height: context.rh(12)),

          _buildLabel(l10n.salutation),
          DropdownButtonFormField<String>(
            key: ValueKey('${key}_${salutationOptions.join(',')}'),
            // 2. Thay value bằng initialValue
            initialValue: currentValue,
            decoration: _inputDecoration(context, l10n.select_salutation),
            items: l10n.titles.split(',').map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(fontSize: context.sp(14))))).toList(),
            onChanged: (v) => setState(() => _selectedSalutations[key] = v),
            validator: (v) => v == null ? "Chọn danh xưng" : null,
          ),

          SizedBox(height: context.rh(12)),
          _buildLabel(l10n.last_name_passport),
          TextFormField(
            controller: _lastNameControllers[key],
            decoration: _inputDecoration(context, l10n.example_last_name),
            inputFormatters: [RemoveDiacriticsFormatter()],
            textCapitalization: TextCapitalization.characters,
            validator: (v) => v!.isEmpty ? "Vui lòng nhập Họ" : null,
            style: TextStyle(fontSize: context.sp(14)),
          ),

          SizedBox(height: context.rh(12)),
          _buildLabel(l10n.first_middle_name_passport),
          TextFormField(
            controller: _firstNameControllers[key],
            decoration: _inputDecoration(context, l10n.example_first_middle_name),
            inputFormatters: [RemoveDiacriticsFormatter()],
            textCapitalization: TextCapitalization.characters,
            validator: (v) => v!.isEmpty ? "Vui lòng nhập Tên" : null,
            style: TextStyle(fontSize: context.sp(14)),
          ),

          SizedBox(height: context.rh(12)),
          _buildLabel(l10n.birthday),
          TextFormField(
            controller: _birthdayControllers[key],
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(8), DateInputFormatter()],
            decoration: _inputDecoration(context, 'dd-mm-yyyy').copyWith(
              suffixIcon: IconButton(
                icon: Icon(Icons.calendar_today_outlined, size: context.icon(18)),
                onPressed: () => _handlePickDate(context, _birthdayControllers[key]!),
              ),
            ),
            validator: (v) => v!.length < 10 ? "Ngày sinh không đúng" : null,
          ),

          if (isInfant && adultCount != null && adultCount > 0) ...[
            SizedBox(height: context.rh(12)),
            _buildLabel(l10n.accompanying_adult),
            DropdownButtonFormField<String>(
              value: _selectedAccompanyingAdults[key],
              decoration: _inputDecoration(context, l10n.select_accompanying_adult),
              items: List.generate(adultCount, (index) => DropdownMenuItem(
                value: 'adults_${index + 1}',
                child: Text('${l10n.adult} ${index + 1}', style: TextStyle(fontSize: context.sp(14))),
              )).toList(),
              onChanged: (v) => setState(() => _selectedAccompanyingAdults[key] = v),
            ),
          ],
          SizedBox(height: context.rh(20)),
          _buildFrequentFlyerCard(l10n, key),
          // MỚI: Thêm vào đây
          _buildTravelDocumentFields(l10n, context, key),
          Padding(
            padding: EdgeInsets.symmetric(vertical: context.rh(16)),
            child: Divider(color: kBorderColor.withOpacity(0.5)),
          ),
        ],
      ),
    );
  }

  Widget _buildFrequentFlyerCard(AppLocalizations l10n, String key) {
    bool isExpanded = _showFrequentFlyer[key] ?? false;

    return Container(
      margin: EdgeInsets.only(top: context.rh(12)),
      padding: EdgeInsets.all(context.rw(12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.rw(10)),
        border: Border.all(color: kBorderColor, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Phần Tiêu đề: Có thể nhấn vào để ẩn/hiện
          InkWell(
            onTap: () => setState(() => _showFrequentFlyer[key] = !isExpanded),
            child: Row(
              children: [
                Icon(Icons.card_membership, size: context.icon(18), color: kTextColor),
                SizedBox(width: context.rw(8)),
                Expanded(
                  child: Text(
                    l10n.frequent_flyer_card,
                    style: TextStyle(fontSize: context.sp(14), fontWeight: FontWeight.w600),
                  ),
                ),
                // Icon mũi tên chỉ trạng thái
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: kPrimaryColor,
                ),
              ],
            ),
          ),

          // Phần nội dung nhập liệu: Chỉ hiện khi isExpanded = true
          if (isExpanded) ...[
            Divider(height: context.rh(20)),
            _buildLabel(l10n.airline),
            DropdownButtonFormField<String>(
              value: _selectedAirlines[key],
              decoration: _inputDecoration(context, l10n.select_airline),
              items: ['Vietnam Airlines', 'Bamboo Airways', 'Vietjet Air']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(fontSize: context.sp(14)))))
                  .toList(),
              onChanged: (v) => setState(() => _selectedAirlines[key] = v),
            ),
            SizedBox(height: context.rh(12)),
            _buildLabel(l10n.card_number),
            TextFormField(
              controller: _cardNumberControllers[key],
              decoration: _inputDecoration(context, l10n.enter_card_number),
              style: TextStyle(fontSize: context.sp(14)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context, AppLocalizations l10n) {
    final isLoading = context.select((FlightController c) => c.state.ui.isLoading);
    return SizedBox(
      width: double.infinity,
      height: context.rh(50),
      child: ElevatedButton(
        onPressed: isLoading ? null : _onBookingSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.rw(8))),
        ),
        child: isLoading
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text(l10n.continue_button, style: TextStyle(fontSize: context.sp(16), fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  // --- LOGIC TỔNG HỢP DỮ LIỆU VÀ SUBMIT ---
  void _onBookingSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = context.read<FlightController>();
    List<PassengerRequest> passengerList = [];

    // Duyệt qua tất cả các chặng hành khách để gom dữ liệu
    _firstNameControllers.forEach((key, controller) {
      final type = key.split('_')[0]; // adults, children, infant

      passengerList.add(PassengerRequest(
        firstName: _firstNameControllers[key]!.text.trim().toUpperCase(),
        lastName: _lastNameControllers[key]!.text.trim().toUpperCase(),
        gender: _selectedSalutations[key] == 'Ông' || _selectedSalutations[key] == 'Mr' ? 1 : 2,
        type: type,
        birthday: _birthdayControllers[key]!.text,
        flyer: _selectedAirlines[key],
        cardNumber: _cardNumberControllers[key]!.text,
        passportNumber: _passportControllers[key]!.text.trim().toUpperCase(),
        nationality: _selectedNationalities[key]?.code ?? "VN",
      ));
    });

    final bool isSuccess = await controller.createBooking(
      passengers: passengerList,
      contactName: _contactNameController.text.trim(),
      contactPhone: _contactPhoneController.text.trim(),
      contactEmail: _contactEmailController.text.trim(),
      specialRequest: _specialRequestController.text,
      contactConfirmEmail: _contactConfirmEmailController.text.trim(),
    );
    if (isSuccess && mounted) {
      widget.onSuccess();
    }
  }

  // UI Helpers (Giữ nguyên logic cũ nhưng đổi thành TextFormField để dùng validator)
  Widget _buildLabel(String text) => Padding(padding: EdgeInsets.only(bottom: context.rh(4)), child: Text(text, style: TextStyle(fontSize: context.sp(13), fontWeight: FontWeight.w500)));

  InputDecoration _inputDecoration(BuildContext context, String hint) => InputDecoration(
    hintText: hint, filled: true, fillColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(horizontal: context.rw(12), vertical: context.rh(12)),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(context.rw(8)), borderSide: const BorderSide(color: kBorderColor)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(context.rw(8)), borderSide: const BorderSide(color: kBorderColor)),
  );

  void _handlePickDate(BuildContext context, TextEditingController controller) {
    DatePicker.pickDate(context: context, onDateSelected: (formattedDate, _) => setState(() => controller.text = formattedDate));
  }

  Widget _buildCountryPicker(BuildContext context, AppLocalizations l10n) {
    return DropdownSearch<CountryCodeModel>(
      items: (f, p) => CountryCodeData.countries,
      itemAsString: (CountryCodeModel u) => "${u.flag} ${u.name}",
      selectedItem: _selectedCountryCode,
      compareFn: (item, sItem) => item.code == sItem.code,
      dropdownBuilder: (ctx, item) => Text(item != null ? "${item.flag} ${item.name} (${item.dialCode})" : "Chọn", style: TextStyle(fontSize: context.sp(14))),
      onChanged: (v) => setState(() => _selectedCountryCode = v),
    );
  }

  Widget _buildInfoBox(AppLocalizations l10n, {required String title, required String description, required Widget child, String? tip}) {
    return Container(
      width: double.infinity, padding: EdgeInsets.all(context.rw(16)),
      decoration: BoxDecoration(color: kBackgroundColor, borderRadius: BorderRadius.circular(context.rw(12)), border: Border.all(color: kBorderColor)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontSize: context.sp(16), fontWeight: FontWeight.bold)),
        Divider(height: context.rh(24), color: kBorderColor.withOpacity(0.5)),
        Text(description, style: TextStyle(fontSize: context.sp(13), color: Colors.grey[700])),
        if (tip != null) ...[SizedBox(height: context.rh(8)), GestureDetector(onTap: () => showModalBottomSheet(context: context, builder: (ctx) => const TipForEnterName()), child: Text(tip, style: TextStyle(fontSize: context.sp(13), color: kPrimaryColor, decoration: TextDecoration.underline)))],
        SizedBox(height: context.rh(16)), child,
      ]),
    );
  }
  // Hàm build nhóm input mới: Hộ chiếu & Quốc tịch
  // Hàm build nhóm input: Hộ chiếu & Quốc tịch (Đã đồng bộ với Frequent Flyer Card)
  Widget _buildTravelDocumentFields(AppLocalizations l10n, BuildContext context, String key) {
    return Container(
      margin: EdgeInsets.only(top: context.rh(12)),
      padding: EdgeInsets.all(context.rw(12)),
      decoration: BoxDecoration(
        color: Colors.white, // Đổi từ grey.shade50 sang white để đồng bộ
        borderRadius: BorderRadius.circular(context.rw(10)),
        border: Border.all(color: kBorderColor, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề nhóm có Icon (Giống FrequentFlyerCard)
          Row(
            children: [
              Icon(
                Icons.assignment_ind_outlined, // Icon đại diện cho giấy tờ/hộ chiếu
                size: context.icon(18),
                color: kTextColor,
              ),
              SizedBox(width: context.rw(8)),
              Text(
                "Thông tin giấy tờ du lịch",
                style: TextStyle(
                  fontSize: context.sp(14),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Divider(height: context.rh(20)), // Divider đồng bộ độ cao

          // Ô nhập Số hộ chiếu
          _buildLabel("Số hộ chiếu / CCCD"),
          TextFormField(
            controller: _passportControllers[key],
            decoration: _inputDecoration(context, "Nhập số hộ chiếu hoặc CCCD"),
            style: TextStyle(fontSize: context.sp(14)),
            textCapitalization: TextCapitalization.characters, // Tự động viết hoa
            validator: (v) => v!.isEmpty ? "Vui lòng nhập số giấy tờ" : null,
          ),

          SizedBox(height: context.rh(12)), // Khoảng cách giữa các ô nhập

          // Ô chọn Quốc tịch
          _buildLabel("Quốc tịch"),
          DropdownSearch<CountryCodeModel>(
            items: (f, p) => CountryCodeData.countries,
            itemAsString: (CountryCodeModel u) => "${u.flag} ${u.name}",
            selectedItem: _selectedNationalities[key],
            compareFn: (item, sItem) => item.code == sItem.code,
            dropdownBuilder: (ctx, item) => Text(
              item != null ? "${item.flag} ${item.name}" : "Chọn quốc tịch",
              style: TextStyle(fontSize: context.sp(14)),
            ),
            popupProps: PopupProps.menu(
              showSearchBox: true,
              searchFieldProps: TextFieldProps(
                decoration: _inputDecoration(context, "Tìm quốc gia"),
              ),
              // Tuỳ chỉnh hiển thị danh sách trong popup
              itemBuilder: (context, item, isSelected, isHighlighted) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.rw(12),
                    vertical: context.rh(10),
                  ),
                  child: Text(
                    "${item.flag} ${item.name}",
                    style: TextStyle(fontSize: context.sp(14)),
                  ),
                );
              },
            ),
            onChanged: (v) => setState(() => _selectedNationalities[key] = v),
          ),
        ],
      ),
    );
  }
}