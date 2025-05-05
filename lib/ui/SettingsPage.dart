import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("设置").textColor(Colors.white),
        centerTitle: true,
        backgroundColor: Color(0xFF5380ed),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "退出登录",
                ).fontSize(16).paddingHorizontal(15).paddingVertical(15),
              ),
              Icon(Icons.chevron_right).paddingRight(15)
            ],
          ),
        ],
      ),
    );
  }
}
