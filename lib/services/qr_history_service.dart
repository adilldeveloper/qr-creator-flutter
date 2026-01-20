import 'package:shared_preferences/shared_preferences.dart';

class QrHistoryService {
  static const _key = 'qr_history';

  static Future<List<String>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    return list.reversed.toList();
  }

  static Future<void> add(String data) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    list.add(data);
    await prefs.setStringList(_key, list);
  }


  static Future<void> remove(String data) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    list.remove(data);
    await prefs.setStringList(_key, list);
  }


  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
