import 'BaseModel.dart';

/// 通用响应封装
class BaseResponse<T> extends BaseModel {
  final T data;

  BaseResponse({
    required int errorCode,
    required String errorMsg,
    required this.data,
  }) : super(errorCode: errorCode, errorMsg: errorMsg);

  /// 通用 JSON 解析
  factory BaseResponse.fromJson(
    Map<String, dynamic> json, {
    required T Function(dynamic json) parseData,
  }) {
    return BaseResponse(
      errorCode: json['errorCode'] ?? -1,
      errorMsg: json['errorMsg'] ?? '',
      data: parseData(json['data']),
    );
  }

  // 添加一个 isSuccess 方法来判断请求是否成功
  bool get isSuccess => errorCode == 0;

  // 如果需要，你还可以添加一个用于输出错误信息的辅助方法
  String get errorMessage => isSuccess ? '' : errorMsg;
}
