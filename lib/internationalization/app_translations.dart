import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys =>
      {
        'en_US': {
          'greeting': 'Hello!',
          'change_language': 'Change Language',
          'home_page_title': 'Home Page',
          'settings_page_title': 'Settings',
          'theme_mode': 'Theme Mode',
          'system': 'System',
          'light': 'Light',
          'dark': 'Dark',
        },
        'zh_CN': {
          'greeting': '你好!',
          'change_language': '切换语言',
          'home_page_title': '首页',
          'settings_page_title': '设置',
          'theme_mode': '主题模式',
          'system': '跟随系统',
          'light': '浅色',
          'dark': '深色',
        }
        // 你可以添加更多语言，例如：
        // 'ja_JP': {
        //   'greeting': 'こんにちは!',
        //   'change_language': '言語を変更',
        // }
      };
}
