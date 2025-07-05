import 'dart:io';

import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled6/MainListPage.dart';
import 'package:untitled6/binding/LoginRegisterBinding.dart';
import 'package:untitled6/binding/RootBinding.dart';
import 'package:untitled6/page1.dart';

import 'package:get/get.dart';
import 'package:untitled6/ui/LoginAndRegisterPage.dart';
import 'package:untitled6/ui/PersonalInfoPage.dart';
import 'package:untitled6/ui/PlaceholderPage.dart';
import 'package:untitled6/ui/RootPage.dart';
import 'package:untitled6/ui/SettingsPage.dart';
import 'package:untitled6/ui/WebViewPage.dart';
import 'package:window_manager/window_manager.dart';

import 'binding/InitalBinding.dart';
import 'controller/AuthController.dart';

class AppRoutes {
  static const String root = '/'; // 可以将 RootPage 设为根路由
  static const String webView = '/webView'; // WebView页面
  static const String loginAndRegister = '/loginAndRegister'; // 登录注册页面
  static const String settings = '/settings'; // 设置页面
  static const String personalInfo = '/personalInfo'; // 个人信息

  static final List<GetPage> routes = [
    GetPage(name: root, page: () => RootPage(), binding: RootBinding()),

    // ... 你其他的 GetPage 定义
    GetPage(
      name: webView, // 使用定义的名称
      page: () => const WebViewPage(), // 创建 WebViewPage 实例
      // transition: Transition.rightToLeft, // 可以定义转场动画 (可选)
      // binding: WebViewBinding(), // 如果有专门的 Controller 和 Binding (可选)
    ),
    GetPage(
      name: loginAndRegister,
      page: () => LoginAndRegisterPage(),
      binding: LoginRegisterBinding(),
    ),
    GetPage(name: settings, page: () => SettingsPage()),
    GetPage(name: personalInfo, page: () => PersonalInfoPage()),
  ];
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 仅对桌面平台初始化
  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      minimumSize: Size(500, 500), // 设置最小宽高
      size: Size(600, 800), // 初始大小
      center: true, // 居中显示
      title: '玩安卓', // 窗口标题
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
  // *** 核心逻辑：在 runApp 之前确定初始路由 ***

  // 1. 手动执行初始化绑定 (确保 ApiClient 和 AuthController 被 put)
  //    注意：这里假设 InitialBinding 的 dependencies 是 async
  await InitialBinding().dependencies();
  print("Main: Initial Binding complete.");

  // 2. 获取已初始化的 AuthController 实例
  final AuthController authController = Get.find<AuthController>();

  // 3. 等待 AuthController 内部的 SharedPreferences 初始化完成
  await authController.waitUntilInitialized(); // 使用我们添加的等待方法
  print("Main: AuthController initialization confirmed.");

  // 4. 根据登录状态决定初始路由
  final String initialRoute =
      // authController.isLoggedIn.value
      //     ? AppRoutes
      //         .root // 已登录，去主页
      AppRoutes.root;
  print("Main: Initial route determined: $initialRoute");

  // 5. 运行 App，传入计算好的 initialRoute
  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute; // 接收动态确定的初始路由

  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

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
          title: '玩安卓',
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
          initialRoute: initialRoute,
          // 设置初始路由为我们在 AppRoutes 中定义的根路由 ('/')

          // initialBinding: InitialBinding(),

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
