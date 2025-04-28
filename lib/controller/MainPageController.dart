import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' as getx;
import 'package:get/get_rx/get_rx.dart';
import 'package:untitled6/dio/ApiClient.dart';
import 'package:untitled6/dio/ApiUrl.dart';
import 'package:untitled6/dio/DioService.dart';
import 'package:untitled6/model/BannerResponse.dart';

class MainPageController extends getx.GetxController {
  var bannerImages = <BannerEntity>[].obs; // 使用 .obs 将数据声明为响应式
  var isLoading = true.obs;
  var currentBannerIndex = 0.obs;

  var listItems = <String>[].obs;
  var isLoadingMore = false.obs;
  var isRefreshing = false.obs;
  var page = 1;
  var currentListPageIndex = 1 ;

  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchBannerData(); // 初始化时加载数据
    loadInitialList();
    scrollController.addListener(_scrollListener);
  }

  void loadInitialList() {
    listItems.clear();
    page = 1;
    listItems.addAll(List.generate(20, (index) => 'Item ${index + 1}'));
  }

  Future<void> refreshList() async {
    if (isRefreshing.value) return;
    isRefreshing.value = true;

    await Future.delayed(Duration(seconds: 2)); // 模拟请求
    loadInitialList();

    isRefreshing.value = false;
  }

  void loadMoreData() async {
    if (isLoadingMore.value || isRefreshing.value) return;
    isLoadingMore.value = true;

    await Future.delayed(Duration(seconds: 2)); // 模拟请求

    if (page < 3) {
      page++;
      listItems.addAll(
        List.generate(20, (index) => 'Item ${listItems.length + index + 1}'),
      );
    }

    isLoadingMore.value = false;
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 100) {
      loadMoreData();
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  // 调用网络接口获取 Banner 数据
  Future<void> fetchBannerData() async {
    // 获取 DioService 实例并发起 GET 请求
    var dioService = DioService.instance;
    try {
      var data = await dioService.get(ApiUrl.banner);
      // 解析 response.data，而不是 response 本身
      Map<String, dynamic> jsonData = data;
      // 将 jsonData 转化为你需要的数据模型
      BannerResponse bannerResponse = BannerResponse.fromJson(jsonData);
      bannerImages.value = bannerResponse.data;
      isLoading.value = false;
      print(bannerResponse.data);
    } catch (e) {
      print('Error: $e');
      isLoading.value = false;
    }
  }

  //调用接口获取文章列表
  Future<void> fetchArticleList() async {
    // var dio = DioService.instance;

    var params  = "$currentBannerIndex?cid=0&page_size=40";

    var data = ApiClient.instance.get(ApiUrl.articleList+params, parseData: parseData)

    // https://www.wanandroid.com/article/list/1/json?cid=0&page_size=40



  }
}
