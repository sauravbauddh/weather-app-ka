import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../network/storage_service.dart';

class ThemeController extends GetxController {
  final _storage = Get.find<StorageService>();
  var isDarkMode = true.obs;

  @override
  void onInit() {
    super.onInit();
    String savedTheme = _storage.getThemeMode();
    isDarkMode.value = savedTheme.isEmpty ? true : savedTheme == 'dark';
    if (isDarkMode.value) {
      Get.changeThemeMode(ThemeMode.dark);
      Get.changeTheme(ThemeData.dark());
    }
  }

  Future<void> switchToDarkTheme() async {
    isDarkMode.value = true;
    await _storage.saveThemeMode('dark');
    Get.changeThemeMode(ThemeMode.dark);
    Get.changeTheme(ThemeData.dark());
  }

  Future<void> switchToLightTheme() async {
    isDarkMode.value = false;
    await _storage.saveThemeMode('light');
    Get.changeThemeMode(ThemeMode.light);
    Get.changeTheme(ThemeData.light());
  }

  Future<void> toggleTheme() async {
    if (isDarkMode.value) {
      await switchToLightTheme();
    } else {
      await switchToDarkTheme();
    }
  }
}
