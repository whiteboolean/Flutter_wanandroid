import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginRegisterController extends GetxController {
  // Separate form keys for login and register
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();

  // Separate controllers for login and register
  final loginEmailController = TextEditingController(); // login email
  final loginPasswordController = TextEditingController(); // login password

  final registerEmailController = TextEditingController(); // register email
  final registerPasswordController = TextEditingController(); // register password
  final registerConfirmPasswordController = TextEditingController(); // register confirm password

  bool obscureText = true;
  bool obscureConfirmText = true;
  final PageController pageController = PageController();
  var isLogin = true.obs;

  var currentPage = 0.obs;


  // Add Listeners to the TextEditingControllers
  @override
  void onInit() {
    super.onInit();
    loginPasswordController.addListener(_updateLoginPasswordVisibility);
    registerPasswordController.addListener(_updateRegisterPasswordVisibility);
    registerConfirmPasswordController.addListener(_updateRegisterConfirmPasswordVisibility);
  }

  // Add dispose to remove listeners
  @override
  void onClose() {
    loginEmailController.dispose();
    loginPasswordController.removeListener(_updateLoginPasswordVisibility);
    loginPasswordController.dispose();
    registerEmailController.dispose();
    registerPasswordController.removeListener(_updateRegisterPasswordVisibility);
    registerPasswordController.dispose();
    registerConfirmPasswordController
        .removeListener(_updateRegisterConfirmPasswordVisibility);
    registerConfirmPasswordController.dispose();
    pageController.dispose();
    super.onClose();
  }

  // Observables for clear button visibility
  RxBool showLoginPasswordClearButton = false.obs;
  RxBool showRegisterPasswordClearButton = false.obs;
  RxBool showRegisterConfirmPasswordClearButton = false.obs;

  // Listeners to update the observables
  void _updateLoginPasswordVisibility() {
    showLoginPasswordClearButton.value = loginPasswordController.text.isNotEmpty;
  }

  void _updateRegisterPasswordVisibility() {
    showRegisterPasswordClearButton.value = registerPasswordController.text.isNotEmpty;
  }

  void _updateRegisterConfirmPasswordVisibility() {
    showRegisterConfirmPasswordClearButton.value =
        registerConfirmPasswordController.text.isNotEmpty;
  }

  void clearLoginPassword() {
    loginPasswordController.clear();
  }

  void clearRegisterPassword() {
    registerPasswordController.clear();
  }

  void clearRegisterConfirmPassword() {
    registerConfirmPasswordController.clear();
  }

  void toggleObscureText() {
    obscureText = !obscureText;
    update();
  }

  void toggleObscureConfirmText() {
    obscureConfirmText = !obscureConfirmText;
    update();
  }

  void onLoginPressed(BuildContext context) {
    if (loginFormKey.currentState?.validate() ?? false) {
      String email = loginEmailController.text;
      String password = loginPasswordController.text;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login Email: $email, Password: $password'),
        ),
      );
    }
  }

  void onRegisterPressed(BuildContext context) {
    if (registerFormKey.currentState?.validate() ?? false) {
      String email = registerEmailController.text;
      String password = registerPasswordController.text;
      String confirmPassword = registerConfirmPasswordController.text;
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

  void goToPage(int page) {
    pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}