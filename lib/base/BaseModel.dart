/// 所有模型的基类，带 errorCode 和 errorMsg
abstract class BaseModel {
  final int errorCode;
  final String errorMsg;

  BaseModel({
    required this.errorCode,
    required this.errorMsg,
  });
}