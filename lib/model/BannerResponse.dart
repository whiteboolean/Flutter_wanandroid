// 顶层响应类
class BannerResponse {
  final int errorCode;
  final String errorMsg;
  final List<BannerEntity> data;

  BannerResponse({
    required this.errorCode,
    required this.errorMsg,
    required this.data,
  });

  // 将 JSON 转换为 BannerResponse 对象
  factory BannerResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<BannerEntity> dataList = list.map((i) => BannerEntity.fromJson(i)).toList();

    return BannerResponse(
      errorCode: json['errorCode'],
      errorMsg: json['errorMsg'],
      data: dataList,
    );
  }

  // 将 BannerResponse 对象转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'errorCode': errorCode,
      'errorMsg': errorMsg,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

// Banner 数据模型
class BannerEntity {
  final String desc;
  final int id;
  final String imagePath;
  final int isVisible;
  final int order;
  final String title;
  final int type;
  final String url;

  BannerEntity({
    required this.desc,
    required this.id,
    required this.imagePath,
    required this.isVisible,
    required this.order,
    required this.title,
    required this.type,
    required this.url,
  });

  // 将 JSON 转换为 BannerEntity 对象
  factory BannerEntity.fromJson(Map<String, dynamic> json) {
    return BannerEntity(
      desc: json['desc'],
      id: json['id'],
      imagePath: json['imagePath'],
      isVisible: json['isVisible'],
      order: json['order'],
      title: json['title'],
      type: json['type'],
      url: json['url'],
    );
  }

  // 将 BannerEntity 对象转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'desc': desc,
      'id': id,
      'imagePath': imagePath,
      'isVisible': isVisible,
      'order': order,
      'title': title,
      'type': type,
      'url': url,
    };
  }
}
