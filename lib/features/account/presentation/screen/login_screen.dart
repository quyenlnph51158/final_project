import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:final_project/features/account/presentation/controller/auth_controller.dart';
import 'package:final_project/features/account/presentation/screen/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/responsive_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isObscure = true;
  final Color primaryColor = const Color(0xFF006677); // Xanh cổ vịt

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AuthController>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          // Sử dụng context.padding để lề trái/phải đồng bộ toàn app
          padding: EdgeInsets.symmetric(horizontal: context.padding),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Khoảng cách đỉnh (Thay h(5) bằng rh(40))
              SizedBox(height: context.rh(40)),

              // Tiêu đề
              Text(
                l10n.login,
                style: TextStyle(
                  fontSize: context.sp(26),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D2D2D),
                  letterSpacing: -0.5,
                ),
              ),

              SizedBox(height: context.rh(32)),

              // 1. Ô nhập Tài khoản
              _buildTextField(
                controller: controller.accountTxtController,
                hintText: l10n.yourAccount,
                icon: Icons.account_box_outlined,
              ),

              SizedBox(height: context.rh(12)),

              // 2. Ô nhập Mật khẩu
              _buildTextField(
                controller: controller.passWordTxtController,
                hintText: l10n.passWord,
                icon: Icons.lock_outline,
                isPassword: true,
                isObscure: _isObscure,
                onToggleVisibility: () =>
                    setState(() => _isObscure = !_isObscure),
              ),

              // 3. Quên mật khẩu
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    l10n.forgotPassword,
                    style: TextStyle(
                      fontSize: context.sp(14),
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(height: context.rh(16)),

              // 4. Nút Đăng nhập
              SizedBox(
                width: double.infinity,
                // Chiều cao nút chuẩn 48-50px (đã scale)
                height: context.rh(48).clamp(45.0, 55.0),
                child: ElevatedButton(
                  onPressed: () => controller.loginApp(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(context.radius * 2),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    l10n.login,
                    style: TextStyle(
                      fontSize: context.sp(16),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // Khoảng cách giữa (Thay h(6) bằng rh(60))
              SizedBox(height: context.rh(60)),

              const Divider(color: Colors.black12, height: 1),

              SizedBox(height: context.rh(16)),

              // Footer: Đăng ký tài khoản
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.noAccountYet,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: context.sp(14),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
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
                      l10n.createAccount,
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

  // Helper build TextField để đồng bộ UI
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    bool isObscure = false,
    VoidCallback? onToggleVisibility,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? isObscure : false,
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
}
