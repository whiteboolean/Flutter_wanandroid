import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:untitled6/controller/LoginRegisterController.dart';

import '../utils/CurvePainter.dart';
import 'LoginForm.dart';
import 'RegisterForm.dart';

class LoginAndRegisterPage extends StatelessWidget {
  LoginAndRegisterPage({super.key});

  final controller = Get.put(LoginRegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        leading: Icon(Icons.close_rounded,color: Colors.white,).onTap(() {
          Navigator.of(context).pop();
        }),
        backgroundColor: Color(0xFF5380ed),
      ),
      body: ListView(
        children: [
          CustomPaint(
            painter: CurvePainter(),
            child: SizedBox(
              height: 230,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      "assets/images/dudu3.webp",
                      // Replace with your image asset path
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text("Welcome To Use!")
                      .textColor(Colors.white)
                      .fontSize(24)
                      .paddingTop(20)
                      .paddingBottom(15),
                  Text(
                    "This App Is Developed By GungDing·Snoop !",
                  ).textColor(Colors.white).fontSize(18).paddingBottom(20),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 420,
            child: PageView(
              controller: controller.pageController,
              onPageChanged: (index) => controller.currentPage.value = index,
              children: [
                LoginForm(controller: controller),
                RegisterForm(controller: controller),
              ],
            ),
          ).paddingTop(30),
        ],
      ),
    );
  }
}
