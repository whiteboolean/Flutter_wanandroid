import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginAndRegisterPage extends StatelessWidget {
  LoginAndRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: const Icon(Icons.close_rounded, color: Colors.white).onTap(() {
          // 检查 widget 是否还在树中
          Navigator.of(context).pop();
        }),
      ),
      body: ListView(
        children: [
          Center(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    "assets/images/dudu3.webp",
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                Text("Welcome To Use!")
                    .textColor(Colors.white)
                    .fontSize(24)
                    .paddingTop(20)
                    .paddingBottom(15),
                Text(
                  "This App Is Developed By WhiteBoolean !",
                ).textColor(Colors.white).fontSize(18).paddingBottom(20),
              ],
            ),
          ).backgroundColor(Colors.blue),
          const TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email',
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(),
            ),
          ).paddingHorizontal(20).paddingTop(30),
          const SizedBox(height: 16),

          // Password Input
          const TextField(
            obscureText: true, // Hide password by default
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(),
            ),
          ).paddingHorizontal(20).paddingTop(10),

          const SizedBox(height: 32),

          // Login Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                print('Login button pressed');
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Login', style: TextStyle(fontSize: 18)),
            ),
          ).paddingHorizontal(20),
        ],
      ),
    );
  }
}
