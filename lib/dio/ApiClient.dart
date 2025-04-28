import 'package:dio/dio.dart';
import '../model/BaseResponse.dart';
import 'ApiUrl.dart';

class ApiClient {
  late final Dio _dio;
  static ApiClient? _instance ;

  // 提供一个公共的静态方法用于获取 DioService 实例
  static ApiClient get instance {
    // 如果实例为 null，则创建新的实例
    _instance ??= ApiClient._privateConstructor();
    return _instance!;
  }

  // 构造函数，配置 Dio 实例
  ApiClient._privateConstructor() {
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

  // 请求方法：通用 GET 请求
  Future<BaseResponse<T>> get<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic json) parseData,
  }) async {
    try {
      final response = await _dio.get(url, queryParameters: queryParameters);
      return _handleResponse(response.data, parseData);
    } on DioException catch (e) {
      // 处理请求错误
      return BaseResponse<T>(
        errorCode: e.response?.statusCode ?? -1,
        errorMsg: e.message ?? "",
        data: parseData({}), // 或者返回默认的空数据
      );
    }
  }

  // 请求方法：通用 POST 请求
  Future<BaseResponse<T>> post<T>(
    String url, {
    Map<String, dynamic>? data,
    required T Function(dynamic json) parseData,
  }) async {
    try {
      final response = await _dio.post(url, data: data);
      return _handleResponse(response.data, parseData);
    } on DioException catch (e) {
      // 处理请求错误
      return BaseResponse<T>(
        errorCode: e.response?.statusCode ?? -1,
        errorMsg: e.message??"",
        data: parseData({}),
      );
    }
  }

  // 处理返回的响应数据
  BaseResponse<T> _handleResponse<T>(
    dynamic responseData,
    T Function(dynamic json) parseData,
  ) {
    try {
      // 假设响应数据有 errorCode、errorMsg 和 data 字段
      final json = responseData;
      return BaseResponse<T>(
        errorCode: json['errorCode'] ?? -1,
        errorMsg: json['errorMsg'] ?? '',
        data: parseData(json['data']),
      );
    } catch (e) {
      return BaseResponse<T>(
        errorCode: -1,
        errorMsg: '解析数据失败',
        data: parseData({}), // 默认空数据
      );
    }
  }
}
