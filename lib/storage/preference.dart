import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  // ✅ SIMPAN STATUS LOGIN
  Future<void> storingIsLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLogin', value);
  }

  // ✅ AMBIL STATUS LOGIN
  Future<bool> getIsLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLogin') ?? false;
  }

  // ✅ SIMPAN TOKEN
  Future<void> storingToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // ✅ AMBIL TOKEN
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // ✅ LOGOUT (HAPUS DATA)
  Future<void> removeAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
