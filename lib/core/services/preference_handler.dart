import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  static const String isLogin = "isLogin";
  static const String userId = "userId";
  static const String _tokenKey = "tokenKey";
  static const String username = "username";

  //Save data login pada saat login
  static saveLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(isLogin, value);
  }

  //Ambil data login pada saat mau login / ke dashboard
  static getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLogin);
  }

  //Hapus data login pada saat logout
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

    print('✅ User data saved: id=$id, username=$usn');
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    String? usn = prefs.getString(username);
    print('📦 Retrieved username: $usn');
    return usn;
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(userId);
  }
}
