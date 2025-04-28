import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled6/MainListPage.dart';
import 'package:untitled6/ProductController.dart';

class  ProductListPage extends StatelessWidget {
  final ProductController productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("一起学安卓") ),
      body: Obx(() {
        if (productController.productList.isEmpty) {
          return Center(child: Text("No products available"));
        }
        // return ListView.builder(
        //   itemCount: productController.productList.length,
        //   itemBuilder: (context, index) {
        //     final product = productController.productList[index];
        //     return ListTile(
        //       title: Text(product.name),
        //       subtitle: Text("\$${product.price.toStringAsFixed(2)}"),
        //       onTap: () {
        //         // Get.to(ProductDetailsPage(product: product));
        //       },
        //     );
        //   },
        // );

        return MainListPage();

        // return ListView(
        //   shrinkWrap: true, //
        //   children: [const Text("你好"), BannerPage()],
        // );
      }),
    );
  }
}
