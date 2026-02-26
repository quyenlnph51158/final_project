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

  try {
    // 3. Nạp file .env
    await dotenv.load(fileName: ".env");
    print("Cấu hình .env đã tải thành công");
  } catch (e) {
    print("Lỗi khi tải file .env: $e");
    // Bạn có thể quyết định dừng app hoặc chạy tiếp với giá trị mặc định
  }

  // 2. Thiết lập các hướng màn hình mong muốn (chỉ dọc)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TravelBookingController()),
          ChangeNotifierProvider(create: (_) => FlightController()),
          ChangeNotifierProvider(create: (_) => PolicyController()),
          ChangeNotifierProvider(create: (_) => NewsController()),
        ],
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Đặt Tour & Vé máy bay',
      theme: ThemeData(primarySwatch: Colors.blue),

      // 🔥 KHÔNG TẠO CONTROLLER TRONG SCREEN NỮA
      navigatorKey: NavigationService.navigatorKey,
      home: const TravelBookingScreen(),

      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: const [Locale('en', ''), Locale('vi', '')],
    );
  }
}
