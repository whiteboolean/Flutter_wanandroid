
import 'package:get/get.dart';
import 'package:untitled6/controller/MainTabController.dart';

class RootBinding extends Bindings{
  @override
  void dependencies() {
    // 使用 lazyPut，当第一次需要 Controller 时才创建它
    Get.lazyPut<MainTabController>(() => MainTabController());
    // 如果你的 MainListPage 有自己的 Controller，也在这里绑定
    // Get.lazyPut<MainPageController>(() => MainPageController());
    // 其他 Tab 页面的 Controller...
  }


}