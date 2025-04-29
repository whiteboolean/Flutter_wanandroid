import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:untitled6/ui/ArticleListView.dart';

import 'controller/MainPageController.dart';

class MainListPage extends StatelessWidget {
  MainListPage({super.key});

  final MainPageController mainPageController = Get.put(MainPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('GetX Banner Example')),
      body: Obx(() {
        // 如果数据正在加载，显示加载指示器
        if (mainPageController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: mainPageController.refreshList,
          child: listView(),
        );
      }),
    );
  }

  //获取 首页文章 ArticleController 实例
  Widget listView() {
    // 计算总 item 数量
    // 1 (Banner) + listItems.length (文章) + (isLoadingMore.value ? 1 : 0) (加载更多指示器)
    int totalItems = 1 + mainPageController.listItems.length;
    if (mainPageController.isLoadingMore.value) {
      totalItems += 1; // 如果正在加载更多，增加一个 item 的位置
    }
    return ListView.builder(
      shrinkWrap: true,
      // 假设顶部插图是单独的，如果插图是列表的一部分，itemCount 要加1
      itemCount: 1 + mainPageController.listItems.length + 1,
      // 轮播 + 列表 + loading
      controller: mainPageController.scrollController,
      itemBuilder: (context, index) {
        print("当前列表的索引值index:$index");
        if (index == 0) {
          // 索引 0 总是 Banner
          return buildBannerView();
        } else if (index < 1 + mainPageController.listItems.length) {
          // 索引从 1 到 listItems.length 是文章项
          // 对应的 listItems 索引是 index - 1
          final articleIndex = index - 1;
          // 理论上 itemCount 计算正确时，这里不会越界，但加上断言或检查也无妨
          // assert(articleIndex >= 0 && articleIndex < mainPageController.listItems.length);

          final article = mainPageController.listItems[articleIndex];
          return ArticleListItem(articleItem: article); // 传递文章数据

        } else {
          // 剩余的索引（只有一个，即 totalItems - 1）是加载更多指示器
          // 只有当 totalItems 包含了加载更多项时才会走到这里
          return buildLoadingMore();
        }
      },
    );
  }

  Widget buildBannerView() {
    return Center(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CarouselSlider(
            options: CarouselOptions(
              autoPlay: true, // 自动轮播
              aspectRatio: 22 / 12, // 宽高比
              enlargeCenterPage: true, // 当前页面放大效果
              onPageChanged: (index, reason) {
                mainPageController.currentBannerIndex.value = index;
              },
            ),
            items:
                mainPageController.bannerImages.map((bannerData) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      bannerData.imagePath,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  );
                }).toList(),
          ),
          Obx(() {
            return Container(
              margin: EdgeInsets.only(bottom: 15), // 调整底部距离
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  mainPageController.bannerImages.length,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          mainPageController.currentBannerIndex.value == index
                              ? Colors.green
                              : Colors.grey,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget buildLoadingMore() {
    return Obx(
      () =>
          mainPageController.isLoadingMore.value
              ? Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              )
              : SizedBox.shrink(),
    );
  }
}
