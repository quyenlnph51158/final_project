import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:final_project/features/tour/presentation/screens/travel_booking_screen.dart';
import 'package:final_project/app/l10n/app_localizations.dart';
import 'core/navigation/navigation_service.dart';
import 'features/flight/presentation/controller/flight_controller.dart';
import 'features/policy/presentation/controller/news_controller.dart';
import 'features/policy/presentation/controller/policy_controller.dart';
import 'features/tour/presentation/controller/travel_booking_controller.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => TravelBookingController(),
        ),
        ChangeNotifierProvider(
          create: (_) => FlightController(),
        ),
        ChangeNotifierProvider(
          create: (_) => PolicyController(),
        ),
        ChangeNotifierProvider(create: (_) => NewsController()),
      ],
      child: const MyApp(),
    ),
  );
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

      supportedLocales: const [
        Locale('en', ''),
        Locale('vi', ''),
      ],
    );
  }
}
