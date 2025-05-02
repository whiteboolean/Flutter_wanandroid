import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled6/controller/LoginRegisterController.dart';

class LoginForm extends StatelessWidget {
  final LoginRegisterController controller;
  final Key formKey;

  LoginForm({Key? key, required this.controller})
    : formKey = UniqueKey(),
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginRegisterController>(
      builder: (controller) {
        return Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("去注册"), Icon(Icons.arrow_circle_right)],
              ).onTap(() {
                controller.goToPage(1);
              }),
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
              ).paddingHorizontal(40).paddingTop(10),
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
                  ).paddingHorizontal(40);
                },
              ),
              const SizedBox(height: 32),
              // 登录按钮
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.onLoginPressed(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Color(0xFF5380ed),
                  ),
                  child: const Text(
                    '登录', // 中文按钮文字
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ).paddingHorizontal(40),
            ],
          ),
        );
      },
    );
  }
}
