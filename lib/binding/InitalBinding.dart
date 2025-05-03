// binding/initial_binding.dart
import 'package:get/get.dart';

import '../controller/AuthController.dart';
import '../dio/ApiClient.dart';
// 导入其他可能需要的全局 Controller 或 Service
// import '../controllers/settings_controller.dart';

class InitialBinding extends Bindings {

  @override
  Future<void> dependencies() async { // dependencies 可以是 async
    print("InitialBinding: Starting dependencies injection...");

    // 1. 异步注入 ApiClient (它内部会初始化 Dio 和 CookieManager)
    //    permanent: true 确保它在整个应用生命周期内存在
    //    使用 fenix: true 也是一个好主意，保证实例在后台不被意外销毁
    await Get.putAsync<ApiClient>(() => setupApiClient(), permanent: true);
    print("InitialBinding: ApiClient injected.");

    // 2. 注入 AuthController
    //    使用 put 而不是 lazyPut，确保它在启动时就被创建并开始初始化
    //    permanent: true 和 fenix: true 保证其全局可用和持久
    Get.put<AuthController>(AuthController(), permanent: true);
    print("InitialBinding: AuthController injected.");

    // 3. 注入其他全局单例服务或控制器 (如果需要)
    // Get.put<SettingsController>(SettingsController(), permanent: true);
    print("InitialBinding: Dependencies injection finished.");
  }
}