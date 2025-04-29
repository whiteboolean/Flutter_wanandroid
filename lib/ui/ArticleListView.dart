import 'package:flutter/material.dart';
import 'package:untitled6/model/ArticleResponse.dart';

class ArticleListItem extends StatelessWidget {
  final ArticleItem articleItem;

  const ArticleListItem({Key? key, required this.articleItem})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 可以使用 InkWell 包裹整个 Container，以便添加点击事件
    return InkWell(
      onTap: () {
        // 处理列表项点击事件，跳转到文章详情页等
        print('点击了文章: ');
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
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
          // 内边距
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 子元素左对齐
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center, // 垂直居中对齐
                children: [
                  // 左边的作者/标签信息
                  Expanded(
                    // 让这部分占据尽可能多的空间
                    child: Row(
                      children: [
                        // 如果有标签（如“新”）则显示
                        Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          // 标签和作者之间留点空隙
                          child: Text(
                            '${articleItem.superChapterName}',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.blue[700], // 标签颜色
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        Text(
                          articleItem.author ?? articleItem.shareUser!,
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 右边的时间和点赞图标
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        articleItem.niceDate ?? "",
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      // 时间和图标之间留点空隙
                      Icon(
                        true ? Icons.favorite : Icons.favorite_border,
                        // 根据是否点赞选择图标
                        size: 18.0,
                        color:
                            true ? Colors.red : Colors.grey[600], // 点赞和未点赞的颜色
                      ),
                      // 如果点赞图标需要点击功能，可以用 IconButton 包裹 Icon
                      // IconButton(
                      //   icon: Icon(
                      //     article.isLiked ? Icons.favorite : Icons.favorite_border,
                      //     size: 18.0,
                      //     color: article.isLiked ? Colors.red : Colors.grey[600],
                      //   ),
                      //   padding: EdgeInsets.zero, // 移除默认 padding
                      //   constraints: BoxConstraints(), // 移除默认约束
                      //   onPressed: () {
                      //      // 处理点赞点击事件
                      //      print('点击了点赞');
                      //   },
                      // ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4.0), // 作者行和标题之间留点空隙
              Text(
                articleItem.title ?? "",
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.black87,
                ),
                maxLines: 2, // 限制标题最多显示两行，溢出显示省略号
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4.0), // 标题和副标题之间留点空隙
              Text(
                '${articleItem.superChapterName} · ${articleItem.chapterName}',
                style: TextStyle(fontSize: 12.0, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
