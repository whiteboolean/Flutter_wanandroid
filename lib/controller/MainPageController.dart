import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' as getx;
import 'package:get/get_rx/get_rx.dart';
import 'package:untitled6/dio/ApiClient.dart';
import 'package:untitled6/dio/ApiUrl.dart';
import 'package:untitled6/dio/DioService.dart';
import 'package:untitled6/model/BannerResponse.dart';

import '../base/BaseResponse.dart';
import '../model/ArticleResponse.dart';

class MainPageController extends getx.GetxController {
  var bannerImages = <BannerEntity>[].obs; // 使用 .obs 将数据声明为响应式
  var isLoading = true.obs;
  var currentBannerIndex = 0.obs;

  var listItems = <ArticleItem>[].obs;
  var isLoadingMore = false.obs;
  var isRefreshing = false.obs;
  var page = 1;
  var currentListPageIndex = 1;

  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchBannerData();
    loadInitialList();
    scrollController.addListener(_scrollListener);
  }

  void loadInitialList() {
    currentListPageIndex = 1;
    fetchArticleList(false);
  }

  Future<void> refreshList() async {
    if (isRefreshing.value) return;
    isRefreshing.value = true;

    loadInitialList();

    isRefreshing.value = false;
  }

  void loadMoreData() async {
    if (isLoadingMore.value || isRefreshing.value) return;
    isLoadingMore.value = true;
    currentListPageIndex++;
    fetchArticleList(true);
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

  // 假设这是你调用 API 获取数据的方法
  Future<BaseResponse<ArticleListResponse>> fetchArticleList(bool isLoadMore) async {
    var apiClient = ApiClient.instance;
    var params = "${ApiUrl.articleList}$currentListPageIndex/json?cid=0";
    return await apiClient.get(
      params,
      parseData: (json) {
        if (!isLoadMore) {
          listItems.clear();
        }
        isLoadingMore.value = false;
        isRefreshing.value = false;
        var articleListResponse = ArticleListResponse.fromJson(json);
        if(articleListResponse.datas!=null){
          listItems.addAll(articleListResponse.datas??[]) ;
          print("返回数据的条数:${articleListResponse.datas?.length}");
        }
        return ArticleListResponse.fromJson(json);
      },
    );
  }
}
