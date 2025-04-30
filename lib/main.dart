import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:untitled6/MainListPage.dart';
import 'package:untitled6/page1.dart';

import 'package:get/get.dart';
import 'package:untitled6/ui/WebViewPage.dart';

class AppRoutes {
  static const String webView = '/webView'; // 定义路由名称

  static final List<GetPage> routes = [
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
          initialRoute: '/', // 你的初始路由
          getPages: AppRoutes.routes, // 使用定义的路由列表
          home: const MyHomePage(title: '首页'),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: MainListPage(),
      ),
    );
  }
}
