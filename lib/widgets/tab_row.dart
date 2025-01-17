import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/core/theme_controller.dart';
import '../core/text_styling.dart';
import '../screens/home_screen/controller/home_controller.dart';

class TabRowController extends GetxController {
  var selectedIndex = 0.obs;
}

class TabRow extends GetView<TabRowController> {
  TabRow({super.key});

  final homeController = Get.find<HomeController>();
  final themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                controller.selectedIndex.value = 0;
                homeController.getForecastData(days: 1);
              },
              child: Obx(
                () => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    style: TextStyle(
                      fontSize: controller.selectedIndex.value == 0 ? 20 : 16,
                      fontWeight: controller.selectedIndex.value == 0
                          ? FontWeight.bold
                          : FontWeight.w500,
                      decoration: controller.selectedIndex.value == 0
                          ? TextDecoration.underline
                          : TextDecoration.none,
                      color: themeController.isDarkMode.value == true
                          ? Colors.white
                          : Colors.black,
                    ),
                    child: Text(
                      "Today",
                      style: gStyle(
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                controller.selectedIndex.value = 1;
                homeController.getForecastData(days: 2);
              },
              child: Obx(
                () => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    style: TextStyle(
                      fontSize: controller.selectedIndex.value == 1 ? 20 : 16,
                      fontWeight: controller.selectedIndex.value == 1
                          ? FontWeight.bold
                          : FontWeight.w500,
                      decoration: controller.selectedIndex.value == 1
                          ? TextDecoration.underline
                          : TextDecoration.none,
                      color: themeController.isDarkMode.value == true
                          ? Colors.white
                          : Colors.black,
                    ),
                    child: Text(
                      "Tomorrow",
                      style: gStyle(
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
