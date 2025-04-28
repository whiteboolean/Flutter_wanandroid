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
    return ListView.builder(
      shrinkWrap: true,
      // 假设顶部插图是单独的，如果插图是列表的一部分，itemCount 要加1
      itemCount: 1 + mainPageController.listItems.length + 1,
      // 轮播 + 列表 + loading
      controller: mainPageController.scrollController,
      itemBuilder: (context, index) {
        if (index == 0) {
          return buildBannerView();
        } else if (index == mainPageController.listItems.length + 1 - 1) {
          // final article = articles[index]; // 获取当前的文章数据
          return buildLoadingMore(); // 使用自定义的列表项 Widget
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ArticleListItem(),
          ); // 使用自定义的列表项 Widget
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
