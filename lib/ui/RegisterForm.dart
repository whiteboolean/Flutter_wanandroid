import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled6/controller/LoginRegisterController.dart';

class RegisterForm extends StatelessWidget {
  final LoginRegisterController controller;
  final Key formKey;

  RegisterForm({Key? key, required this.controller})
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
                children: [Icon(Icons.arrow_circle_left), Text("去登录")],
              ).onTap(() {
                controller.goToPage(0);
              }),
              // Email 输入框
              TextFormField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: '邮箱',
                  hintText: '请输入你的邮箱',
                  prefixIcon: Icon(Icons.email, color: Colors.grey),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
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
              TextFormField(
                controller: controller.passwordController,
                obscureText: controller.obscureText,
                decoration: InputDecoration(
                  labelText: '密码',
                  hintText: '请输入你的密码',
                  prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(
                        () => Visibility(
                          visible: controller.showPasswordClearButton.value,
                          child: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              controller.clearPassword();
                            },
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          controller.obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: controller.toggleObscureText,
                      ),
                    ],
                  ),
                  labelStyle: const TextStyle(color: Colors.black),
                  hintStyle: const TextStyle(color: Colors.grey),
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
              ).paddingHorizontal(40),
              const SizedBox(height: 16),

              // Confirm 密码输入框
              TextFormField(
                controller: controller.confirmPasswordController,
                obscureText: controller.obscureConfirmText,
                decoration: InputDecoration(
                  labelText: '确认密码',
                  hintText: '请再次输入你的密码',
                  prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(
                        () => Visibility(
                          visible:
                              controller.showConfirmPasswordClearButton.value,
                          child: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              controller.clearConfirmPassword();
                            },
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          controller.obscureConfirmText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: controller.toggleObscureConfirmText,
                      ),
                    ],
                  ),
                  labelStyle: const TextStyle(color: Colors.black),
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请确认你的密码';
                  }
                  if (value != controller.passwordController.text) {
                    return '两次输入的密码不一致';
                  }
                  return null;
                },
              ).paddingHorizontal(40),
              const SizedBox(height: 32),
              // 注册按钮
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.onRegisterPressed(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Color(0xFF5380ed),
                  ),
                  child: const Text(
                    '注册', // 中文按钮文字
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
