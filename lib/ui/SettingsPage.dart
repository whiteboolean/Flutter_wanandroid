import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:getwidget/size/gf_size.dart';

import '../controller/AuthController.dart';
import '../main.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: Text("设置").textColor(Colors.white),
        centerTitle: true,
        backgroundColor: Color(0xFF5380ed),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        return getButton(controller);
      }),
    );
  }

  Widget getButton(AuthController controller) {
    if (!controller.isLoggedIn.value) {
      return Expanded(
        child: FButton(
          style: FButtonStyle.primary,
          prefix: Icon(FIcons.logIn),
          onPress: () {
            Get.toNamed(AppRoutes.loginAndRegister);
          },
          child: const Text('请先登录~'),
        ),
      ).paddingHorizontal(20).paddingTop(20);
    } else {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "退出登录",
                ).fontSize(16).paddingHorizontal(15).paddingVertical(15),
              ),
              Icon(Icons.chevron_right).paddingRight(15),
            ],
          ).onTap(() {
            Get.dialog(Center(child: CircularProgressIndicator()));
            controller.logout(
              callback: (successful) {
                // 可以在这里关闭加载指示器 (如果登录成功，AuthController 会导航走)
                if (Get.isDialogOpen ?? false) Get.back();
                if (successful) {
                  Get.snackbar("成功", "成功退出登录");
                  Get.offAllNamed(AppRoutes.loginAndRegister);
                } else {
                  Get.snackbar("失败", "退出登录失败");
                }
              },
            );
          }),
        ],
      );
    }
  }
}
