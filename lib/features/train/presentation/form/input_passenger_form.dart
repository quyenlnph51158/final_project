import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:final_project/core/utils/format_date.dart';
import 'package:final_project/core/utils/format_duration.dart';
import 'package:final_project/core/utils/remove_diacritics_formatter.dart';
import 'package:final_project/features/train/data/models/seat_class.dart';
import 'package:final_project/features/train/data/models/train_booking_request/create_booking_request.dart';
import 'package:final_project/features/train/data/models/train_model.dart';
import 'package:final_project/features/train/presentation/screens/train_booking_summary_screen.dart';
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

class InputPassengerForm extends StatefulWidget {
  const InputPassengerForm({super.key});

  @override
  State<InputPassengerForm> createState() => _PassengerInfoFormState();
}

class _PassengerInfoFormState extends State<InputPassengerForm> {
  // --- CONTROLLERS ---
  final Map<String, TextEditingController> _dateControllers = {};
  final Map<String, TextEditingController> _firstNameControllers = {};
  final Map<String, TextEditingController> _lastNameControllers = {};
  final Map<String, TextEditingController> _passportControllers = {};

  final TextEditingController _customerName = TextEditingController();
  final TextEditingController _customerPhoneNumber = TextEditingController();
  final TextEditingController _customerEmail = TextEditingController();
  final TextEditingController _specialRequestController =
      TextEditingController();
  final Map<String, String> _nationalityValues = {};

  // Dịch vụ bổ sung
  final TextEditingController _hotelGoAddressController =
      TextEditingController();
  final TextEditingController _hotelReturnAddressController =
      TextEditingController();

  String _customerCountryCode = '';
  String? _selectedBusDeparture; // Chiều đi
  String? _selectedBusReturn; // Chiều về

  bool _showSpecialRequest = false;

  @override
  void dispose() {
    for (var c in _dateControllers.values) {
      c.dispose();
    }
    for (var c in _firstNameControllers.values) {
      c.dispose();
    }
    for (var c in _lastNameControllers.values) {
      c.dispose();
    }
    for (var c in _passportControllers.values) {
      c.dispose();
    }
    _customerName.dispose();
    _customerPhoneNumber.dispose();
    _customerEmail.dispose();
    _specialRequestController.dispose();
    _hotelGoAddressController.dispose();
    _hotelReturnAddressController.dispose();
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
    final trainController = context.watch<TrainController>();
    final state = trainController.state;
    final int adultCount = state.form.adultCount;
    final int childCount = state.form.childCount;
    final int infantCount = state.form.infantCount;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      color: kBackgroundColor,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.rh(16)),

