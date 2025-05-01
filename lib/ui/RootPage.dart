// root_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled6/MainListPage.dart';
import 'package:untitled6/controller/MainTabController.dart';

import 'MinePage.dart';
import 'PlaceholderPage.dart';
class RootPage extends StatelessWidget {
  RootPage({Key? key}) : super(key: key);

  // 找到或注入 MainTabController
  final MainTabController mainTabController = Get.find<MainTabController>();

  // 定义你的四个 Tab 页面列表
  final List<Widget> tabPages = [
    MainListPage(title:'首页'),
    const PlaceholderPage(title: '问答'),
    const PlaceholderPage(title: '体系'),
    const MinePage(title: '我的'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body 部分使用 Obx 包裹 IndexedStack，根据 currentIndex 显示对应的页面
      // IndexedStack 会保持所有页面的状态
      body: Obx(() => IndexedStack(
            index: mainTabController.currentPageIndex.value, // 绑定当前索引
            children: tabPages, // 显示的页面列表
          )),

      // 底部导航栏
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            // 获取当前的索引
            currentIndex: mainTabController.currentPageIndex.value,
            // 点击 Tab 时调用 Controller 的方法来改变索引
            onTap: mainTabController.changeTabIndex,
            // **重要:** 当 item 数量 >= 4 时，设置 type 为 fixed，否则会有位移效果
            type: BottomNavigationBarType.fixed,
            // 定义 Tab 按钮
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home), // 选中时的图标 (可选)
                label: '首页',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.question_answer_outlined),
                activeIcon: Icon(Icons.question_answer),
                label: '问答',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_tree_outlined),
                activeIcon: Icon(Icons.account_tree),
                label: '体系',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: '我的',
              ),
            ],
            // 可以设置选中和未选中的颜色 (可选)
            // selectedItemColor: Colors.blue,
            // unselectedItemColor: Colors.grey,
          )),
    );
  }
}