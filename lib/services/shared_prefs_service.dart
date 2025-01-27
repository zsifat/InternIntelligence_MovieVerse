import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      // Set 'isFirstTime' to false for subsequent calls
      await prefs.setBool('isFirstTime', false);
    }

    return isFirstTime;
  }
}

