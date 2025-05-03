import 'BaseModel.dart';

/// 通用响应封装
class BaseResponse<T> extends BaseModel {
  final T? data;

  BaseResponse({
    required int errorCode,
    required String errorMsg,
    required this.data,
  }) : super(errorCode: errorCode, errorMsg: errorMsg);


  // 添加一个 fromJson 工厂构造函数来简化解析
  // 注意：这里的 parseData 函数现在应该返回 T?
  factory BaseResponse.fromJson(Map<String, dynamic> json, T? Function(dynamic dataJson) parseData) {
    final int code = json['errorCode'] ?? -1;
    final String msg = json['errorMsg'] ?? 'Unknown error';
    T? parsedData;

    // 只有当 errorCode 为 0 且 data 字段存在时才尝试解析
    // 并且 parseData 函数本身也可能返回 null
    if (code == 0 && json.containsKey('data')) {
      // 传递 data 字段给解析函数
      // 注意：json['data'] 本身也可能是 null，parseData 需要能处理
      parsedData = parseData(json['data']);
    }

    return BaseResponse<T>(
      errorCode: code,
      errorMsg: msg,
      data: parsedData, // 最终的 data 可能是解析结果，也可能是 null
    );
  }

  // 可以添加一个辅助 getter 判断请求是否成功
  bool get isSuccess => errorCode == 0;


  String get errorMessage => isSuccess ? '' : errorMsg;
}
