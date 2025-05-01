// root_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// 为其他 Tab 创建简单的占位页面 (或者导入你已有的页面)
class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 注意：通常 Tab 页面的 AppBar 是放在各自页面内部，
      // 而不是放在 RootPage 的 Scaffold 里，除非所有 Tab 共用一个 AppBar
      // 这里为了简单，给占位页面一个 AppBar
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text('这是 $title 页面'),
      ),
    );
  }
}
