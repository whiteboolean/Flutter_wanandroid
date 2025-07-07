import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:untitled6/internationalization/translation_keys.dart';

import '../controller/AuthController.dart';
import '../main.dart';
import '../theme/theme_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final ThemeService themeService = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Text(TranslationKeys.settingsPageTitle.tr),
        centerTitle: true,
      ),
      body: Obx(() {
        return Column(
          children: [
            getButton(controller),
            ElevatedButton(
              onPressed: () {
                // 切换语言的逻辑
                var currentLocale = Get.locale;
                if (currentLocale?.languageCode == 'en') {
                  Get.updateLocale(const Locale('zh', 'CN'));
                } else {
                  Get.updateLocale(const Locale('en', 'US'));
                }
              },
              child: Text(TranslationKeys.changeLanguage.tr),
            ).width(200).height(50).paddingTop(20),

            Text('theme_mode'.tr),
            Obx(() => RadioListTile<ThemeMode>(
              title: Text('light'.tr),
              value: ThemeMode.light,
              groupValue: themeService.themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) themeService.switchThemeMode(value);
              },
            )),
            Obx(() => RadioListTile<ThemeMode>(
              title: Text('dark'.tr),
              value: ThemeMode.dark,
              groupValue: themeService.themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) themeService.switchThemeMode(value);
              },
            )),
            Obx(() => RadioListTile<ThemeMode>(
              title: Text('system'.tr),
              value: ThemeMode.system,
              groupValue: themeService.themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) themeService.switchThemeMode(value);
              },
            )),
          ],
        );
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
          child: Text(TranslationKeys.loginFirst.tr),
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
