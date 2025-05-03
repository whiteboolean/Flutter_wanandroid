// controllers/auth_controller.dart
import 'dart:convert'; // 用于 JSON 编解码
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 直接导入 SP
import 'package:path_provider/path_provider.dart'; // 用于清除 Cookie 文件
import 'package:untitled6/dio/ApiUrl.dart';
import 'package:untitled6/model/LoginResponse.dart';
import 'dart:io';

import '../base/BaseResponse.dart';
import '../dio/ApiClient.dart';
import '../main.dart'; // 用于 File 操作

class AuthController extends GetxController {
  // 获取依赖注入的 ApiClient 实例
  // 注意：确保 ApiClient 在 AuthController 被创建前已经通过 Get.putAsync 注入
  late final ApiClient apiClient;

  // SharedPreferences 实例，将在初始化时获取
  late SharedPreferences _prefs;

  // 定义存储用的 Key (常量)
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userDataKey = 'userData';

  // 响应式变量
  var isLoggedIn = false.obs;
  var currentUser = Rx<LoginResponse?>(null);
  var isInitialized = false.obs; // 标志 SP 是否已加载

  // 用于存储异步初始化过程的 Future，防止重复执行
  Future<void>? _initFuture;

  @override
  void onInit() {
    super.onInit();
    // 在 onInit 中启动异步初始化，但不阻塞
    _initFuture = _initialize();
  }

  // 异步初始化方法
  Future<void> _initialize() async {
    // 如果已经在初始化，直接返回 Future
    if (_initFuture != null) return _initFuture;

    print("AuthController: Initializing SharedPreferences...");
    try {
      _prefs = await SharedPreferences.getInstance(); // 获取 SP 实例
      print("AuthController: SharedPreferences instance obtained.");
      checkLoginStatus(); // 检查登录状态
    } catch (e) {
      print(
        "AuthController: Error initializing SharedPreferences or checking status: $e",
      );
      // 初始化失败，可以设置默认状态
      isLoggedIn.value = false;
      currentUser.value = null;
    } finally {
      isInitialized.value = true; // 标记初始化完成
      print(
        "AuthController: Initialization complete. LoggedIn: ${isLoggedIn.value}",
      );
    }
  }

  // 提供一个 Future 让外部可以等待初始化完成
  Future<void> waitUntilInitialized() async {
    // 如果 _initFuture 为 null (onInit 可能还没执行完)，稍等一下
    while (_initFuture == null) {
      await Future.delayed(Duration(milliseconds: 100));
    }
    await _initFuture;
  }

  // 检查本地存储的登录状态
  void checkLoginStatus() {
    // 确保 _prefs 已经初始化
    if (!isInitialized.value) {
      print("AuthController: checkLoginStatus called before initialization.");
      // 理论上 _initialize 会调用它，但作为防御
      return;
    }
    final loggedIn = _prefs.getBool(_isLoggedInKey) ?? false;
    isLoggedIn.value = loggedIn;
    if (loggedIn) {
      currentUser.value = _getUserDataFromPrefs();
    } else {
      currentUser.value = null; // 确保未登录时 currentUser 为 null
    }
  }

  // *** 新增：处理登录成功后的逻辑 ***
  Future<void> handleLoginSuccess(LoginResponse? user) async {
    currentUser.value = user;
    isLoggedIn.value = true;
    // 持久化状态和用户信息
    await _saveLoginStatus(true);
    await _saveUserData(user);
    print("AuthController: Login success handled. State and user data saved.");
    // Cookie 已经被 dio_cookie_manager 自动保存

    // 登录成功后，通常需要跳转到主界面
    Get.offAllNamed(AppRoutes.root); // 清除登录/注册页并跳转到主页
  }

  // 修改后的 logout 方法，处理 API 失败

  // *** 用户主动登出方法 ***
  Future<void> logout() async {
    print("AuthController: User initiated logout...");
    bool apiLogoutAttempted = false;
    // 尝试调用登出 API
    try {
      if (Get.isRegistered<ApiClient>()) {
        apiClient = Get.find<ApiClient>();
        await apiClient.get<void>('/user/logout/json', parseData: (_) => null);
        apiLogoutAttempted = true;
        print("AuthController: Logout API call attempted.");
      } else {
        print("AuthController: ApiClient not registered during logout attempt.");
      }
    } catch (e) {
      print("AuthController: Error calling logout API: $e");
      // 即使 API 调用失败，也继续执行本地清理
    }

    // *** 执行本地清理和导航 ***
    await _performLocalLogoutCleanup();
  }

  // *** 处理会话过期的方法 ***
  void handleSessionExpired() {
    // 防止重复执行或在未登录时执行
    if (!isLoggedIn.value) return;
    print("AuthController: Session expired, performing local cleanup and navigation...");
    // *** 直接执行本地清理和导航，不调用 logout API ***
    // 使用 Future.microtask 确保在当前事件循环之后执行，避免在拦截器中直接导航
    Future.microtask(() async {
      await _performLocalLogoutCleanup();
    });
  }

  // *** 抽取出的本地清理和导航逻辑 ***
  Future<void> _performLocalLogoutCleanup() async {
    // 清理本地状态
    await _clearLoginDataFromPrefs();
    isLoggedIn.value = false;
    currentUser.value = null;
    print("AuthController: Local state cleared.");

    // 清除 Cookie 文件
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      final cookiePath = "$appDocPath/.cookies";
      final cookieFile = File(cookiePath);
      if (await cookieFile.exists()) {
        await cookieFile.delete();
        print("AuthController: Cookie file deleted.");
      }
    } catch (e) {
      print("AuthController: Error deleting cookie file: $e");
    }

    // 导航到登录页，并清除之前的路由栈
    Get.offAllNamed(AppRoutes.loginAndRegister);
    print("AuthController: Navigated to login page.");
  }

  // --- SharedPreferences 操作辅助方法 (私有) ---
  Future<void> _saveLoginStatus(bool isLoggedIn) async {
    // 确保 _prefs 已初始化
    if (!isInitialized.value) await waitUntilInitialized();
    await _prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  Future<void> _saveUserData(LoginResponse? user) async {
    if (!isInitialized.value) await waitUntilInitialized();
    if (user != null) {
      await _prefs.setString(_userDataKey, jsonEncode(user.toJson()));
    } else {
      await _prefs.remove(_userDataKey);
    }
  }

  LoginResponse? _getUserDataFromPrefs() {
    if (!isInitialized.value) {
      print("Attempted to get user data before prefs initialized.");
      return null; // SP 未初始化时返回 null
    }
    final String? userJson = _prefs.getString(_userDataKey);
    if (userJson != null && userJson.isNotEmpty) {
      try {
        return LoginResponse.fromJson(jsonDecode(userJson));
      } catch (e) {
        print("Error decoding user data from Prefs: $e");
        return null;
      }
    }
    return null;
  }

  Future<void> _clearLoginDataFromPrefs() async {
    if (!isInitialized.value) await waitUntilInitialized();
    await _prefs.remove(_isLoggedInKey);
    await _prefs.remove(_userDataKey);
  }
}
