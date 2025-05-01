import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:untitled6/MainListPage.dart';
import 'package:untitled6/binding/RootBinding.dart';
import 'package:untitled6/page1.dart';

import 'package:get/get.dart';
import 'package:untitled6/ui/PlaceholderPage.dart';
import 'package:untitled6/ui/RootPage.dart';
import 'package:untitled6/ui/WebViewPage.dart';


class AppRoutes {
  static const String root = '/'; // 可以将 RootPage 设为根路由
  static const String webView = '/webView'; // 定义路由名称

  static final List<GetPage> routes = [
    GetPage(name: root, page: () => RootPage(), binding: RootBinding()),

    // ... 你其他的 GetPage 定义
    GetPage(
      name: webView, // 使用定义的名称
      page: () => const WebViewPage(), // 创建 WebViewPage 实例
      // transition: Transition.rightToLeft, // 可以定义转场动画 (可选)
      // binding: WebViewBinding(), // 如果有专门的 Controller 和 Binding (可选)
    ),
    // ... 其他路由
  ];
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return GetMaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          // 应用的标题，会显示在操作系统的任务管理器等地方
          title: '玩安卓 Flutter',
          // 你可以改成你的应用名称

          // 关闭右上角的 DEBUG 标签
          debugShowCheckedModeBanner: true,

          // 暗黑模式主题设置 (可选)
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark, // 设置为暗黑模式
            // 可以为暗黑模式定义不同的颜色
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple, // 可以使用相同的种子色
              brightness: Brightness.dark, // 确保指定亮度
            ),
            // ... 其他暗黑模式的特定主题设置
          ),

          // 主题模式选择 (例如，跟随系统、总是亮色、总是暗色)
          themeMode: ThemeMode.system,
          // 默认跟随系统设置

          // 初始路由名称，应用启动时首先加载这个路由对应的页面
          initialRoute: AppRoutes.root,
          // 设置初始路由为我们在 AppRoutes 中定义的根路由 ('/')

          // GetX 的路由配置列表
          getPages: AppRoutes.routes, // 使用从 app_routes.dart 导入的路由列表
          // 默认转场动画 (可选)
          // defaultTransition: Transition.native, // 使用平台默认的转场动画

          // 可以添加其他全局配置，例如默认的 Locale 等
          // locale: Locale('zh', 'CN'),
          // fallbackLocale: Locale('en', 'US'),
        );
      },
    );
  }
}

