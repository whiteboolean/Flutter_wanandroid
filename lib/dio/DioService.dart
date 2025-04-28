import 'package:dio/dio.dart';
import 'package:untitled6/dio/ApiUrl.dart';

@Deprecated("DioService.dart is deprecated. Use ApiClient.dart instead.")
class DioService {
  // 私有的静态实例
  static DioService? _instance;

  // Dio 实例
  late Dio _dio;

  // 提供一个公共的静态方法用于获取 DioService 实例
  static DioService get instance {
    // 如果实例为 null，则创建新的实例
    _instance ??= DioService._privateConstructor();
    return _instance!;
  }

  // 构造函数，配置 Dio 实例
  DioService._privateConstructor() {
    // 初始化 Dio，并设置基础配置
    _dio = Dio(
      BaseOptions(
        baseUrl:  ApiUrl.baseUrl, // 设置基础URL
        connectTimeout: const Duration(seconds: 10), // 设置连接超时时间
        receiveTimeout: const Duration(seconds: 10), // 设置接收超时时间
      ),
    );

    // 添加日志拦截器，打印请求信息
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  // 封装 GET 请求
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      Response response = await _dio.get(
        path,
        queryParameters: queryParameters,
      );
      return response.data; // 返回数据
    } on DioException catch (e) {
      // 错误处理
      return _handleError(e);
    }
  }

  // 封装 POST 请求
  Future<dynamic> post(String path, {Map<String, dynamic>? data}) async {
    try {
      Response response = await _dio.post(path, data: data);
      return response.data; // 返回数据
    } on DioException catch (e) {
      // 错误处理
      return _handleError(e);
    }
  }

  // 错误处理函数
  dynamic _handleError(DioException error) {
    String errorMessage = '';
    if (error.type == DioExceptionType.connectionTimeout) {
      errorMessage = "Connection Timeout";
    } else if (error.type == DioExceptionType.receiveTimeout) {
      errorMessage = "Receive Timeout";
    } else if (error.type == DioExceptionType.badResponse) {
      errorMessage = "Bad Response: ${error.response?.statusCode}";
    } else {
      errorMessage = "Unexpected Error: ${error.message}";
    }
    return {'error': errorMessage}; // 返回错误信息
  }
}
