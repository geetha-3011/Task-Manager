import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static const String keyName = 'user_name';
  static const String keyEmail = 'user_email';
  static const String keyUid = 'user_uid';

  static Future<void> saveUserData({
    required String name,
    required String email,
    required String uid,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyName, name);
    await prefs.setString(keyEmail, email);
    await prefs.setString(keyUid, uid);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyName);
  }

    static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyEmail);
  }

  static Future<String?> getUserUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyUid);
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyName);
    await prefs.remove(keyEmail);
    await prefs.remove(keyUid);
  }
}
