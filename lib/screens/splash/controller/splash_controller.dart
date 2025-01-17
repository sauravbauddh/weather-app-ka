import 'package:get/get.dart';
import 'package:weather_app/routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    navigateToHome();
  }

  void navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2));
    Get.offAllNamed(AppRoutes.HOME);
  }
}
