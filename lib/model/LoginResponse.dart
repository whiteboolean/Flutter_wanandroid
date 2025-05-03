class LoginResponse {
  final bool? admin;
  final List<dynamic>? chapterTops;
  final int? coinCount;
  final List<dynamic>? collectIds;
  final String? email;
  final String? icon;
  final int? id;
  final String? nickname;
  final String? password;
  final String? publicName;
  final String? token;
  final int? type;
  final String? username;

  LoginResponse({
    this.admin,
    this.chapterTops,
    this.coinCount,
    this.collectIds,
    this.email,
    this.icon,
    this.id,
    this.nickname,
    this.password,
    this.publicName,
    this.token,
    this.type,
    this.username,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      admin: json['admin'],
      chapterTops: json['chapterTops'] as List<dynamic>?,
      coinCount: json['coinCount'],
      collectIds: json['collectIds'] as List<dynamic>?,
      email: json['email'],
      icon: json['icon'],
      id: json['id'],
      nickname: json['nickname'],
      password: json['password'],
      publicName: json['publicName'],
      token: json['token'],
      type: json['type'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'admin': admin,
      'chapterTops': chapterTops,
      'coinCount': coinCount,
      'collectIds': collectIds,
      'email': email,
      'icon': icon,
      'id': id,
      'nickname': nickname,
      'password': password,
      'publicName': publicName,
      'token': token,
      'type': type,
      'username': username,
    };
  }
}
