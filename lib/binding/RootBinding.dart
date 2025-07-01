import 'package:get/get.dart';
import 'package:untitled6/controller/MainTabController.dart';

///
/// 1.依赖注入设置 (Dependency Injection Setup):
/// Bindings 类的主要目的（比如你的 RootBinding）是声明特定路由（及其小部件/控制器）所需的依赖项应该如何被创建和提供。
/// 你需要在你的 Bindings 类的 dependencies() 方法内部定义这些依赖项。
///
/// 2.生命周期管理 (Lifecycle Management): 当你导航到一个配置了 binding 的 GetPage 时：
/// •初始化 (Initialization): GetX 会自动调用指定的 Bindings 类（在你的例子中是 RootBinding）的 dependencies() 方法。
/// 这里就是你的控制器和其他服务被实例化并注册到 GetX 依赖管理器的地方。
/// •可用性 (Availability): 一旦依赖项被 "put"（例如，通过 Get.put(), Get.lazyPut(), Get.putAsync()），它们就可以在路由的小部件或其控制器中使用 Get.find() 来获取。
/// 3.作用域依赖 (Scoped Dependencies): Bindings 有助于创建作用域依赖。
/// 在 RootBinding 中定义的依赖项主要用于 RootPage，如果它们是同个路由作用域的一部分，也可能用于其在小部件树中的直接子级。其他路由可能会有它们自己的 bindings，从而创建它们自己的一组作用域依赖。
///
/// 当你导航到 AppRoutes.root 路由（它会加载 RootPage）时：
/// 1.GetX 会看到 binding: RootBinding() 这部分。
/// 2.它会创建一个 RootBinding 的实例。
/// 3.它会调用你的 RootBinding 类中的 dependencies() 方法。
/// 4.RootBinding.dependencies() 内部所有 Get.put()、Get.lazyPut() 等调用都会被执行（在你的例子中是 Get.lazyPut<MainTabController>(() => MainTabController());）。
/// 5.然后 RootPage（以及它的控制器，如果它有一个使用 Get.find() 的控制器）就可以访问这些已初始化的依赖项。
/// 6.当 RootPage 从导航栈中移除时，由 RootBinding 设置的依赖项（比如 MainTabController 的实例）将会被 GetX 销毁。
///
/// 为什么这样做很有用？
/// •解耦 (Decoupling): 它将依赖项的创建与使用它们的小部件/控制器分离开来。你的页面不需要知道如何创建它的控制器；它只是向 GetX 请求。
/// •组织性 (Organization): 它为管理应用程序特定功能或部分的依赖项提供了一个专门的地方。
/// •懒加载 (Lazy Loading): 使用 Get.lazyPut()，依赖项仅在首次需要时才被创建，从而提高应用的初始性能。
/// •自动清理 (Automatic Cleanup): 通过在依赖项不再与当前导航状态相关时自动销毁控制器和服务，简化了内存管理。
/// •可测试性 (Testability): 在测试期间更容易模拟（mock）依赖项，因为你可以在测试设置中提供不同的 bindings。
/// 总而言之，binding: RootBinding() 是 GetX 的一种机制，用于确保当 RootPage 处于活动状态时，其所需的控制器和服务（在 RootBinding 中定义）能够被初始化、可用，并在页面不再使用时得到正确的清理。
/// 在你的例子中，它确保了 MainTabController 的生命周期与 RootPage 的路由相关联。
class RootBinding extends Bindings {
  @override
  void dependencies() {
    // 使用 lazyPut，当第一次需要 Controller 时才创建它
    Get.lazyPut<MainTabController>(() => MainTabController());
    // 如果你的 MainListPage 有自己的 Controller，也在这里绑定
    // Get.lazyPut<MainPageController>(() => MainPageController());
    // 其他 Tab 页面的 Controller...
  }
}
