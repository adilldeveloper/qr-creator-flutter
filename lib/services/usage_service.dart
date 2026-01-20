import 'package:shared_preferences/shared_preferences.dart';

class UsageService {
  static const int _dailyLimit = 3;

  /// Check if user can still use QR today
  static Future<bool> canUseToday() async {
    final prefs = await SharedPreferences.getInstance();

    final today = _today();
    final savedDate = prefs.getString('usage_date');
    final usedCount = prefs.getInt('usage_count') ?? 0;

    // New day → reset
    if (savedDate != today) {
      await prefs.setString('usage_date', today);
      await prefs.setInt('usage_count', 0);
      return true;
    }

    return usedCount < _dailyLimit;
  }

  /// Increase usage count
  static Future<void> increaseUsage() async {
    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt('usage_count') ?? 0;
    await prefs.setInt('usage_count', count + 1);
  }

  /// Called after rewarded ad → give 1 extra use
  static Future<void> rewardOneUse() async {
    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt('usage_count') ?? 0;

    if (count > 0) {
      await prefs.setInt('usage_count', count - 1);
    }
  }

  static String _today() {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }
}
