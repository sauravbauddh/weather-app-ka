import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppRoutes {
  AppRoutes._();

  ScrollController controller = ScrollController();
  static const initial = Routes.splash;

  static final routes = [
    // GetPage(
    //   name: Routes.trackOrderDetailsScreen,
    //   page: () => const TrackOrderDetailsScreen(),
    // ),
    // GetPage(
    //   name: Routes.payScreen,
    //   page: () => const PayScreen(),
    // ),
  ];

  static void toNamed(page, {arguement1, arguement2}) {
    Get.toNamed(page, arguments: [
      {"arguement1": arguement1, "argument2": arguement1}
    ]);
  }

  static void back() {
    Get.back();
  }

  static void offNamed(page) {
    Get.offNamed(page);
  }

  static void offAllNamed(page) {
    Get.offAllNamed(page);
  }
}

abstract class Routes {
  static const couponScreen = '/CouponScreen';
  static const cartSummarySection = '/CartSummarySection';
  static const splash = '/';
}
