import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  static Future<T?> push<T>(Route<T> route) {
    return navigatorKey.currentState!.push(route);
  }

  static Future<T?> pushReplacement<T>(Route<T> route) {
    return navigatorKey.currentState!.pushReplacement(route);
  }

  static void pop<T>([T? result]) {
    navigatorKey.currentState!.pop(result);
  }
  // --- THÊM HÀM NÀY VÀO ---
  static Future<T?> pushAndRemoveUntil<T>(Route<T> route, bool Function(Route<dynamic>) predicate) {
    return navigatorKey.currentState!.pushAndRemoveUntil(route, predicate);
  }
}
