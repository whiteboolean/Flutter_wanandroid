import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled6/ProductListPage.dart';

class PageOne extends StatefulWidget {
  const PageOne({Key? key}) : super(key: key);

  @override
  State<PageOne> createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Page One")),
      body: _buildView(context),
    );
  }
}

Widget _buildView(BuildContext context) {
  bool pressed = false;
  final name = RxString("a");
  return Text("圆角按钮")
      .fontSize(22)
      .alignment(Alignment.center)
      .borderRadius(all: 15)
      .ripple()
      .backgroundColor(Colors.white, animate: true)
      .clipRRect(all: 25) // clip ripple
      .borderRadius(all: 25, animate: true)
      .elevation(
        pressed ? 0 : 1,
        borderRadius: BorderRadius.circular(25),
        shadowColor: Color(0x30000000),
      ) // shadow borderRadius
      .padding(vertical: 12) // margin
      .onTap(
        () => //上下文导航操作
            context.navigator.pushMaterial(ProductListPage()),
      )
      .scale(all: pressed ? 0.95 : 1.0, animate: true)
      .animate(Duration(milliseconds: 150), Curves.easeOut)
      .tight(height: 80, width: 200)
      .center();
}
