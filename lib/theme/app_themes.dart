import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    // 主色板
    // primaryColor: Colors.blue, // 你可以直接定义 primaryColor
    scaffoldBackgroundColor: Colors.grey[100],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      iconTheme: IconThemeData(color: Colors.white),
    ),

    ///当 Text Widget 被构建且没有提供自定义 style 时，它会查找 DefaultTextStyle。
    ///•当你显式地从 Theme.of(context).textTheme 或 Get.textTheme 中获取并应用某个文本样式时。
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    ),
    // ... 其他浅色主题配置
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.teal,
    // 主色板
    // primaryColor: Colors.teal,
    scaffoldBackgroundColor: Colors.grey[850],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.teal,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
    ),
    // ... 其他深色主题配置
  );

// 你可以定义更多主题
// static final ThemeData redTheme = ThemeData(
//   primarySwatch: Colors.red,
//   // ...
// );
}
