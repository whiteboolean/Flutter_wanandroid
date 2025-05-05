import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

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
                    'https://scontent-mnl1-2.xx.fbcdn.net/v/t39.'
                    '30808-6/464595230_974393431386660_6962317637162176165'
                    '_n.jpg?_nc_cat=100&ccb=1-7&_nc_sid=6ee11a&_nc_eui2='
                    'AeGQAHUZQlaoCOFt3QdpN2zl7pKd_vh2RdXukp3--HZF1T48flL'
                    'UDV17nDKTBtR9UxGL4yHXzHOwR_fpVm5zKVmO&_nc_ohc=cCei6L'
                    'pC4_sQ7kNvwGNiY_n&_nc_oc=AdkJsOWifoetjep9Wu5pHhIfz'
                    '-NJqdFYoutt_nS_7W2leh0TJtcD1HV-grE_KTiRh6o&_nc_zt=23&_n'
                    'c_ht=scontent-mnl1-2.xx&_nc_gid=e87z7FLroqIh6LSVpOAFXQ&o'
                    'h=00_AfFccHdV_AaEsfyWvOYY6cTEoV4N6wJAbitV-fogUsjJsA&oe=6818E952',
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
