import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FontManager extends ChangeNotifier {
  static final FontManager _instance = FontManager._internal();

  static FontManager get instance => _instance;

  FontManager._internal();

  String fontFamily = 'Robot';

  Future<void> setup() async {
    await loadFont();
  }

  Future<void> loadFont() async {
    final prefs = await SharedPreferences.getInstance();
    fontFamily = prefs.getString('fontFamily') ?? fontFamily;
    notifyListeners();
  }

  Future<void> save(String font) async {
    fontFamily = font;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fontFamily', font);
  }
}
