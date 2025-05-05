import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:untitled6/AppImages.dart';

import '../controller/AuthController.dart';

class PersonalInfoPage extends StatelessWidget {
  const PersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    // --- 用户已登录时显示的 Widget ---
    // 获取当前用户信息 (注意处理可能为 null 的情况，虽然理论上 isLoggedIn 为 true 时不为 null)
    final user = authController.currentUser.value;
    final String nickname = user?.nickname ?? '已登录用户'; // 提供默认值
    print("当前保存的用户别名:$nickname");
    final String userId = user?.id.toString() ?? "";
    // 假设用户头像 URL 在 user.icon 或类似字段，否则用默认图标

    return Scaffold(
      appBar: AppBar(
        title: Text("个人资料").textColor(Colors.white),
        centerTitle: true,
        backgroundColor: Color(0xFF5380ed),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
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
                ).paddingVertical(30),
              ],
            ),
          ).backgroundColor(Color(0xFF5380ed)).paddingBottom(10),
          Row(
            children: [
              Expanded(
                child: Text(
                  "玩ID",
                ).fontSize(16).paddingHorizontal(15).paddingVertical(15),
              ),
              Text(userId).fontSize(16).paddingRight(20),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  "用户名",
                ).fontSize(16).paddingHorizontal(15).paddingVertical(15),
              ),
              Text(nickname).fontSize(16).paddingRight(20),
            ],
          ),
        ],
      ),
    );
  }
}
