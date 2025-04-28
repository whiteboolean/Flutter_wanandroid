import 'package:get/get.dart';

import 'Product.dart';

class ProductController extends GetxController {
  //响应式列表
  var productList = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    //模拟从API获取数据
    fetchProducts();
  }

  //模拟数据获取
  void fetchProducts() {
    var products = [
      Product(name: "Apple", price: 1.99),
      Product(name: "Banana", price: 0.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
      Product(name: "Grapes", price: 2.99),
    ];
    productList.assignAll(products);
  }
}
