import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginRegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController(); // Add this
  bool obscureText = true;
  bool obscureConfirmText = true; // add this
  final PageController pageController = PageController(); // PageView controller
  var isLogin = true.obs; // Add this

  var currentPage = 0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    passwordController.addListener(_updatePasswordVisibility);
    confirmPasswordController.addListener(_updateConfirmPasswordVisibility);
    (_updateConfirmPasswordVisibility);
  }

  void goToPage(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
    currentPage.value = index;
  }

  // Observables for clear button visibility
  RxBool showPasswordClearButton = false.obs;
  RxBool showConfirmPasswordClearButton = false.obs;

  // Listeners to update the observables
  void _updatePasswordVisibility() {
    showPasswordClearButton.value = passwordController.text.isNotEmpty;
  }

  void _updateConfirmPasswordVisibility() {
    showConfirmPasswordClearButton.value = confirmPasswordController.text.isNotEmpty;
  }

  void clearPassword() {
    passwordController.clear();
  }

  void clearConfirmPassword() {
    confirmPasswordController.clear();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    pageController.dispose(); // Dispose the page controller

    passwordController.removeListener(_updatePasswordVisibility); // Remove listener
    confirmPasswordController.removeListener(_updateConfirmPasswordVisibility);//remove listener
    super.onClose();
  }

  void toggleObscureText() {
    obscureText = !obscureText;
    update(); // Refresh the UI
  }

  void toggleObscureConfirmText() {
    obscureConfirmText = !obscureConfirmText;
    update();
  }

  void onLoginPressed(BuildContext context) {
    if (formKey.currentState!.validate()) {
      // Form is valid, perform login
      String email = emailController.text;
      String password = passwordController.text;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login Email: $email, Password: $password'),
        ),
      );
    }
  }

  void onRegisterPressed(BuildContext context) {
    if (formKey.currentState!.validate()) {
      // Form is valid, perform register
      String email = emailController.text;
      String password = passwordController.text;
      String confirmPassword = confirmPasswordController.text;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Register Email: $email, Password: $password,Confirm Password:$confirmPassword'),
        ),
      );
    }
  }

  void changePage() {
    isLogin.value = !isLogin.value;
  }
}