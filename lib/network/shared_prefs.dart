import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static const String ACCESS_TOKEN = 'ACCESS_TOKEN';
  static const String COUNT_SLIDE_TO_PICK = 'Slide_To_Pick';
  static const String COUNT_DOWN_ARROW = 'count_down_arrow';
  static const String REFRESH_TOKEN = 'REFRESH_TOKEN';

  static Future<SharedPreferences> _getPref() async {
    return await SharedPreferences.getInstance();
  }

  static Future<void> setTokens(String accessToken, String refreshToken) async {
    final pref = await _getPref();
    await pref.setString(ACCESS_TOKEN, accessToken);
    await pref.setString(REFRESH_TOKEN, refreshToken);
  }

  static Future<void> setCountSlideToPick(int count) async {
    final pref = await _getPref();
    await pref.setInt(COUNT_SLIDE_TO_PICK, count);
  }

  static Future<void> clearTokens() async {
    final pref = await _getPref();
    await pref.remove(ACCESS_TOKEN);
    await pref.remove(REFRESH_TOKEN);
    await pref.remove(SharedPref.ACCESS_TOKEN);
  }

  static Future<void> removeWithKey(String key) async {
    final pref = await _getPref();
    await pref.remove(key);
  }

  static Future<void> clearSharedPref() async {
    final pref = await _getPref();
    await pref.clear();
  }

  static Future<String> getUserGreetingSuffix() async {
    final pref = await _getPref();
    return "Ji";
  }

  static Future<String> getUserName() async {
    final pref = await _getPref();
    return "";
  }

  static Future<String?> getAccessToken() async {
    final pref = await _getPref();
    return pref.getString(ACCESS_TOKEN);
  }

  static Future<String?> getRefreshToken() async {
    final pref = await _getPref();
    return pref.getString(REFRESH_TOKEN);
  }

  static Future<void> setInt(int count, String name) async {
    final pref = await _getPref();
    await pref.setInt(name, count);
  }

  static Future<int> getInt(String name) async {
    final pref = await _getPref();
    return pref.getInt(name) ?? 0;
  }

  static getStringWithKey(store_id) {}
}
