class ArticleListResponse {
  final int? curPage;
  final List<ArticleItem>? datas;
  final int? offset;
  final bool? over;
  final int? pageCount;
  final int? size;
  final int? total;

  ArticleListResponse({
    this.curPage,
    this.datas,
    this.offset,
    this.over,
    this.pageCount,
    this.size,
    this.total,
  });

  factory ArticleListResponse.fromJson(Map<String, dynamic> json) {
    var datasJson = json['datas'] as List<dynamic>?;
    return ArticleListResponse(
      curPage: json['curPage'],
      datas: datasJson?.map((e) => ArticleItem.fromJson(e)).toList(),
      offset: json['offset'],
      over: json['over'],
      pageCount: json['pageCount'],
      size: json['size'],
      total: json['total'],
    );
  }
}

class ArticleItem {
  final bool? adminAdd;
  final String? apkLink;
  final int? audit;
  final String? author;
  final bool? canEdit;
  final int? chapterId;
  final String? chapterName;
  final bool? collect;
  final int? courseId;
  final String? desc;
  final String? descMd;
  final String? envelopePic;
  final bool? fresh;
  final String? host;
  final int? id;
  final bool? isAdminAdd;
  final String? link;
  final String? niceDate;
  final String? niceShareDate;
  final String? origin;
  final String? prefix;
  final String? projectLink;
  final int? publishTime;
  final int? realSuperChapterId;
  final int? selfVisible;
  final int? shareDate;
  final String? shareUser;
  final int? superChapterId;
  final String? superChapterName;
  final List<Tag>? tags;
  final String? title;
  final int? type;
  final int? userId;
  final int? visible;
  final int? zan;

  ArticleItem({
    this.adminAdd,
    this.apkLink,
    this.audit,
    this.author,
    this.canEdit,
    this.chapterId,
    this.chapterName,
    this.collect,
    this.courseId,
    this.desc,
    this.descMd,
    this.envelopePic,
    this.fresh,
    this.host,
    this.id,
    this.isAdminAdd,
    this.link,
    this.niceDate,
    this.niceShareDate,
    this.origin,
    this.prefix,
    this.projectLink,
    this.publishTime,
    this.realSuperChapterId,
    this.selfVisible,
    this.shareDate,
    this.shareUser,
    this.superChapterId,
    this.superChapterName,
    this.tags,
    this.title,
    this.type,
    this.userId,
    this.visible,
    this.zan,
  });

  factory ArticleItem.fromJson(Map<String, dynamic> json) {
    var tagsJson = json['tags'] as List<dynamic>?;
    return ArticleItem(
      adminAdd: json['adminAdd'],
      apkLink: json['apkLink'],
      audit: json['audit'],
      author: json['author'],
      canEdit: json['canEdit'],
      chapterId: json['chapterId'],
      chapterName: json['chapterName'],
      collect: json['collect'],
      courseId: json['courseId'],
      desc: json['desc'],
      descMd: json['descMd'],
      envelopePic: json['envelopePic'],
      fresh: json['fresh'],
      host: json['host'],
      id: json['id'],
      isAdminAdd: json['isAdminAdd'],
      link: json['link'],
      niceDate: json['niceDate'],
      niceShareDate: json['niceShareDate'],
      origin: json['origin'],
      prefix: json['prefix'],
      projectLink: json['projectLink'],
      publishTime: json['publishTime'],
      realSuperChapterId: json['realSuperChapterId'],
      selfVisible: json['selfVisible'],
      shareDate: json['shareDate'],
      shareUser: json['shareUser'],
      superChapterId: json['superChapterId'],
      superChapterName: json['superChapterName'],
      tags: tagsJson?.map((e) => Tag.fromJson(e)).toList(),
      title: json['title'],
      type: json['type'],
      userId: json['userId'],
      visible: json['visible'],
      zan: json['zan'],
    );
  }
}

class Tag {
  final String? name;
  final String? url;

  Tag({
    this.name,
    this.url,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      name: json['name'],
      url: json['url'],
    );
  }
}
