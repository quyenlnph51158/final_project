import 'package:final_project/features/account/data/model/request/update_profile_request.dart';
import 'package:final_project/features/account/presentation/controller/auth_controller.dart';
import 'package:final_project/features/tour/presentation/screens/travel_booking_screen.dart';
import 'package:final_project/shared/footer/app_footer.dart';
import 'package:final_project/shared/header/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/image_link.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../../../../shared/header/custom_app_bar.dart';

enum ProfileTab { info, changePassword, tickets, gifts }

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileTab _currentTab = ProfileTab.info;
  bool _showCurrentPass = false;
  bool _showNewPass = false;
  bool _showConfirmPass = false;

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  String? _selectedGender;

  // Danh sách dữ liệu cho Dropdown
  final List<String> days = List.generate(
    31,
    (index) => (index + 1).toString().padLeft(2, '0'),
  );
  final List<String> months = List.generate(
    12,
    (index) => (index + 1).toString().padLeft(2, '0'),
  );
  final List<String> years = List.generate(
    DateTime.now().year - 1950 + 1,
    (index) => (1950 + index).toString(),
  );

  // Biến lưu trữ giá trị đang chọn
  String? selectedDay;
  String? selectedMonth;
  String? selectedYear;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthController>().state.user;

    // Khởi tạo TextControllers
    _nameController = TextEditingController(text: user?.name);
    _phoneController = TextEditingController(text: user?.phone);
    _emailController = TextEditingController(text: user?.email);
    _selectedGender = user?.gender ?? 'Nam';

    // Xử lý ngày sinh ban đầu từ String birthDate (ISO format YYYY-MM-DD)
    if (user?.birthDate != null && user!.birthDate!.isNotEmpty) {
      DateTime? parsedDate = DateTime.tryParse(user.birthDate!);
      if (parsedDate != null) {
        selectedDay = parsedDate.day.toString().padLeft(2, '0');
        selectedMonth = parsedDate.month.toString().padLeft(2, '0');
        selectedYear = parsedDate.year.toString();
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();

    return Scaffold(
      backgroundColor: kBackgroundColor,
      endDrawer: const AppDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CustomAppBar(
                image: ImageLink.logoAppHeaderBackgroundWhite,
                backgroundColor: kPrimaryColor,
              ),
              Padding(
                padding: EdgeInsets.all(context.padding),
                child: Column(
                  children: [
                    _buildMenuSection(context, authController),
                    SizedBox(height: context.rh(20)),
                    _buildPointsCard(
                      context,
                      authController.state.user?.points.toString() ?? '0',
                    ),
                    SizedBox(height: context.rh(20)),
                    if (_currentTab == ProfileTab.info)
                      _buildMainInfoForm(context)
                    else if (_currentTab == ProfileTab.changePassword)
                      _buildChangePasswordForm(context, authController)
                    else
                      Center(child: Text("Tính năng đang phát triển")),
                  ],
                ),
              ),
              SizedBox(height: context.rh(30)),
              AppFooter(),
            ],
          ),
        ),
      ),
    );
  }

  // PHẦN 1: FORM THÔNG TIN
  Widget _buildMainInfoForm(BuildContext context) {
    final controller = context.read<AuthController>();
    return Container(
      padding: EdgeInsets.all(context.padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.radius),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Thông tin tài khoản khách hàng",
            style: TextStyle(
              fontSize: context.sp(18),
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(height: context.rh(30)),

          // Avatar
          Center(
            child: Container(
              width: context.rw(100),
              height: context.rw(100),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(context.radius),
              ),
              child: Center(
                child: Text(
                  _getInitials(_nameController.text),
                  style: TextStyle(
                    fontSize: context.sp(32),
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: context.rh(24)),

          _buildLabel(context, "Họ và tên", isRequired: true),
          _buildTextField(context, controller: _nameController),

          _buildLabel(context, "Số điện thoại", isRequired: true),
          _buildTextField(context, controller: _phoneController),

          _buildLabel(context, "Email", isRequired: true),
          _buildTextField(context, controller: _emailController),

          _buildLabel(context, "Giới tính", isRequired: true),
          Row(
            children: [
              _buildRadio(context, "male", "Nam"),
              _buildRadio(context, "female", "Nữ"),
              _buildRadio(context, "other", "Khác"),
            ],
          ),

          _buildLabel(context, "Ngày sinh", isRequired: true),
          // Dropdown Ngày
          _buildDropdown(
            context,
            hint: 'Chọn ngày',
            items: days,
            value: selectedDay,
            onChanged: (val) => setState(() => selectedDay = val),
          ),
          SizedBox(height: context.rh(10)),
          // Dropdown Tháng
          _buildDropdown(
            context,
            hint: 'Chọn tháng',
            items: months,
            value: selectedMonth,
            onChanged: (val) => setState(() => selectedMonth = val),
          ),
          SizedBox(height: context.rh(10)),
          // Dropdown Năm
          _buildDropdown(
            context,
            hint: 'Chọn năm',
            items: years,
            value: selectedYear,
            onChanged: (val) => setState(() => selectedYear = val),
          ),

          SizedBox(height: context.rh(30)),
          SizedBox(
            width: double.infinity,
            height: context.rh(50),
            child: ElevatedButton(
              onPressed: () async {
                FocusScope.of(context).unfocus();
                // Thu thập dữ liệu để lưu
                final String fullName = _nameController.text;
                final String? dob =
                    (selectedDay != null &&
                        selectedMonth != null &&
                        selectedYear != null)
                    ? "$selectedDay-$selectedMonth-$selectedYear"
                    : null;
                final String email = _emailController.text;
                final String gender = _selectedGender ?? '';
                final String phone = _phoneController.text;
                final request = UpdateProfileRequest(
                  name: fullName,
                  phone: phone,
                  email: email,
                  gender: gender,
                  birthDay: dob ?? '',
                );
                final success = await controller.updateProfile(
                  request: request,
                );
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Thành công!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        controller.state.ui.error ?? "Lưu thất bại !!!",
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.rw(25)),
                ),
              ),
              child: Text(
                "Lưu thông tin",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: context.sp(16),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChangePasswordForm(
    BuildContext context,
    AuthController authController,
  ) {
    return Container(
      padding: EdgeInsets.all(context.padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.radius),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Đổi mật khẩu",
            style: TextStyle(
              fontSize: context.sp(18),
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(height: context.rh(30)),

          _buildLabel(context, "Mật khẩu hiện tại", isRequired: true),
          _buildTextField(
            context,
            controller: authController.currentPassController,
            isPassword: true,
            obscureText: !_showCurrentPass,
            onSuffixIconPressed: () =>
                setState(() => _showCurrentPass = !_showCurrentPass),
          ),

          _buildLabel(context, "Mật khẩu mới", isRequired: true),
          _buildTextField(
            context,
            controller: authController.newPassController,
            isPassword: true,
            obscureText: !_showNewPass,
            onSuffixIconPressed: () =>
                setState(() => _showNewPass = !_showNewPass),
          ),

          _buildLabel(context, "Xác nhận mật khẩu mới", isRequired: true),
          _buildTextField(
            context,
            controller: authController.confirmPassController,
            isPassword: true,
            obscureText: !_showConfirmPass,
            onSuffixIconPressed: () =>
                setState(() => _showConfirmPass = !_showConfirmPass),
          ),

          SizedBox(height: context.rh(30)),
          SizedBox(
            width: double.infinity,
            height: context.rh(50),
            child: ElevatedButton(
              onPressed: () async {
                bool success = await authController.changePasswordApp();
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Thành công!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                  setState(
                    () => _currentTab = ProfileTab.info,
                  ); // Đổi xong thì quay về tab thông tin
                }
                else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(authController.state.ui.error ?? "Đổi mật khẩu thất bại !!!"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
              child: const Text(
                "Cập nhật mật khẩu",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // PHẦN 2: MENU
  Widget _buildMenuSection(BuildContext context, AuthController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.radius),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildMenuItem(
            context,
            Icons.confirmation_number_rounded,
            "Vé của tôi",
            showTealArrow: true,
            onPressed: () => setState(() => _currentTab = ProfileTab.tickets),
          ),
          _buildMenuItem(
            context,
            Icons.person,
            "Thông tin tài khoản",
            onPressed: () => setState(() => _currentTab = ProfileTab.info),
          ),
          _buildMenuItem(
            context,
            Icons.card_giftcard,
            "Quà tặng của tôi",
            onPressed: () => setState(() => _currentTab = ProfileTab.gifts),
          ),
          _buildMenuItem(context, Icons.redeem, "Đổi quà", onPressed: () {}),
          _buildMenuItem(
            context,
            Icons.password,
            "Đổi mật khẩu",
            onPressed: () =>
                setState(() => _currentTab = ProfileTab.changePassword),
          ),
          _buildMenuItem(
            context,
            Icons.logout,
            "Đăng xuất",
            isLast: true,
            onPressed: () async {
              await controller.logOut();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TravelBookingScreen(),
                  ),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // PHẦN 3: ĐIỂM SỐ
  Widget _buildPointsCard(BuildContext context, String points) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.rw(20)),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F6F7),
        borderRadius: BorderRadius.circular(context.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tổng điểm bạn đang có:",
            style: TextStyle(color: Colors.grey, fontSize: context.sp(16)),
          ),
          SizedBox(height: context.rh(8)),
          Text(
            "$points điểm",
            style: TextStyle(
              color: kPrimaryColor,
              fontSize: context.sp(28),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildLabel(
    BuildContext context,
    String text, {
    bool isRequired = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: context.rh(16), bottom: context.rh(8)),
      child: RichText(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: context.sp(15),
          ),
          children: isRequired
              ? [
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  ),
                ]
              : [],
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    bool enabled = true,
    Color? fillColor,
    bool isPassword = false, // Thêm tham số này
    bool obscureText = false, // Thêm tham số này
    VoidCallback? onSuffixIconPressed, // Thêm tham số này
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      obscureText: obscureText,
      // Áp dụng ẩn/hiện
      style: TextStyle(fontSize: context.sp(15)),
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor ?? Colors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.rw(12),
          vertical: context.rh(12),
        ),
        // Thêm Icon mắt ở cuối ô nhập liệu
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                  size: context.icon(20),
                ),
                onPressed: onSuffixIconPressed,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.rw(8)),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.rw(8)),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.rw(8)),
          borderSide: BorderSide(color: kPrimaryColor),
        ),
      ),
    );
  }

  Widget _buildRadio(BuildContext context, String value, String text) {
    return Row(
      children: [
        SizedBox(
          width: context.rw(32),
          child: Radio<String>(
            value: value,
            groupValue: _selectedGender,
            activeColor: kPrimaryColor,
            onChanged: (val) {
              setState(() {
                _selectedGender = val;
              });
            },
          ),
        ),
        Text(text, style: TextStyle(fontSize: context.sp(14))),
        SizedBox(width: context.rw(8)),
      ],
    );
  }

  Widget _buildDropdown(
    BuildContext context, {
    required String hint,
    required List<String> items,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: context.rh(48),
      padding: EdgeInsets.symmetric(horizontal: context.rw(12)),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(context.rw(8)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: items.contains(value) ? value : null,
          hint: Text(
            hint,
            style: TextStyle(color: Colors.black87, fontSize: context.sp(15)),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: TextStyle(fontSize: context.sp(15))),
            );
          }).toList(),
          onChanged: onChanged,
          icon: const Icon(Icons.keyboard_arrow_down),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title, {
    bool isLast = false,
    bool showTealArrow = false,
    required ControllerCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.padding,
          vertical: context.rh(4),
        ),
        leading: Icon(icon, color: Colors.grey, size: context.icon(24)),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: context.sp(15),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: context.icon(16),
          color: showTealArrow ? kPrimaryColor : Colors.grey,
        ),
        onTap: onPressed,
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return "??"; // Nếu tên trống

    // Tách các từ trong tên
    List<String> nameParts = name.trim().split(" ");

    if (nameParts.length == 1) {
      // Nếu chỉ có 1 từ (ví dụ: "Admin") -> Lấy chữ cái đầu
      return nameParts[0][0].toUpperCase();
    } else {
      // Nếu có nhiều từ (ví dụ: "Nguyễn Văn An")
      // -> Lấy chữ cái đầu của từ đầu và từ cuối (N và A)
      return (nameParts.first[0] + nameParts.last[0]).toUpperCase();
    }
  }
}
