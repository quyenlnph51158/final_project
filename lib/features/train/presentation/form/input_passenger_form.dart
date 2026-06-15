import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:final_project/core/utils/format_date.dart';
import 'package:final_project/core/utils/format_duration.dart';
import 'package:final_project/core/utils/format_price.dart';
import 'package:final_project/core/utils/remove_diacritics_formatter.dart';
import 'package:final_project/features/train/data/models/seat_class.dart';
import 'package:final_project/features/train/data/models/station_object.dart';
import 'package:final_project/features/train/data/models/train_booking_request/create_booking_request.dart';
import 'package:final_project/features/train/data/models/train_model.dart';
import 'package:final_project/features/train/presentation/screens/train_booking_summary_screen.dart';
import 'package:final_project/features/train/presentation/state/train_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/utils/responsive_layout.dart';

import '../../../flight/presentation/inputs/date_input_formatter.dart';
import '../../data/models/passenger_model.dart';
import '../controller/train_controller.dart';
import '../../../../core/data/model/country_code_model.dart';
import '../../../../core/data/constants/country_code_data.dart';
import '../state/train_data_state.dart';

class InputPassengerForm extends StatefulWidget {
  const InputPassengerForm({super.key});

  @override
  State<InputPassengerForm> createState() => _InputPassengerFormState();
}

class _InputPassengerFormState extends State<InputPassengerForm> {
  final _formKey = GlobalKey<FormState>();

  // --- CONTROLLERS ---
  final Map<String, TextEditingController> _dateControllers = {};
  final Map<String, TextEditingController> _firstNameControllers = {};
  final Map<String, TextEditingController> _lastNameControllers = {};
  final Map<String, TextEditingController> _passportControllers = {};
  final Map<String, String> _nationalityValues = {};

  final TextEditingController _customerName = TextEditingController();
  final TextEditingController _customerPhoneNumber = TextEditingController();
  final TextEditingController _customerEmail = TextEditingController();
  final TextEditingController _specialRequestController =
      TextEditingController();

  final TextEditingController _hotelGoAddressController =
      TextEditingController();
  final TextEditingController _hotelReturnAddressController =
      TextEditingController();

  String _goServiceType = "none"; // "none" là không yêu cầu, "bus" là xe buýt
  String _returnServiceType = "none";

