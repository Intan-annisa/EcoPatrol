import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static const String keyLogin = "isLoggedIn";

  static Future<void> saveLoginStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyLogin, status);
  }

  static Future<bool> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyLogin) ?? false;
  }
}
