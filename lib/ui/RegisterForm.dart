import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled6/controller/LoginRegisterController.dart';

class RegisterForm extends StatelessWidget {
  final LoginRegisterController controller;

  RegisterForm({Key? key, required this.controller})
    :super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginRegisterController>(
      builder: (controller) {
        return Form(
          key: controller.registerFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.arrow_circle_left), Text("Login now")],
              ).onTap(() {
                controller.goToPage(0);
              }),
              // Email 输入框
              TextFormField(
                controller: controller.registerEmailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'email',
                  hintText: 'input your email',
                  prefixIcon: Icon(Icons.email, color: Colors.grey),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'email cannot be empty';
                  }
                  if (!value.contains('@')) {
                    return 'please input valid email';
                  }
                  return null;
                },
              ).paddingHorizontal(40).paddingTop(10).paddingBottom(16),
              // 密码输入框
              TextFormField(
                controller: controller.registerPasswordController,
                obscureText: controller.registerObscureText.value,
                decoration: InputDecoration(
                  labelText: 'password',
                  hintText: 'please input your password',
                  prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: UnderlineInputBorder( // the normal state color
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder( // the focused state color
                    borderSide: BorderSide(color: Color(0xFF5380ed), width: 2.0), // Customize the color and width here
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(
                        () => Visibility(
                          visible: controller.showRegisterPasswordClearButton.value,
                          child: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              controller.clearRegisterPassword();
                            },
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          controller.obscureText.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: controller.toggleRegisterObscureText,
                      ),
                    ],
                  ),
                  labelStyle: const TextStyle(color: Colors.black),
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please input your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least six characters.';
                  }
                  return null;
                },
              ).paddingHorizontal(40),
              const SizedBox(height: 16),

              // Confirm 密码输入确认框
              TextFormField(
                controller: controller.registerConfirmPasswordController,
                obscureText: controller.obscureConfirmText.value,
                decoration: InputDecoration(
                  labelText: 'recheck password',
                  hintText: 'Please input your password again',
                  prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: UnderlineInputBorder( // the normal state color
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder( // the focused state color
                    borderSide: BorderSide(color: Color(0xFF5380ed), width: 2.0), // Customize the color and width here
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(
                        () => Visibility(
                          visible:
                              controller.showRegisterConfirmPasswordClearButton.value,
                          child: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              controller.clearRegisterConfirmPassword();
                            },
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          controller.obscureConfirmText.value
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
                    return 'Please check your password';
                  }
                  if (value != controller.registerPasswordController.text) {
                    return "The two passwords do not match";
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
                    'Register',
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
