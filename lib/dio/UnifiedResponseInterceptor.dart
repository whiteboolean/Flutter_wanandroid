// interceptors/unified_response_interceptor.dart
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart'; // 导入 Get
// 导入 AuthController，确保路径正确
import '../controller/AuthController.dart';

// 导入 BaseResponse 模型
import '../base/BaseResponse.dart'; // <--- 确保导入 BaseResponse

class UnifiedResponseInterceptor extends dio.Interceptor {
  @override
  void onResponse(
    dio.Response response,
    dio.ResponseInterceptorHandler handler,
  ) {
    dynamic responseData = response.data;
    BaseResponse<dynamic>? unifiedResponse;

    if (responseData is Map<String, dynamic>) {
      final int errorCode = responseData['errorCode'] ?? -1;
      final String errorMsg = responseData['errorMsg'] ?? 'Unknown error';

      // *** 在这里检查会话过期错误码并调用 handleSessionExpired ***
      if (errorCode == -1001) {
        // 假设 -1001 是会话过期的错误码
        print(
          "Interceptor: Detected session expired (errorCode: -1001). Calling handleSessionExpired.",
        );
        // 安全地查找并调用 AuthController 的方法
        // 使用 isRegistered 检查确保 AuthController 已经被注入
        if (Get.isRegistered<AuthController>()) {
          // 获取实例并调用处理方法
          Get.find<AuthController>().handleSessionExpired();
        } else {
          print(
            "Interceptor: AuthController not registered. Cannot handle session expiration automatically.",
          );
          // 如果 AuthController 未注册，可能需要采取其他措施或记录日志
        }

        // 创建一个表示会话过期的 BaseResponse (可选，但建议)
        // 这样调用端也能知道具体是会话过期错误
        unifiedResponse = BaseResponse<dynamic>(
          errorCode: errorCode, // 保留原始错误码
          errorMsg: "登录失效，请重新登录", // 可以提供更友好的提示
          data: null,
        );
        response.data = unifiedResponse; // 替换响应数据
        // 注意：handleSessionExpired 内部会导航，这里继续 handler.next 可能影响不大，
        // *** 关键修改：不再需要创建错误 BaseResponse 并替换 data ***
        // *** 选择 Reject 中断响应链，因为 AuthController 会处理导航 ***
        handler.reject(
          dio.DioException(
            requestOptions: response.requestOptions,
            response: response, // 可以保留原始响应供调试
            type: dio.DioExceptionType.unknown, // 或者自定义类型
            error: "Session expired (handled by AuthController)", // 自定义错误信息
          ),
          true, // 使用 true 允许 ErrorInterceptorHandler 处理（虽然我们下面也处理了）
        );
        return; // *** 必须 return，阻止后续代码执行 ***
      } else if (errorCode != 0) {
        // 其他业务逻辑错误
        print(
          "Interceptor: API Business Error: Code=$errorCode, Msg=$errorMsg",
        );
        unifiedResponse = BaseResponse<dynamic>(
          errorCode: errorCode,
          errorMsg: errorMsg,
          data: null,
        );
        response.data = unifiedResponse;
      }
      // 如果 errorCode == 0 (业务成功)，则不处理，让原始数据通过
    } else if (!(responseData is BaseResponse)) {
      // 增加判断，防止重复包装
      // 响应格式不符合预期 (不是 Map 也不是已经包装好的 BaseResponse)
      print(
        "Interceptor: Invalid response format: ${responseData.runtimeType}",
      );
      unifiedResponse = BaseResponse<dynamic>(
        errorCode: -1,
        errorMsg: 'Invalid response format',
        data: null,
      );
      response.data = unifiedResponse;
    }

    // 继续处理链
    handler.next(response);
  }

  @override
  void onError(dio.DioException err, dio.ErrorInterceptorHandler handler) {
    print("Interceptor: DioException occurred: ${err.type} - ${err.message}");
    BaseResponse<dynamic> errorResponse;

    // *** 可以在这里也检查 HTTP 401 未授权状态码 ***
    if (err.response?.statusCode == 401) {
      print(
        "Interceptor: Detected HTTP 401 Unauthorized. Calling handleSessionExpired.",
      );
      if (Get.isRegistered<AuthController>()) {
        Get.find<AuthController>().handleSessionExpired();
      }
      // 可以创建一个特定的 BaseResponse 表示 401
      errorResponse = BaseResponse(
        errorCode: 401,
        errorMsg: '登录失效，请重新登录',
        data: null,
      );
    } else {
      // 根据 DioException 类型创建错误 BaseResponse (之前的逻辑)
      switch (err.type) {
        case dio.DioExceptionType.connectionTimeout:
        case dio.DioExceptionType.sendTimeout:
        case dio.DioExceptionType.receiveTimeout:
          errorResponse = BaseResponse(
            errorCode: -1,
            errorMsg: '网络超时，请稍后重试',
            data: null,
          );
          break;
        case dio.DioExceptionType.badResponse:
          final statusCode = err.response?.statusCode ?? -1;
          errorResponse = BaseResponse(
            errorCode: statusCode,
            errorMsg: '服务器繁忙 ($statusCode)',
            data: null,
          );
          break;
        case dio.DioExceptionType.cancel:
          errorResponse = BaseResponse(
            errorCode: -1,
            errorMsg: '请求已取消',
            data: null,
          );
          break;
        case dio.DioExceptionType.connectionError:
          errorResponse = BaseResponse(
            errorCode: -1,
            errorMsg: '网络连接错误，请检查网络',
            data: null,
          );
          break;
        case dio.DioExceptionType.unknown:
        default:
          errorResponse = BaseResponse(
            errorCode: -1,
            errorMsg: '发生未知错误',
            data: null,
          );
          break;
      }
    }

    // 使用 handler.resolve 返回包含错误信息的“成功”响应
    final errorDioResponse = dio.Response(
      requestOptions: err.requestOptions,
      data: errorResponse, // 将错误 BaseResponse 作为 data
      statusCode: 200, // 伪造成功状态码
    );
    handler.resolve(errorDioResponse);
  }
}
