import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:untitled6/model/ArticleResponse.dart';

import '../main.dart';

class ArticleListItem extends StatelessWidget {
  final ArticleItem articleItem;
  final isCollect = false.obs;

  ArticleListItem({Key? key, required this.articleItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 可以使用 InkWell 包裹整个 Container，以便添加点击事件

    var textStyle = const TextStyle(fontSize: 12.0, color: Color(0XFF999999));

    return InkWell(
      onTap: () {
        // 处理列表项点击事件，跳转到文章详情页等
        // 确保 articleItem.link 是有效的 URL 字符串
        if (articleItem.link != null && articleItem.link!.isNotEmpty) {
          Get.toNamed(
            // 使用 Get.toNamed 进行导航
            AppRoutes.webView, // 使用在 AppRoutes 中定义的路由名称
            arguments: {
              // 使用 arguments 参数传递 Map 数据
              'url': articleItem.link!,
              'title': articleItem.title ?? '详情', // 传递 URL 和标题 (提供默认标题)
            },
          );
        } else {
          // 如果链接无效，使用 GetX 的 SnackBar
          Get.snackbar(
            '错误', // 标题
            '无效的文章链接', // 消息
            snackPosition: SnackPosition.BOTTOM, // SnackBar 位置 (可选)
          );
          print('无效的链接: ${articleItem.link}');
        }
      },
      child: Container(
        // 可以添加一个底部分割线
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[300]!, // 灰色线条
              width: 0.5, // 细线
            ),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
          // 内边距
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // 如果点赞图标需要点击功能，可以用 IconButton 包裹 Icon
              IconButton(
                icon: Icon(
                  isCollect.value ? Icons.favorite : Icons.favorite_border,
                  size: 16.0,
                  color: isCollect.value ? Colors.red : Colors.grey[600],
                ),
                padding: EdgeInsets.zero, // 移除默认 padding
                constraints: BoxConstraints(), // 移除默认约束
                onPressed: () {
                  // 处理点赞点击事件
                  print('点击了点赞');
                  Get.snackbar("通知", "点击了点赞");
                  isCollect.value = !isCollect.value;
                },
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // 垂直居中对齐
                  children: [
                    Text(
                      articleItem.title ?? "",
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2, // 限制标题最多显示两行，溢出显示省略号
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 10),

                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          // 标签和作者之间留点空隙
                          child: Text(
                            "分享人:",
                          ).fontSize(12.0).textColor(Color(0XFF999999)),
                        ),

                        Text(
                          '${articleItem.author != null && articleItem.author!.isNotEmpty ? articleItem.author : articleItem.shareUser}',
                          style: textStyle,
                        ),
                        SizedBox(width: 10),

                        Text('时间：${articleItem.niceDate}', style: textStyle),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }
}
