import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app_themes.dart';

class ThemeService extends GetxService {

  /// GetStorage 是 GetX 生态系统中的一个快速、轻量级、同步的键值对本地存储解决方案。
  /// 你可以把它看作是 shared_preferences 的一个更简单、更快速的替代品，
  /// 特别是对于 GetX 用户来说，它的集成更加无缝。
  final _box = GetStorage(); // GetStorage 实例
  final _keyThemeMode = 'themeMode';

  // final _keyCustomTheme = 'customTheme'; // 如果你有很多自定义主题

  // 当前主题模式 (浅色, 深色, 跟随系统)
  final Rx<ThemeMode> _themeMode = ThemeMode.system.obs;

  ThemeMode get themeMode => _themeMode.value;

  // 如果你有多个自定义主题，可以这样管理
  // final Rx<ThemeData> _currentTheme = AppThemes.lightTheme.obs;
  // ThemeData get currentTheme => _currentTheme.value;

  // 获取浅色和深色主题的 ThemeData 实例
  ThemeData get lightTheme => AppThemes.lightTheme;

  ThemeData get darkTheme => AppThemes.darkTheme;

  @override
  void onInit() {
    super.onInit();
    _loadThemeModeFromStorage();
  }

  // 从本地存储加载主题模式
  void _loadThemeModeFromStorage() {
    String? storedThemeMode = _box.read(_keyThemeMode);
    if (storedThemeMode != null) {
      if (storedThemeMode == 'light') {
        _themeMode.value = ThemeMode.light;
      } else if (storedThemeMode == 'dark') {
        _themeMode.value = ThemeMode.dark;
      } else {
        _themeMode.value = ThemeMode.system;
      }
    }
    // 更新 GetMaterialApp 的主题模式
    Get.changeThemeMode(_themeMode.value);
  }

  // 保存主题模式到本地存储
  Future<void> _saveThemeModeToStorage(ThemeMode mode) async {
    await _box.write(_keyThemeMode, mode
        .toString()
        .split('.')
        .last);
  }

  // 切换主题模式
  void switchThemeMode(ThemeMode mode) {
    _themeMode.value = mode;
    Get.changeThemeMode(mode); // 关键：这会更新 GetMaterialApp 的主题模式
    _saveThemeModeToStorage(mode);
  }

// // 如果你想要支持多个自定义主题之间的切换 (而不仅仅是 light/dark mode)
// void changeCustomTheme(ThemeData newTheme) {
//   _currentTheme.value = newTheme;
//   Get.changeTheme(newTheme); // 关键：这会直接改变当前使用的主题
//   // 你也需要保存这个选择
//   // _box.write(_keyCustomTheme, identifyTheme(newTheme)); // 你需要一个方法来识别主题
// }
}
