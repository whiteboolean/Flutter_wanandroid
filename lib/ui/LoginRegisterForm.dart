import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled6/controller/LoginRegisterController.dart';

import '../utils/CurvePainter.dart';

class LoginRegisterForm extends StatelessWidget {
  final LoginRegisterController controller;

  const LoginRegisterForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        CustomPaint(
          painter: CurvePainter(),
          child: SizedBox(
            height: 200,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    "assets/images/dudu3.webp",
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Text("Welcome To Use!")
                    .textColor(Colors.white)
                    .fontSize(24)
                    .paddingTop(10)
                    .paddingBottom(15),
                Text(
                  "This App Is Developed By WhiteBoolean !",
                ).textColor(Colors.white).fontSize(18).paddingBottom(20),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 40.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Email 输入框
                TextFormField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: '邮箱',
                    // 中文标签
                    hintText: '请输入你的邮箱',
                    // 中文提示文字
                    prefixIcon: Icon(Icons.email, color: Colors.grey),
                    // 蓝色图标
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    // 移除外边框，保留底部线条
                    labelStyle: TextStyle(color: Colors.black),
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入你的邮箱';
                    }
                    if (!value.contains('@')) {
                      return '请输入有效的邮箱';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 密码输入框
                GetBuilder<LoginRegisterController>(
                  builder: (controller) {
                    return TextFormField(
                      controller: controller.passwordController,
                      obscureText: controller.obscureText,
                      decoration: InputDecoration(
                        labelText: '密码',
                        // 中文标签
                        hintText: '请输入你的密码',
                        // 中文提示文字
                        prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                        // 蓝色图标
                        border: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        // 移除外边框，保留底部线条
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: controller.toggleObscureText,
                        ),
                        labelStyle: TextStyle(color: Colors.black),
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入你的密码';
                        }
                        if (value.length < 6) {
                          return '密码长度至少为 6 位';
                        }
                        return null;
                      },
                    );
                  },
                ),
                const SizedBox(height: 32),

                // 登录按钮
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => controller.onLoginPressed(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),backgroundColor: Colors.blue
                    ),
                    child: const Text(
                      '登录', // 中文按钮文字
                      style: TextStyle(fontSize: 18,color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