  String _customerCountryCode = 'VN';
  bool _showSpecialRequest = false;
  bool _isProcessing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Khởi tạo controllers 1 lần duy nhất dựa trên số lượng khách từ state
    final state = context.read<TrainController>().state;
    _initPassengerControllers('adults', state.form.adultCount);
    _initPassengerControllers('children', state.form.childCount);
    _initPassengerControllers('infant', state.form.infantCount);
  }

  void _initPassengerControllers(String type, int count) {
    for (int i = 1; i <= count; i++) {
      final key = "${type}_$i";
      _dateControllers.putIfAbsent(key, () => TextEditingController());
      _firstNameControllers.putIfAbsent(key, () => TextEditingController());
      _lastNameControllers.putIfAbsent(key, () => TextEditingController());
      _passportControllers.putIfAbsent(key, () => TextEditingController());
      _nationalityValues.putIfAbsent(key, () => 'VN');
    }
  }

  @override
  void dispose() {
    // Giải phóng tất cả controllers để tránh leak bộ nhớ
    final allControllers = [
      ..._dateControllers.values,
      ..._firstNameControllers.values,
      ..._lastNameControllers.values,
      ..._passportControllers.values,
      _customerName,
      _customerPhoneNumber,
      _customerEmail,
      _specialRequestController,
      _hotelGoAddressController,
      _hotelReturnAddressController,
    ];
    for (var controller in allControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trainController = context.watch<TrainController>();
    final state = trainController.state;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      color: kBackgroundColor,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: context.rh(16)),
                _buildTitle(l10n.trip_information),
                _buildTripCard(
                  state.data.SelectedDepartureTrain!,
                  state.data.SelectedDepartureSeatClass!,
                  state.data.SelectedReturnTrain,
                  state.data.SelectedReturnSeatClass,
                  l10n,
                ),
                SizedBox(height: context.rh(24)),
                _buildTitle(l10n.enter_passenger_info),
                _buildInfoBox(
                  title: l10n.personal_info,
                  description: l10n.passenger_name_note,
                  child: Column(
                    children: [
                      ..._buildPassengerGroups(
                        'adults',
                        state.form.adultCount,
                        l10n.adult,
                        l10n,
                      ),
                      ..._buildPassengerGroups(
                        'children',
                        state.form.childCount,
                        l10n.child,
                        l10n,
                      ),
                      ..._buildPassengerGroups(
                        'infant',
                        state.form.infantCount,
                        l10n.infant,
                        l10n,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: context.rh(20)),
                _buildInfoBox(
                  title: l10n.contact_info,
                  description: l10n.contact_note,
                  child: _buildContactSection(context, l10n),
                ),
                SizedBox(height: context.rh(20)),
                _buildExtraServicesSection(state, l10n),
                SizedBox(height: context.rh(32)),
                _buildContinueButton(l10n),
                SizedBox(height: context.rh(40)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPER METHODS ---

  Widget _buildTitle(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.rh(12)),
      child: Text(
        text,
        style: TextStyle(
          fontSize: context.sp(18),
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1D2939),
        ),
      ),
    );
  }

  List<Widget> _buildPassengerGroups(
    String type,
    int count,
    String label,
    AppLocalizations l10n,
  ) {
    return List.generate(
      count,
      (i) => _buildPassengerInputGroup(
        context,
        '$label ${i + 1}',
        i + 1,
        type,
        l10n,
      ),
    );
  }

  Widget _buildPassengerInputGroup(
    BuildContext context,
    String label,
    int index,
    String type,
    AppLocalizations l10n,
  ) {
    final key = "${type}_$index";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: context.rh(12)),
        Text(
          label,
          style: TextStyle(
            fontSize: context.sp(15),
            fontWeight: FontWeight.bold,
            color: kPrimaryColor,
          ),
        ),
        SizedBox(height: context.rh(16)),
        _buildLabelField(
          l10n.titleFirstName,
          child: _buildTextFormField(
            _firstNameControllers[key]!,
            l10n.titleFirstName,
            formatters: [RemoveDiacriticsFormatter()],
          ),
        ),
        SizedBox(height: context.rh(12)),
        _buildLabelField(
          l10n.last_name,
          child: _buildTextFormField(
            _lastNameControllers[key]!,
            l10n.last_name,
            formatters: [RemoveDiacriticsFormatter()],
          ),
        ),
        SizedBox(height: context.rh(12)),
        _buildLabelField(
          l10n.passport_number,
          child: _buildTextFormField(
            _passportControllers[key]!,
            l10n.passport_number,
          ),
        ),
        SizedBox(height: context.rh(12)),
        _buildLabelField(
          l10n.birthday,
          child: _buildTextFormField(
            _dateControllers[key]!,
            'dd/mm/yyyy',
            keyboardType: TextInputType.number,
            formatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(8),
              DateInputFormatter(),
            ],
          ),
        ),
        SizedBox(height: context.rh(12)),
        _buildLabelField(
          "Quốc tịch",
          child: DropdownButtonFormField<String>(
            value: _nationalityValues[key],
            decoration: _inputDecoration(context, "Chọn quốc tịch"),
            items: CountryCodeData.countries
                .map(
                  (c) => DropdownMenuItem(
                    value: c.code,
                    child: Text(
                      "${c.flag} ${c.name}",
                      style: TextStyle(fontSize: context.sp(13)),
                    ),
                  ),
                )
                .toList(),
            onChanged: (val) => setState(() => _nationalityValues[key] = val!),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: context.rh(16)),
          child: const Divider(),
        ),
      ],
    );
  }

  Widget _buildContactSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        _buildLabelField(
          l10n.country_code,
          child: _buildCountryPicker(context, l10n),
        ),
        SizedBox(height: context.rh(12)),
        _buildLabelField(
          "Tên khách hàng liên hệ",
          child: _buildTextFormField(
            _customerName,
            "Nhập họ tên",
            formatters: [RemoveDiacriticsFormatter()],
          ),
        ),
        SizedBox(height: context.rh(12)),
        _buildLabelField(
          l10n.phone_number,
          child: _buildTextFormField(
            _customerPhoneNumber,
            l10n.phone_number,
            keyboardType: TextInputType.phone,
          ),
        ),
        SizedBox(height: context.rh(12)),
        _buildLabelField(
          l10n.email,
          child: _buildTextFormField(
            _customerEmail,
            l10n.email,
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        _buildSpecialRequestToggle(),
      ],
    );
  }

  Widget _buildSpecialRequestToggle() {
    return Column(
      children: [
        Row(
          // Căn lề trái cho cả Row
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              // Bọc trong SizedBox để kiểm soát chính xác chiều rộng
              width: 24, // Chiều rộng bằng đúng kích thước cái hộp
              height: 48, // Giữ chiều cao để dễ bấm
              child: Checkbox(
                value: _showSpecialRequest,
                activeColor: kPrimaryColor,
                // 1. Loại bỏ khoảng trống thừa của Material Design
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                // 2. Thu hẹp mật độ hiển thị để đẩy sát ra biên
                visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                onChanged: (v) => setState(() => _showSpecialRequest = v!),
              ),
            ),
            SizedBox(width: context.rw(8)), // Khoảng cách giữa box và chữ
            Expanded( // Dùng Expanded để tránh lỗi tràn dòng nếu chữ dài
              child: GestureDetector(
                onTap: () =>
                    setState(() => _showSpecialRequest = !_showSpecialRequest),
                child: Text(
                  "Tôi có yêu cầu đặc biệt",
                  style: TextStyle(
                    fontSize: context.sp(14),
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (_showSpecialRequest)
          _buildTextFormField(
            _specialRequestController,
            "Nội dung yêu cầu",
            maxLines: 3,
          ),
      ],
    );
  }

  // --- CORE UI COMPONENTS ---

  Widget _buildTextFormField(
    TextEditingController controller,
    String hint, {
    List<TextInputFormatter>? formatters,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      inputFormatters: formatters,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: (v) =>
          (v == null || v.trim().isEmpty) ? "Trường này là bắt buộc" : null,
      decoration: _inputDecoration(context, hint),
      style: TextStyle(fontSize: context.sp(14)),
    );
  }

  Widget _buildLabelField(String label, {required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: context.sp(12), color: kTextColor),
        ),
        SizedBox(height: context.rh(6)),
        child,
      ],
    );
  }

  Widget _buildInfoBox({
    required String title,
    required String description,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.radius),
        border: Border.all(color: kBorderColor.withOpacity(0.5)),
      ),
      padding: EdgeInsets.all(context.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: context.sp(16),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            description,
            style: TextStyle(
              fontSize: context.sp(11),
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
          const Divider(height: 24),
          child,
        ],
      ),
    );
  }

  Widget _buildContinueButton(AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      height: context.rh(50),
      child: ElevatedButton(
        onPressed: _isProcessing ? null : _handleBookingSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.radius),
          ),
        ),
        child: _isProcessing
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                l10n.continue_button,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  // --- LOGIC HANDLERS ---

  Future<void> _handleBookingSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);
    try {
      final controller = context.read<TrainController>();
      final state = controller.state;

      List<PassengerModel> passengers = [];
      _collectData(passengers, 'adults', state.form.adultCount);
      _collectData(passengers, 'children', state.form.childCount);
      _collectData(passengers, 'infant', state.form.infantCount);

      await controller.CreateBooking(
        passengers: passengers,
        CustomerName: _customerName.text.trim(),
        CustomerPhonNumber: _customerPhoneNumber.text.trim(),
        CustomerEmail: _customerEmail.text.trim(),
        CustomerCountryCode: _customerCountryCode,
        extraService: [
          if (_hotelGoAddressController.text.isNotEmpty)
            SpecialRequestModel(
              index: 1,
              address: _hotelGoAddressController.text.trim(),
            ),
          if (_hotelReturnAddressController.text.isNotEmpty)
            SpecialRequestModel(
              index: 2,
              address: _hotelReturnAddressController.text.trim(),
            ),
        ],
        customerNote: _showSpecialRequest ? _specialRequestController.text : '',
      );

      if (mounted && controller.state.data.summaryTrainResponseData != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TrainBookingSummaryScreen()),
        );
      }
    } catch (e) {
      debugPrint("Booking Error: $e");
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _collectData(List<PassengerModel> list, String type, int count) {
    for (int i = 1; i <= count; i++) {
      final key = "${type}_$i";
      list.add(
        PassengerModel(
          name:
              "${_lastNameControllers[key]?.text.trim()} ${_firstNameControllers[key]?.text.trim()}"
                  .toUpperCase(),
          type: type,
          birthday: _dateControllers[key]?.text ?? '',
          passportNumber: _passportControllers[key]?.text ?? '',
          nationnality: _nationalityValues[key] ?? 'VN',
        ),
      );
    }
  }

  // --- REMAINING UI (Trip Card, Decoration, etc.) ---
  // ... (Giữ nguyên các hàm _buildTripCard, _buildTripSection, _buildCountryPicker, _inputDecoration của bạn) ...

  InputDecoration _inputDecoration(BuildContext context, String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      hintStyle: TextStyle(color: Colors.grey, fontSize: context.sp(13)),
      contentPadding: EdgeInsets.symmetric(
        horizontal: context.rw(12),
        vertical: context.rh(10),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(context.radius * 0.6),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(context.radius * 0.6),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(context.radius * 0.6),
        borderSide: const BorderSide(color: kPrimaryColor, width: 1.5),
      ),
    );
  }

  Widget _buildTripCard(
    TrainModel depT,
    SeatClass depS,
    TrainModel? retT,
    SeatClass? retS,
    AppLocalizations l10n,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: kBorderColor.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(context.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(context.padding),
            child: Text(
              l10n.itinerary,
              style: TextStyle(
                fontSize: context.sp(16),
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
          ),
          const Divider(height: 1),
          _buildTripSection(
            title: l10n.departure,
            route: '${depT.departure} → ${depT.arrival}',
            date: FormatDate.parseStringToDateString(
              depT.dateTimeStart,
            ).toString(),
            depTime: formatTime(depT.timeStart!),
            depCode: depT.originStationObject?.code ?? '',
            arrTime: formatTime(depT.arrivalTime!),
            arrCode: depT.destinationStationObject?.code ?? '',
            duration: FormatDuration.formatDuration(depT.duration!, l10n),
            trainInfo: '${depT.trainCode} - ${depT.carrier?.name ?? ''}',
            price: depS.price ?? 0,
            currency: depT.currency ?? "",
          ),
          if (retT != null && retS != null) ...[
            const Divider(height: 1),
            _buildTripSection(
              title: l10n.return_trip,
              route: '${retT.departure} → ${retT.arrival}',
              date: FormatDate.parseStringToDateString(
                retT.dateTimeStart,
              ).toString(),
              depTime: formatTime(retT.timeStart!),
              depCode: retT.originStationObject?.code ?? '',
              arrTime: formatTime(retT.arrivalTime!),
              arrCode: retT.destinationStationObject?.code ?? '',
              duration: FormatDuration.formatDuration(retT.duration!, l10n),
              trainInfo: '${retT.trainCode} - ${retT.carrier?.name ?? ''}',
              price: retS.price ?? 0,
              currency: retT.currency ?? "",
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTripSection({
    required String title,
    required String route,
    required String date,
    required String depTime,
    required String depCode,
    required String arrTime,
    required String arrCode,
    required String duration,
    required String trainInfo,
    required num price,
    required String currency
  }) {

    return Padding(
      padding: EdgeInsets.all(context.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: context.sp(11),
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
          SizedBox(height: context.rh(4)),
          Text(
            '$route | $date',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: context.sp(14),
              color: const Color(0xFF001D35),
            ),
          ),
          SizedBox(height: context.rh(16)),
          Row(
            children: [
              _buildStationCol(depTime, depCode),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      duration,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: context.sp(10),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      child: DashLine(),
                    ),
                    Text(
                      trainInfo,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: context.sp(10),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              _buildStationCol(arrTime, arrCode),
              Container(
                height: context.rh(30),
                width: 1,
                color: Colors.grey.shade300,
                margin: EdgeInsets.symmetric(horizontal: context.rw(12)),
              ),
              Text(
                "${FormatPrice.formatPrice(price).toString()} $currency",
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: context.sp(15),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStationCol(String time, String code) {
    return Column(
      children: [
        Text(
          time,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: context.sp(15),
          ),
        ),
        Text(
          code,
          style: TextStyle(color: Colors.grey, fontSize: context.sp(12)),
        ),
      ],
    );
  }

  Widget _buildCountryPicker(BuildContext context, AppLocalizations l10n) {
    return SizedBox(
      height: context.rh(45),
      child: DropdownSearch<CountryCodeModel>(
        // Thuộc tính bắt buộc khi dùng Object: So sánh qua thuộc tính 'code'
        compareFn: (item1, item2) => item1.code == item2.code,

        // Logic tìm kiếm/lọc
        items: (filter, props) => CountryCodeData.countries
            .where(
              (c) =>
                  c.name.toLowerCase().contains(filter.toLowerCase()) ||
                  c.dialCode.contains(filter),
            )
            .toList(),

        // Hiển thị item đã chọn trên thanh dropdown
        dropdownBuilder: (context, selectedItem) => Text(
          selectedItem != null
              ? "${selectedItem.flag} ${selectedItem.name} (${selectedItem.code})"
              : l10n.select,
          style: TextStyle(fontSize: context.sp(14)),
        ),

        // Cấu hình menu chọn (thêm ô search và cách hiển thị từng dòng)
        popupProps: PopupProps.menu(
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              hintText: l10n.search,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
          itemBuilder: (context, item, isSelected, isHovered) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text("${item.flag} ${item.name} (${item.dialCode})"),
          ),
        ),

        onChanged: (value) {
          if (value != null) {
            setState(() => _customerCountryCode = value.code);
          }
        },
      ),
    );
  }

  String formatTime(String time) => time.split(':').take(2).join(':');

  Widget _buildExtraServicesSection(TrainState state, AppLocalizations l10n) {
    final depTrain = state.data.SelectedDepartureTrain;
    final retTrain = state.data.SelectedReturnTrain;
    final bool isGoFromSapa = state.form.DepartureCode == "S2";
    // Kiểm tra xem chuyến đi hoặc chuyến về có liên quan đến Sapa (S2) không
    final bool hasSapaGo =
        depTrain?.originStationObject?.code == "S2" ||
        depTrain?.destinationStationObject?.code == "S2";
    final bool hasSapaReturn =
        retTrain?.originStationObject?.code == "S2" ||
        retTrain?.destinationStationObject?.code == "S2";

    if (!hasSapaGo && !hasSapaReturn) return const SizedBox.shrink();

    return _buildInfoBox(
      title: "Dịch vụ bổ sung",
      description: "Dịch vụ xe buýt đưa đón tại Sapa (Ga Lào Cai)",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CHIỀU ĐI
          if (hasSapaGo)
            _buildDirectionalServiceItem(
              isGoFromSapa: isGoFromSapa,
              currentValue: _goServiceType,
              // Đã sửa: dùng _goServiceType
              controller: _hotelGoAddressController,
              onChanged: (val) => setState(() => _goServiceType = val!),
              l10n: l10n,
            ),

          // CHIỀU VỀ
          if (retTrain != null && hasSapaReturn) ...[
            const Divider(height: 32),
            _buildDirectionalServiceItem(
              isGoFromSapa: !isGoFromSapa,
              currentValue: _returnServiceType,
              // Đã sửa: dùng _returnServiceType
              controller: _hotelReturnAddressController,
              onChanged: (val) => setState(() => _returnServiceType = val!),
              l10n: l10n,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDirectionalServiceItem({
    required bool isGoFromSapa,
    required String currentValue,
    required TextEditingController controller,
    required ValueChanged<String?> onChanged,
    required AppLocalizations l10n,
  }) {
    // LOGIC NHẬN DIỆN HƯỚNG TỰ ĐỘNG
    String directionTitle = "";
    String hotelLabel = "";
    String hint = "";

    if (isGoFromSapa) {
      // Tàu đang ĐẾN Sapa
      directionTitle = "Đón từ Khách sạn tại Sapa ra Ga Lào Cai";
      hotelLabel = "Địa chỉ khách sạn để xe đến đón bạn ra ga *";
      hint = "Nhập địa chỉ khách sạn đón khách";
    } else {
      // Tàu đang RỜI Sapa
      directionTitle = "Đón từ Ga Lào Cai về Khách sạn tại Sapa";
      hotelLabel = "Địa chỉ khách sạn tại Sapa để xe đưa bạn về *";
      hint = "Nhập tên và địa chỉ khách sạn";
    }

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            directionTitle,
            style: TextStyle(
              fontSize: context.sp(13),
              fontWeight: FontWeight.bold,
              color: kTextColor,
            ),
          ),
          SizedBox(height: context.rh(10)),

          DropdownButtonFormField<String>(
            isExpanded: true,
            value: currentValue,
            decoration: _inputDecoration(
              context,
              "",
            ).copyWith(fillColor: Colors.white),
            items: [
              DropdownMenuItem(
                value: "none",
                child: Text(
                  "Không yêu cầu",
                  style: TextStyle(fontSize: context.sp(13)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              DropdownMenuItem(
                value: "bus",
                child: Text(
                  "Xe buýt trung chuyển: 130.000VND/khách/chuyến",
                  style: TextStyle(fontSize: context.sp(13)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                ),
              ),
            ],
            onChanged: onChanged,
          ),

          if (currentValue == "bus") ...[
            SizedBox(height: context.rh(16)),
            Text(
              hotelLabel,
              style: TextStyle(
                fontSize: context.sp(12),
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: context.rh(8)),
            _buildTextFormField(controller, hint, maxLines: 2),
          ],
        ],
      ),
    );
  }
}

class DashLine extends StatelessWidget {
  const DashLine({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        const dWidth = 4.0;
        final dCount = (boxWidth / (2 * dWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(
            dCount,
            (_) => SizedBox(
              width: dWidth,
              height: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.grey.shade400),
              ),
            ),
          ),
        );
      },
    );
  }
}
