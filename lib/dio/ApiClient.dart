// api_client.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

// 导入你的 BaseResponse, ApiUrl, 拦截器等
import '../base/BaseResponse.dart'; // 确保路径正确
import 'ApiUrl.dart'; // 确保路径正确
import 'UnifiedResponseInterceptor.dart'; // 确保路径正确

class ApiClient {
  // Dio 实例通过构造函数注入，设为 final
  final Dio dio;

  // 公共构造函数，接收配置好的 Dio 实例
  ApiClient(this.dio);

  // --- API 调用方法保持不变 ---

  // 简化后的 GET 方法
  Future<BaseResponse<T?>> get<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    required T? Function(dynamic json) parseData,
  }) async {
    try {
      // 使用注入的 dio 实例
      final response = await dio.get(url, queryParameters: queryParameters);
      // ... (处理响应的逻辑保持不变) ...
      if (response.data is BaseResponse) {
        final errorResponse = response.data as BaseResponse<dynamic>;
        return BaseResponse<T>(
          errorCode: errorResponse.errorCode,
          errorMsg: errorResponse.errorMsg,
          data: null,
        );
      } else if (response.data is Map<String, dynamic>) {
        final responseMap = response.data as Map<String, dynamic>;
        final int errorCode = responseMap['errorCode'] ?? -1;
        final String errorMsg = responseMap['errorMsg'] ?? '';
        if (errorCode == 0) {
          T? parsedData = parseData(responseMap['data']);
          return BaseResponse<T>(
            errorCode: 0,
            errorMsg: errorMsg,
            data: parsedData,
          );
        } else {
          return BaseResponse<T>(
            errorCode: errorCode,
            errorMsg: errorMsg,
            data: null,
          );
        }
      } else {
        return BaseResponse<T>(
          errorCode: -1,
          errorMsg: "Invalid data received",
          data: null,
        );
      }
    } catch (e) {
      print("Unexpected error in ApiClient.get: $e");
      return BaseResponse<T>(
        errorCode: -1,
        errorMsg: "An unexpected client error occurred",
        data: null,
      );
    }
  }

  // 简化后的 POST 方法
  Future<BaseResponse<T?>> post<T>(
    String url, {
    Map<String, dynamic>? data,
    Options? options,
    required T? Function(dynamic json) parseData,
  }) async {
    try {
      // 使用注入的 dio 实例
      final response = await dio.post(url, data: data, options: options);
      // ... (处理响应的逻辑保持不变) ...
      if (response.data is BaseResponse) {
        final errorResponse = response.data as BaseResponse<dynamic>;
        return BaseResponse<T>(
          errorCode: errorResponse.errorCode,
          errorMsg: errorResponse.errorMsg,
          data: null,
        );
      } else if (response.data is Map<String, dynamic>) {
        final responseMap = response.data as Map<String, dynamic>;
        final int errorCode = responseMap['errorCode'] ?? -1;
        final String errorMsg = responseMap['errorMsg'] ?? '';
        if (errorCode == 0) {
          T? parsedData = parseData(responseMap['data']);
          return BaseResponse<T>(
            errorCode: 0,
            errorMsg: errorMsg,
            data: parsedData,
          );
        } else {
          return BaseResponse<T>(
            errorCode: errorCode,
            errorMsg: errorMsg,
            data: null,
          );
        }
      } else {
        return BaseResponse<T>(
          errorCode: -1,
          errorMsg: "Invalid data received",
          data: null,
        );
      }
    } catch (e) {
      print("Unexpected error in ApiClient.post: $e");
      return BaseResponse<T>(
        errorCode: -1,
        errorMsg: "An unexpected client error occurred",
        data: null,
      );
    }
  }

  // postForm 方法保持不变，它内部调用 post
  Future<BaseResponse<T?>> postForm<T>(
    String url, {
    required Map<String, dynamic> formData,
    required T? Function(dynamic json) parseData,
  }) async {
    return post<T>(
      url,
      data: formData,
      options: Options(contentType: Headers.formUrlEncodedContentType),
      parseData: parseData,
    );
  }
}

// --- 单独定义异步工厂函数，用于 Get.putAsync ---
Future<ApiClient> setupApiClient() async {
  print("Setting up ApiClient..."); // 添加日志，确认此函数被调用
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiUrl.baseUrl, // 使用你的 ApiUrl 配置
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  // --- 异步配置 Cookie 管理 ---
  try {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    final cookiePath = "$appDocPath/.cookies";
    print("Cookie storage path: $cookiePath"); // 打印路径
    final cookieJar = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage(cookiePath),
    );
    dio.interceptors.add(CookieManager(cookieJar));
    print("CookieManager added.");
  } catch (e) {
    print("Error initializing CookieManager: $e");
    // 考虑是否需要抛出异常或提供默认行为
  }
  // --- Cookie 管理配置结束 ---

  // 添加其他拦截器
  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  dio.interceptors.add(UnifiedResponseInterceptor()); // 确保添加了统一响应拦截器
  print("Interceptors added.");

  print("ApiClient setup complete. Returning instance.");
  return ApiClient(dio); // 返回配置好的 ApiClient 实例
}
