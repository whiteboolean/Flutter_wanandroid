import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled6/AppImages.dart';
import 'package:untitled6/main.dart';
import 'package:untitled6/model/MyPair.dart';

import '../controller/AuthController.dart';

class MinePage extends GetView<AuthController> {
  final String title;

  const MinePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    // 创建一个空的 Widget 列表
    List<MyPair<String, IconData>> rows = [
      MyPair("我的积分", Icons.access_alarm_outlined),
      MyPair("我的分享", Icons.share),
      MyPair("我的收藏", Icons.collections_bookmark),
      MyPair("我的书签", Icons.bookmark),
      MyPair("阅读历史", Icons.history),
      MyPair("开源项目", Icons.production_quantity_limits_sharp),
      MyPair("关于作者", Icons.people),
      MyPair("系统设置", Icons.settings),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(title).textColor(Colors.white),
        backgroundColor: Color(0xFF5380ed),
      ),
      body: Obx(() {
        return Column(
          children: [
            getCurrentWidget(controller),

            /// ... (Spread Operator):
            /// 这是 Dart 中的展开运算符。它用于将一个列表中的元素展开，
            /// 并添加到另一个列表中。
            /// 在这里， 它将 List.generate 生成的列表中的所有 Widget 添加到 Column 的 children 列表中。
            ...List.generate(
              rows.length,
              (index) => getRow(rows[index].first, rows[index].second),
            ),
          ],
        );
      }),
    );
  }

  Widget getCurrentWidget(AuthController authController) {
    if (authController.isLoggedIn.value) {
      // --- 用户已登录时显示的 Widget ---
      // 获取当前用户信息 (注意处理可能为 null 的情况，虽然理论上 isLoggedIn 为 true 时不为 null)
      final user = authController.currentUser.value;
      final String nickname = user?.nickname ?? '已登录用户'; // 提供默认值
      print("当前保存的用户别名:$nickname");
      // 假设用户头像 URL 在 user.icon 或类似字段，否则用默认图标
      return SizedBox(
        width: double.infinity,
        child: GestureDetector(
          onTap: () {
            // Get.snackbar('提示', '跳转到登录/注册页面！');
            Get.toNamed(AppRoutes.personalInfo);
          },
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(55), // 设置圆角半径
                child: Image.network(
                  AppImages.profilePicture,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Text(nickname)
                  .fontSize(16)
                  .textColor(Colors.white)
                  .paddingTop(10)
                  .paddingBottom(50),
            ],
          ),
        ),
      ).backgroundColor(Color(0xFF5380ed)).paddingBottom(10);
    } else {
      return SizedBox(
        width: double.infinity,
        child: GestureDetector(
          onTap: () {
            // Get.snackbar('提示', '跳转到登录/注册页面！');
            Get.toNamed(AppRoutes.loginAndRegister);
          },
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(55), // 设置圆角半径
                child: Image.network(
                  AppImages.profilePicture1,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Text("Login First ~~~")
                  .fontSize(16)
                  .textColor(Colors.white)
                  .paddingTop(10)
                  .paddingBottom(50),
            ],
          ),
        ),
      ).backgroundColor(Color(0xFF5380ed)).paddingBottom(10);
    }
  }

  Widget getRow(var title, IconData icon) {
    return InkWell(
      onTap: () {
        switch (title) {
          case "我的积分":
            Get.toNamed(
              AppRoutes.webView, // 你的 WebView 路由名称
              arguments: {
                'url': "https://www.baidu.com",
                'title': title, // 使用 Banner 标题
              },
            );
            break;
          case "我的分享":
            Get.toNamed(
              AppRoutes.webView, // 你的 WebView 路由名称
              arguments: {
                'url': "https://www.baidu.com",
                'title': title, // 使用 Banner 标题
              },
            );
            break;
          case "我的收藏":
            Get.toNamed(
              AppRoutes.webView, // 你的 WebView 路由名称
              arguments: {
                'url': "https://www.baidu.com",
                'title': title, // 使用 Banner 标题
              },
            );
            break;
          case "我的书签":
            Get.toNamed(
              AppRoutes.webView, // 你的 WebView 路由名称
              arguments: {
                'url': "https://www.baidu.com",
                'title': title, // 使用 Banner 标题
              },
            );
            break;
          case "阅读历史":
            Get.toNamed(
              AppRoutes.webView, // 你的 WebView 路由名称
              arguments: {
                'url': "https://www.baidu.com",
                'title': title, // 使用 Banner 标题
              },
            );
            break;
          case "开源项目":
            Get.toNamed(
              AppRoutes.webView, // 你的 WebView 路由名称
              arguments: {
                'url': "https://www.baidu.com",
                'title': title, // 使用 Banner 标题
              },
            );
            break;
          case "关于作者":
            Get.toNamed(
              AppRoutes.webView, // 你的 WebView 路由名称
              arguments: {
                'url': "https://www.baidu.com",
                'title': title, // 使用 Banner 标题
              },
            );
            break;
          case "系统设置":
            Get.toNamed(
              AppRoutes.settings, // 你的 WebView 路由名称
            );
            break;
        }
      },
      child: Row(
        children: [
          Icon(icon).paddingHorizontal(10),
          Expanded(child: Text(title)),
          Icon(Icons.chevron_right).paddingRight(10),
        ],
      ).marginSymmetric(vertical: 13),
    );
  }
}
