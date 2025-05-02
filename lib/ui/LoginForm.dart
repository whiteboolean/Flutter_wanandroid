import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled6/controller/LoginRegisterController.dart';

class LoginForm extends StatelessWidget {
  final LoginRegisterController controller;

  LoginForm({Key? key, required this.controller})
    :super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginRegisterController>(
      builder: (controller) {
        return Form(
          key: controller.loginFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("Sign up now"), Icon(Icons.arrow_circle_right)],
              ).onTap(() {
                controller.goToPage(1);
              }),
              // Email 输入框
              TextFormField(
                controller: controller.loginEmailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'email',
                  // 中文标签
                  hintText: 'Please input your email',
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
                    return 'please input your email address';
                  }
                  if (!value.contains('@')) {
                    return 'please input valid email address';
                  }
                  return null;
                },
              ).paddingHorizontal(40).paddingTop(10),
              const SizedBox(height: 16),
              // 密码输入框
              GetBuilder<LoginRegisterController>(
                builder: (controller) {
                  return TextFormField(
                    controller: controller.loginPasswordController,
                    obscureText: controller.obscureText,
                    decoration: InputDecoration(
                      labelText: 'password',
                      hintText: 'please input your password',
                      prefixIcon: const Icon(Icons.lock, color: Colors.grey),
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
                        return 'please input your password';
                      }
                      if (value.length < 6) {
                        return 'password must be at least six characters.';
                      }
                      return null;
                    },
                  ).paddingHorizontal(40);
                },
              ),
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
                    'Login',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ).paddingHorizontal(40).paddingTop(32),
            ],
          ),
        );
      },
    );
  }
}
