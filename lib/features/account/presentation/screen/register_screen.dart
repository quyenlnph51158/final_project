import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:final_project/core/utils/responsive_layout.dart';
import 'package:final_project/features/account/presentation/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isObscurePw = true;
  bool _isObscureConfirmPw = true;

  // Màu chủ đạo đồng bộ
  final Color primaryColor = const Color(0xFF006677);

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AuthController>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          // Sử dụng context.padding (12 hoặc 16) để lề luôn thẳng với AppBar/Card toàn app
          padding: EdgeInsets.symmetric(horizontal: context.padding),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Khoảng cách đỉnh (Thay h(6) bằng rh(48))
              SizedBox(height: context.rh(48)),

              // Tiêu đề: Đăng ký
              Text(
                l10n.register,
                style: TextStyle(
                  fontSize: context.sp(26),
                  // sp() giúp font không vỡ trên máy thật
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D2D2D),
                  letterSpacing: -0.5,
                ),
              ),

              SizedBox(height: context.rh(32)),

              // 1. Họ và tên
              _buildTextField(
                controller: controller.registerNameController,
                hintText: l10n.fullName,
                icon: Icons.person_outline,
              ),
              SizedBox(height: context.rh(12)),

              // 2. Số điện thoại
              _buildTextField(
                controller: controller.registerPhoneNumberController,
                hintText: l10n.yourPhoneNumber,
                icon: Icons.phone_android_outlined,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: context.rh(12)),

              // 3. Mật khẩu
              _buildTextField(
                controller: controller.registerPasswordController,
                hintText: l10n.passWord,
                icon: Icons.lock_outline,
                isPassword: true,
                isObscure: _isObscurePw,
                onToggleVisibility: () =>
                    setState(() => _isObscurePw = !_isObscurePw),
              ),
              SizedBox(height: context.rh(12)),

              // 4. Nhập lại mật khẩu
              _buildTextField(
                controller: controller.registerConfirmPasswordController,
                hintText: l10n.confirmPassword,
                icon: Icons.lock_reset_outlined,
                isPassword: true,
                isObscure: _isObscureConfirmPw,
                onToggleVisibility: () =>
                    setState(() => _isObscureConfirmPw = !_isObscureConfirmPw),
              ),

              SizedBox(height: context.rh(32)),

              // Nút Tạo tài khoản
              SizedBox(
                width: double.infinity,
                // Chiều cao nút 48-50px chuẩn Touch Target
                height: context.rh(48).clamp(45.0, 55.0),
                child: ElevatedButton(
                  onPressed: () async {
                    _handleRegister(context, controller, l10n);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        context.radius * 2,
                      ), // Nút con nhộng
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    l10n.createAccount,
                    style: TextStyle(
                      fontSize: context.sp(16),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // Khoảng cách tới footer (Thay h(10) bằng rh(80))
              SizedBox(height: context.rh(80)),
              const Divider(color: Colors.black12, height: 1),
              SizedBox(height: context.rh(16)),

              // Footer: Đã có tài khoản?
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.alreadyAccount,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: context.sp(14),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(context.radius),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: context.rw(16),
                        vertical: context.rh(8),
                      ),
                    ),
                    child: Text(
                      l10n.login,
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: context.sp(14),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.rh(20)),
            ],
          ),
        ),
      ),
    );
  }

  // --- LOGIC XỬ LÝ ĐĂNG KÝ ---
  void _handleRegister(
    BuildContext context,
    AuthController controller,
    AppLocalizations l10n,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF006677)),
      ),
    );

    bool isSuccess = await controller.register();
    if (mounted) Navigator.pop(context);

    _showResultDialog(
      context,
      isSuccess ? l10n.success : l10n.fail,
      controller.state.registerState.apiResponseRegister ?? "Thông báo",
      isSuccess ? Icons.check_circle_outline : Icons.error_outline,
      isSuccess ? primaryColor : Colors.red,
      isSuccess: isSuccess,
    );
  }

  // --- TEXTFIELD HELPER ---
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    bool isObscure = false,
    VoidCallback? onToggleVisibility,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      keyboardType: keyboardType,
      style: TextStyle(fontSize: context.sp(15)),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontSize: context.sp(14),
        ),
        prefixIcon: Icon(icon, color: Colors.grey, size: context.icon(22)),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isObscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Colors.grey,
                  size: context.icon(20),
                ),
                onPressed: onToggleVisibility,
              )
            : null,
        // Content padding dùng rh để đảm bảo độ cao ô nhập liệu vừa mắt
        contentPadding: EdgeInsets.symmetric(vertical: context.rh(14)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.radius),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.radius),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.radius),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
    );
  }

  void _showResultDialog(
    BuildContext context,
    String title,
    String msg,
    IconData icon,
    Color color, {
    required bool isSuccess,
  }) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.radius * 1.5),
        ),
        title: Column(
          children: [
            Icon(icon, color: color, size: context.icon(50)),
            SizedBox(height: context.rh(12)),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: context.sp(18),
              ),
            ),
          ],
        ),
        content: Text(
          msg,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: context.sp(14)),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            height: context.rh(40),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.radius),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                if (isSuccess) Navigator.pop(context);
              },
              child: Text(
                l10n.agree,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
