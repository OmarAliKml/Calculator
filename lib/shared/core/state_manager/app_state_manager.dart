import 'package:flutter/cupertino.dart';

import '../font/font_manager.dart';

class AppStateManager extends ChangeNotifier {
  static final AppStateManager _instance = AppStateManager._internal();

  static AppStateManager get instance => _instance;

  AppStateManager._internal();

  String fontFamily = FontManager.instance.fontFamily;

  Future<void> setup() async {
    await loadFont();
  }

  Future<void> loadFont() async {
    fontFamily = FontManager.instance.fontFamily;
    notifyListeners();
  }
}
