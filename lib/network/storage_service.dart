import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;

  static const String THEME_KEY = 'theme_mode';
  static const String LAST_CITY_KEY = 'last_city';

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  Future<void> saveThemeMode(String themeMode) async {
    await _prefs.setString(THEME_KEY, themeMode);
  }

  String getThemeMode() {
    return _prefs.getString(THEME_KEY) ?? 'system';
  }

  Future<void> saveLastCity(String city) async {
    await _prefs.setString(LAST_CITY_KEY, city);
  }

  String? getLastCity() {
    return _prefs.getString(LAST_CITY_KEY);
  }
}
