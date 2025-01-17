import 'package:get/get.dart';
import 'package:weather_app/screens/home_screen/home_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeScreen(),
    ),
  ];
}
