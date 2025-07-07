import 'package:get/get.dart';
import 'translation_keys.dart'; // <--- 导入常量文件

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys =>
      {
        'en_US': {
          TranslationKeys.greeting: 'Hello!', // <--- 使用常量
          TranslationKeys.changeLanguage: 'Change Language',
          TranslationKeys.homePageTitle: 'Home Page',
          TranslationKeys.settingsPageTitle: 'Settings',
          TranslationKeys.themeMode: 'Theme Mode',
          TranslationKeys.system: 'System',
          TranslationKeys.light: 'Light',
          TranslationKeys.dark: 'Dark',
          TranslationKeys.loginButton: 'Login',
          TranslationKeys.loginFirst :'Please login first'
        },
        'zh_CN': {
          TranslationKeys.greeting: '你好!', // <--- 使用常量
          TranslationKeys.changeLanguage: '切换语言',
          TranslationKeys.homePageTitle: '首页',
          TranslationKeys.settingsPageTitle: '设置',
          TranslationKeys.themeMode: '主题模式',
          TranslationKeys.system: '跟随系统',
          TranslationKeys.light: '浅色',
          TranslationKeys.dark: '深色',
          TranslationKeys.loginButton: '登录',
          TranslationKeys.loginFirst :'请先登录'
        }
      };
}
