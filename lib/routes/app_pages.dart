import 'package:get/get.dart';
import 'package:weather_app/screens/home_screen/home_screen.dart';
import '../screens/splash/controller/splash_controller.dart';
import '../screens/splash/splash.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashScreen(),
      binding: BindingsBuilder(
        () {
          Get.put(SplashController());
        },
      ),
    ),
  ];
}
