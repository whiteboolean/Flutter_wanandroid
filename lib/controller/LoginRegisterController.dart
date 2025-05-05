import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled6/dio/ApiUrl.dart';

import '../base/BaseResponse.dart';
import '../dio/ApiClient.dart';
import '../model/LoginResponse.dart';
import 'AuthController.dart';

class LoginRegisterController extends GetxController {
  // Separate form keys for login and register
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();

  // Separate controllers for login and register
  final loginEmailController = TextEditingController(); // login email
  final loginPasswordController = TextEditingController(); // login password

  final registerEmailController = TextEditingController(); // register email
  final registerPasswordController =
      TextEditingController(); // register password
  final registerConfirmPasswordController =
      TextEditingController(); // register confirm password

  var obscureText = true.obs; // 改为 obs 以便 UI 响应
  var obscureConfirmText = true.obs; // 改为 obs
  var registerObscureText = true.obs; // 改为 obs
  final PageController pageController = PageController();
  var isLogin = true.obs;

  var currentPage = 0.obs;

  // 获取 ApiClient 和 AuthController 实例
  final ApiClient apiClient = Get.find<ApiClient>();
  final AuthController authController =
      Get.find<AuthController>(); // *** 获取 AuthController ***

  // Add Listeners to the TextEditingControllers
  @override
  void onInit() {
    super.onInit();
    loginPasswordController.addListener(_updateLoginPasswordVisibility);
    registerPasswordController.addListener(_updateRegisterPasswordVisibility);
    registerConfirmPasswordController.addListener(
      _updateRegisterConfirmPasswordVisibility,
    );
  }

  // Add dispose to remove listeners
  @override
  void onClose() {
    loginEmailController.dispose();
    loginPasswordController.removeListener(_updateLoginPasswordVisibility);
    loginPasswordController.dispose();
    registerEmailController.dispose();
    registerPasswordController.removeListener(
      _updateRegisterPasswordVisibility,
    );
    registerPasswordController.dispose();
    registerConfirmPasswordController.removeListener(
      _updateRegisterConfirmPasswordVisibility,
    );
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
    showLoginPasswordClearButton.value =
        loginPasswordController.text.isNotEmpty;
  }

  void _updateRegisterPasswordVisibility() {
    showRegisterPasswordClearButton.value =
        registerPasswordController.text.isNotEmpty;
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
    obscureText.value = !obscureText.value; // 使用 .value
    print("obscureText: ${obscureText.value}");
    update();
  }

  void toggleRegisterObscureText() {
    registerObscureText.value = !registerObscureText.value; // 使用 .value
    update();
  }

  void toggleObscureConfirmText() {
    obscureConfirmText.value = !obscureConfirmText.value; // 使用 .value
    update();
  }

  void onLoginPressed() async {
    if (loginFormKey.currentState?.validate() ?? false) {
      String email = loginEmailController.text;
      String password = loginPasswordController.text;

      Get.dialog(Center(child: CircularProgressIndicator()));

      await requestLoginApi(email, password);

      // 可以在这里关闭加载指示器 (如果登录成功，AuthController 会导航走)
      if (Get.isDialogOpen ?? false) Get.back();
    }
  }

  Future<BaseResponse<dynamic>> requestSignUpApi(
    String email,
    String password,
    String repassword,
  ) async {
    Map<String, dynamic>? params = {
      "username": email,
      "password": password,
      "repassword": repassword,
      "verifyCode": "2020",
    };
    // 使用 void 作为 T
    BaseResponse<dynamic> response = await apiClient.postForm<dynamic>(
      ApiUrl.register,
      formData: params, // 假设 API 路径
      parseData: (_) => null, // 提供一个总是返回 null 的解析函数
    );
    // 关闭加载指示器
    if (Get.isDialogOpen ?? false) Get.back();
    if (response.isSuccess) {
      Get.snackbar("注册成功", "请使用您的账号密码登录");
      // 注册成功后可以清空注册表单，并切换回登录页面
      registerEmailController.clear();
      registerPasswordController.clear();
      registerConfirmPasswordController.clear();
      isLogin.value = true; // 切换回登录 Tab
      goToPage(0); // 切换 PageView 到登录页
    } else {
      Get.snackbar("注册失败", response.errorMsg);
    }

    return response;
  }


  Future<void> requestLoginApi(String email, String password) async {
    try {
      BaseResponse<LoginResponse?> response = await apiClient.postForm(
        ApiUrl.login,
        formData: {'username': email, 'password': password},
        parseData: (json) {
          if (json != null && json is Map<String, dynamic>) {
            try {
              return LoginResponse.fromJson(json);
            } catch (e) {
              return null;
            }
          }
          return null;
        },
      );
      if (response.isSuccess && response.data != null) {
        // *** 登录成功，调用 AuthController 处理后续 ***
        await authController.handleLoginSuccess(response.data);
        // 不需要在这里 Get.snackbar 或导航了，AuthController 会处理
      } else {
        // API 返回错误，显示提示
        Get.snackbar("登录失败", response.errorMsg);
      }
    } catch (e) {
      // 网络或其他异常
      Get.snackbar("登录出错", "请检查网络或稍后重试");
      print("Login request error: $e");
    }
  }

  void onRegisterPressed(BuildContext context) async{
    if (registerFormKey.currentState?.validate() ?? false) {
      String email = registerEmailController.text.trim();
      String password = registerPasswordController.text.trim();
      String confirmPassword = registerConfirmPasswordController.text.trim();
      // 可以显示加载指示器
      Get.dialog(Center(child: CircularProgressIndicator()));

      // 调用封装的 requestSignUpApi
      await requestSignUpApi(email, password, confirmPassword);
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
