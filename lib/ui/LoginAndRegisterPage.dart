import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:untitled6/controller/LoginRegisterController.dart';
import 'package:untitled6/ui/LoginRegisterForm.dart';

class LoginAndRegisterPage extends StatelessWidget {
  LoginAndRegisterPage({super.key});

  final controller = Get.put(LoginRegisterController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: const Icon(Icons.close_rounded, color: Colors.white).onTap(() {
          // 检查 widget 是否还在树中
          Navigator.of(context).pop();
        }),
      ),
      body: GetBuilder<LoginRegisterController>(
        builder: (controller) => LoginRegisterForm(controller: controller),
      ),
    );
  }
}