              // 1. TÓM TẮT LỘ TRÌNH
              Text(
                l10n.trip_information,
                style: TextStyle(
                  fontSize: context.sp(18),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1D2939),
                ),
              ),
              SizedBox(height: context.rh(12)),
              _buildTripCard(
                state.data.SelectedDepartureTrain!,
                state.data.SelectedDepartureSeatClass!,
                state.data.SelectedReturnTrain,
                state.data.SelectedReturnSeatClass,
                l10n,
              ),

              SizedBox(height: context.rh(24)),

              // 2. NHẬP THÔNG TIN HÀNH KHÁCH
              Text(
                l10n.enter_passenger_info,
                style: TextStyle(
                  fontSize: context.sp(18),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1D2939),
                ),
              ),
              SizedBox(height: context.rh(12)),

              _buildInfoBox(
                title: l10n.personal_info,
                description: l10n.passenger_name_note,
                child: Column(
                  children: [
                    for (int i = 1; i <= adultCount; i++)
                      _buildPassengerInputGroup(
                        context,
                        '${l10n.adult} $i',
                        i,
                        'adults',
                        l10n,
                      ),
                    for (int i = 1; i <= childCount; i++)
                      _buildPassengerInputGroup(
                        context,
                        '${l10n.child} $i',
                        i,
                        'children',
                        l10n,
                      ),
                    for (int i = 1; i <= infantCount; i++)
                      _buildPassengerInputGroup(
                        context,
                        '${l10n.infant} $i',
                        i,
                        'infant',
                        l10n,
                      ),
                  ],
                ),
              ),

              SizedBox(height: context.rh(20)),

              // 3. KHỐI THÔNG TIN LIÊN HỆ
              _buildInfoBox(
                title: l10n.contact_info,
                description: l10n.contact_note,
                child: _buildContactSection(context, l10n),
              ),

              SizedBox(height: context.rh(20)),

              // 4. DỊCH VỤ BỔ SUNG (Logic mới)
              _buildAdditionalServices(context, l10n),

              SizedBox(height: context.rh(32)),

              // 5. NÚT TIẾP TỤC
              _buildContinueButton(context, l10n),

              SizedBox(height: context.rh(40)),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI COMPONENTS ---

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
            price: '${depS.price}',
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
              price: '${retS.price}',
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
    required String price,
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
                price,
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

  Widget _buildContactSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        _buildInputField(
          l10n.country_code,
          child: _buildCountryPicker(context, l10n),
        ),

        SizedBox(width: context.rh(12)),
        _buildInputField(
          l10n.phone_number,
          child: TextField(
            controller: _customerPhoneNumber,
            decoration: _inputDecoration(context, l10n.phone_number),
            keyboardType: TextInputType.phone,
            style: TextStyle(fontSize: context.sp(14)),
          ),
        ),

        SizedBox(height: context.rh(12)),
        _buildInputField(
          'Tên khách hàng liên hệ',
          child: TextField(
            controller: _customerName,
            decoration: _inputDecoration(context, "Nhập họ tên"),
            style: TextStyle(fontSize: context.sp(14)),
          ),
        ),
        SizedBox(height: context.rh(12)),
        _buildInputField(
          l10n.email,
          child: TextField(
            controller: _customerEmail,
            decoration: _inputDecoration(context, l10n.email),
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(fontSize: context.sp(14)),
          ),
        ),
        SizedBox(height: context.rh(8)),
        Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: _showSpecialRequest,
                activeColor: kPrimaryColor,
                onChanged: (bool? value) {
                  setState(() {
                    _showSpecialRequest = value ?? false;
                  });
                },
              ),
            ),
            SizedBox(width: context.rw(8)),
            GestureDetector(
              onTap: () {
                setState(() {
                  _showSpecialRequest = !_showSpecialRequest;
                });
              },
              child: Text(
                "Tôi có yêu cầu đặc biệt", // Bạn có thể thêm vào l10n nếu cần
                style: TextStyle(
                  fontSize: context.sp(13),
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
        if (_showSpecialRequest) ...[
          SizedBox(height: context.rh(12)),

          _buildInputField(
            l10n.special_request,
            child: TextField(
              controller: _specialRequestController,
              decoration: _inputDecoration(context, l10n.request_content),
              maxLines: 3,
              style: TextStyle(fontSize: context.sp(14)),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAdditionalServices(BuildContext context, AppLocalizations l10n) {
    return _buildInfoBox(
      title: "Dịch vụ bổ sung",
      description: "Dịch vụ đưa đón bằng xe buýt",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CHIỀU ĐI
          Text(
            "Ga Lào Cai đến Trung tâm Sapa (hoặc bán kính 2km)",
            style: TextStyle(fontSize: context.sp(13), color: Colors.black87),
          ),
          SizedBox(height: context.rh(8)),
          _buildDropdownField(
            context,
            value: _selectedBusDeparture,
            hint: "Chọn dịch vụ chiều đi",
            items: ["Ga Lào Cai đi Trung tâm Sapa - 5.00 USD/khách"],
            onChanged: (val) => setState(() => _selectedBusDeparture = val),
          ),

          // Logic: Chỉ hiện ô nhập khi đã chọn dịch vụ
          if (_selectedBusDeparture != null) ...[
            SizedBox(height: context.rh(16)),
            _buildLabelWithAsterisk(
              "Tên hoặc địa chỉ khách sạn ở Sapa (Chiều đi)",
            ),
            SizedBox(height: context.rh(8)),
            TextField(
              controller: _hotelGoAddressController,
              maxLines: 2,
              decoration: _inputDecoration(
                context,
                "Nhập địa chỉ khách sạn tại Sapa",
              ),
              style: TextStyle(fontSize: context.sp(13)),
            ),
          ],

          Padding(
            padding: EdgeInsets.symmetric(vertical: context.rh(20)),
            child: const Divider(thickness: 1, color: Color(0xFFEEEEEE)),
          ),

          // CHIỀU VỀ
          Text(
            "Trung tâm Sapa đến Ga Lào Cai",
            style: TextStyle(fontSize: context.sp(13), color: Colors.black87),
          ),
          SizedBox(height: context.rh(8)),
          _buildDropdownField(
            context,
            value: _selectedBusReturn,
            hint: "Chọn dịch vụ chiều về",
            items: ["Trung tâm Sapa đi Ga Lào Cai - 5.00 USD/khách"],
            onChanged: (val) => setState(() => _selectedBusReturn = val),
          ),

          // Logic: Chỉ hiện ô nhập khi đã chọn dịch vụ
          if (_selectedBusReturn != null) ...[
            SizedBox(height: context.rh(16)),
            _buildLabelWithAsterisk(
              "Tên hoặc địa chỉ khách sạn ở Sapa (Chiều về)",
            ),
            SizedBox(height: context.rh(8)),
            TextField(
              controller: _hotelReturnAddressController,
              maxLines: 2,
              decoration: _inputDecoration(
                context,
                "Nhập địa chỉ khách sạn tại Sapa",
              ),
              style: TextStyle(fontSize: context.sp(13)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLabelWithAsterisk(String text) {
    return Text.rich(
      TextSpan(
        text: "$text ",
        style: TextStyle(fontSize: context.sp(13), color: Colors.black87),
        children: const [
          TextSpan(
            text: "*",
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerInputGroup(
    BuildContext context,
    String label,
    int index,
    String passengerType,
    AppLocalizations l10n,
  ) {
    final String key = "${passengerType}_${index}";
    if (!_firstNameControllers.containsKey(key))
      _firstNameControllers[key] = TextEditingController();
    if (!_lastNameControllers.containsKey(key))
      _lastNameControllers[key] = TextEditingController();
    if (!_passportControllers.containsKey(key))
      _passportControllers[key] = TextEditingController();
    if (!_nationalityValues.containsKey(key))
      _nationalityValues[key] = 'VN'; // Mặc định là Việt Nam
    final dateController = _getController(key);

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
        _buildInputField(
          l10n.select_salutation,
          child: DropdownButtonFormField<String>(
            decoration: _inputDecoration(context, l10n.salutationMr),
            items: l10n.titles
                .split(',')
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) {},
          ),
        ),
        SizedBox(height: context.rh(12)),
        _buildInputField(
          l10n.titleFirstName,
          child: TextField(
            controller: _firstNameControllers[key],
            inputFormatters: [RemoveDiacriticsFormatter()],
            decoration: _inputDecoration(context, l10n.titleFirstName),
          ),
        ),
        SizedBox(height: context.rh(12)),
        _buildInputField(
          l10n.last_name,
          child: TextField(
            controller: _lastNameControllers[key],
            decoration: _inputDecoration(context, l10n.last_name),
            inputFormatters: [RemoveDiacriticsFormatter()],
          ),
        ),
        SizedBox(height: context.rh(12)),
        _buildInputField(
          l10n.passport_number,
          child: TextField(
            controller: _passportControllers[key],
            decoration: _inputDecoration(context, l10n.passport_number),
          ),
        ),
        SizedBox(height: context.rh(12)),
        _buildInputField(
          l10n.birthday,
          child: TextField(
            controller: dateController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(8),
              DateInputFormatter(),
            ],
            decoration: _inputDecoration(context, 'dd/mm/yyyy').copyWith(
              suffixIcon: Icon(
                Icons.calendar_today_outlined,
                size: context.icon(18),
                color: Colors.grey,
              ),
            ),
          ),
        ),
        SizedBox(height: context.rh(12)),

        // 5. QUỐC TỊCH (MỚI THÊM)
        _buildInputField(
          "Quốc tịch",
          child: DropdownButtonFormField<String>(
            value: _nationalityValues[key],
            isExpanded: true,
            decoration: _inputDecoration(context, "Chọn quốc tịch"),
            icon: Icon(Icons.keyboard_arrow_down, size: context.icon(20)),
            items: CountryCodeData.countries.map((country) {
              return DropdownMenuItem<String>(
                value: country.code, // Lưu mã quốc gia (VN, US, JP...)
                child: Text(
                  "${country.flag} ${country.name}",
                  style: TextStyle(fontSize: context.sp(13)),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (val) {
              setState(() {
                _nationalityValues[key] = val!;
              });
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: context.rh(16)),
          child: const Divider(height: 1),
        ),
      ],
    );
  }

  Widget _buildInputField(String label, {required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: context.sp(12), color: Colors.grey),
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
      child: Padding(
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
            SizedBox(height: context.rh(4)),
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
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context, AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      height: context.rh(48).clamp(45.0, 55.0),
      child: ElevatedButton(
        onPressed: () async {
          final trainController = context.read<TrainController>();
          final state = trainController.state;

          // 1. Thu thập danh sách hành khách
          List<PassengerModel> passengers = [];
          void addPassengers(String type, int count) {
            for (int i = 1; i <= count; i++) {
              final key = "${type}_${i}";
              String fullName =
                  "${_lastNameControllers[key]?.text.trim() ?? ''} ${_firstNameControllers[key]?.text.trim() ?? ''}"
                      .toUpperCase();
              passengers.add(
                PassengerModel(
                  name: fullName,
                  type: type,
                  birthday: _dateControllers[key]?.text ?? '',
                  passportNumber: _passportControllers[key]?.text ?? '',
                  nationnality: _nationalityValues[key] ?? '',
                ),
              );
            }
          }

          addPassengers('adults', state.form.adultCount);
          addPassengers('children', state.form.childCount);
          addPassengers('infant', state.form.infantCount);

          // 2. Thu thập dịch vụ bổ sung
          List<SpecialRequestModel> extraServices = [
            SpecialRequestModel(
              index: 1,
              address: _hotelGoAddressController.text,
            ),
            SpecialRequestModel(
              index: 2,
              address: _hotelReturnAddressController.text,
            ),
          ];

          // 3. Thực hiện đặt chỗ (Ví dụ logic gọi controller)
          await trainController.CreateBooking(
            passengers: passengers,
            CustomerName: _customerName.text,
            CustomerPhonNumber: _customerPhoneNumber.text,
            CustomerEmail: _customerEmail.text,
            CustomerCountryCode: _customerCountryCode,
            extraService: extraServices,
            customerNote: _showSpecialRequest == true
                ? _specialRequestController.text
                : '',
          );
          final updatedState = trainController.state;

          if (updatedState.data.summaryTrainResponseData != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TrainBookingSummaryScreen(),
              ),
            );
          }
          else{
            debugPrint('Lỗi tạo booking !!!');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.radius),
          ),
          elevation: 0,
        ),
        child: Text(
          l10n.continue_button,
          style: TextStyle(
            color: Colors.white,
            fontSize: context.sp(16),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

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

  Widget _buildDropdownField(
    BuildContext context, {
    required String hint,
    required List<String> items,
    String? value,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      decoration: _inputDecoration(context, hint),
      icon: Icon(Icons.keyboard_arrow_down, size: context.icon(20)),
      items: items
          .map(
            (s) => DropdownMenuItem(
              value: s,
              child: Text(s, style: TextStyle(fontSize: context.sp(13))),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildCountryPicker(BuildContext context, AppLocalizations l10n) {
    return SizedBox(
      height: context.rh(45).clamp(45.0, 55.0),
      child: DropdownSearch<CountryCodeModel>(
        items: (f, p) {
          if (f.isEmpty) return CountryCodeData.countries;
          final filteredList = CountryCodeData.countries.where((country) {
            final name = country.name.toLowerCase();
            final dialCode = country.dialCode.toLowerCase();
            final query = f.toLowerCase();
            return name.contains(query) || dialCode.contains(query);
          }).toList();
          return filteredList;
        },
        filterFn: (instance, filter) => true,
        compareFn: (i, s) => i.code == s.code,
        dropdownBuilder: (context, s) => Text(
          s != null ? "${s.flag} ${s.name} (${s.code})" : l10n.select,
          style: TextStyle(fontSize: context.sp(14)),
        ),
        popupProps: PopupProps.menu(
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              hintText: l10n.search,
              prefixIcon: const Icon(Icons.search),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              border: const OutlineInputBorder(),
            ),
          ),
          itemBuilder: (context, c, s, h) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Text(c.flag),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    c.name,
                    style: TextStyle(fontSize: context.sp(14)),
                  ),
                ),
                const SizedBox(width: 8),
                Text(c.dialCode),
              ],
            ),
          ),
        ),
        onChanged: (v) {
          if (v != null) setState(() => _customerCountryCode = v.code);
        },
      ),
    );
  }

  String formatTime(String time) {
    List<String> parts = time.split(':');
    return "${parts[0]}:${parts[1]}";
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
