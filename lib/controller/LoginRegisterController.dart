import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginRegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscureText = true;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void toggleObscureText() {
    obscureText = !obscureText;
    update(); // Refresh the UI
  }

  void onLoginPressed(BuildContext context) {
    if (formKey.currentState!.validate()) {
      // Form is valid, perform login
      String email = emailController.text;
      String password = passwordController.text;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email: $email, Password: $password'),
        ),
      );
    }
  }
}