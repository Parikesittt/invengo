import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  static const String isLogin = "isLogin";
  static const String userId = "userId";
  static const String _tokenKey = "tokenKey";
  static const String username = "username";

  static saveLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(isLogin, value);
  }

  static getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLogin);
  }

  static removeLogin() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(isLogin);
    prefs.remove(username);
    prefs.remove(userId);
  }

  static Future<void> saveToken(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, value);
  }

  static Future<void> saveUserData(String id, String usn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userId, id);
    await prefs.setString(username, usn);

  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    String? usn = prefs.getString(username);
    return usn;
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(userId);
  }

  static Future<String?> getUserIdFirebase() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userId);
  }
}
