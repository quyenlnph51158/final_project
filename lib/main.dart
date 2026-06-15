import 'dart:ui';
import 'package:final_project/app/controller/payment_controller.dart';
import 'package:final_project/features/account/presentation/controller/auth_controller.dart';
import 'package:final_project/features/account/presentation/screen/login_screen.dart';
import 'package:final_project/features/train/presentation/controller/train_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:final_project/features/tour/presentation/screens/travel_booking_screen.dart';
import 'package:final_project/app/l10n/app_localizations.dart';
import 'core/navigation/navigation_service.dart';
import 'features/flight/presentation/controller/flight_controller.dart';
import 'features/policy/presentation/controller/news_controller.dart';
import 'features/policy/presentation/controller/policy_controller.dart';
import 'features/tour/presentation/controller/travel_booking_controller.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 1. Cấu hình Edge-to-Edge (Giải quyết lỗi 1 & 2)
  // Thiết lập chế độ tràn viền ngay khi khởi tạo
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Đặt thanh điều hướng và thanh trạng thái trong suốt để không bị lỗi "deprecated APIs"
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
      systemNavigationBarIconBrightness:
          Brightness.dark, // Hoặc Light tùy theme
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  try {
    // 3. Nạp file .env
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Lỗi khi tải file .env: $e");
    // Bạn có thể quyết định dừng app hoặc chạy tiếp với giá trị mặc định
  }
  // 2. GIẢI QUYẾT LỖI 3: Orientation (Xoay màn hình)
  // Để hỗ trợ Large Screen (Tablet/Foldables) theo yêu cầu Google:
  // Thay vì chỉ khóa dọc (portraitUp), hãy cho phép thêm các hướng khác nếu là máy tính bảng,
  // hoặc đơn giản là cho phép tất cả các hướng:
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()..init()),
        ChangeNotifierProvider(create: (_) => TravelBookingController()),
        ChangeNotifierProvider(create: (_) => FlightController()),
        ChangeNotifierProvider(create: (_) => PolicyController()),
        ChangeNotifierProvider(create: (_) => NewsController()),
        ChangeNotifierProvider(create: (_) => TrainController()),
        ChangeNotifierProvider(create: (_) => PaymentController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        final state = authController.state;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Đặt Tour & Vé máy bay',
          theme: ThemeData(
            useMaterial3: true, // Bắt buộc để hỗ trợ Edge-to-edge và UI hiện đại
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            appBarTheme: const AppBarTheme(
              elevation: 0,
              centerTitle: true,
            ),
          ),
          navigatorKey: NavigationService.navigatorKey,
          home: state.ui.isLoading
              ? const Scaffold(body: Center(child: CircularProgressIndicator()))
              : state.ui.isLoggedIn
              ? const TravelBookingScreen()
              : const LoginScreen(),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en', ''), Locale('vi', '')],
        );
      },
    );
  }
}
