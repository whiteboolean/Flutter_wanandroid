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
  var currentListPageIndex = 0;
  final scrollController = ScrollController();

  // 定义一个最小刷新显示时间（例如 800 毫秒）
  final Duration _minimumRefreshDuration = Duration(milliseconds: 500);

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

    isRefreshing.value = true; // 可以用来表示后台正在刷新，但不直接控制 RefreshIndicator
    currentListPageIndex = 1;
    // 注意：不要在这里 clear listItems，否则在延迟期间列表会变空

    // 1. 创建数据获取的 Future (但不立即 await)
    //    将实际的数据获取和处理逻辑封装到一个单独的 async 函数中
    Future<void> dataFetchFuture = fetchArticleList(false);

    // 2. 创建一个延时 Future
    Future<void> delayFuture = Future.delayed(_minimumRefreshDuration);

    try {
      // 3. 使用 Future.wait 等待数据获取和最小延时都完成
      //    RefreshIndicator 会等待这个 Future.wait 完成后才停止动画
      await Future.wait([dataFetchFuture, delayFuture]);

    } catch (e) {
      // 如果 _fetchAndProcessFirstPage 抛出错误，这里会捕获
      print("Error refreshing data: $e");
      getx.Get.snackbar('错误', '刷新数据失败');
      // 即使出错，动画也会在最小延迟后或错误发生后（取决于哪个更晚）结束
    } finally {
      // 4. 无论成功或失败，最终将 isLoading 状态设回 false
      //    （注意：这个 isLoading 主要用于你自己的逻辑，
      //     RefreshIndicator 的显示/隐藏由 onRefresh 返回的 Future 控制）
      isLoading.value = false;
    }
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
