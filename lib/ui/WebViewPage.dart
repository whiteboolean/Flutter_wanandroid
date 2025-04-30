import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart'; // 导入 webview_flutter

class WebViewPage extends StatefulWidget {
  final String url; // 需要加载的 URL
  final String? title; // 页面的标题 (可选)

  const WebViewPage({
    Key? key,
    required this.url,
    this.title, // 接收可选的标题
  }) : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller; // WebView 控制器
  int _loadingPercentage = 0; // 加载进度
  bool _hasError = false; // 是否加载出错

  @override
  void initState() {
    super.initState();

    // 初始化 WebViewController
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted) // 允许执行 JavaScript
          ..setBackgroundColor(const Color(0x00000000)) // 设置背景透明 (可选)
          ..setNavigationDelegate(
            // 设置导航代理，监听加载事件
            NavigationDelegate(
              onProgress: (int progress) {
                // 更新加载进度
                debugPrint('WebView is loading (progress : $progress%)');
                if (mounted) {
                  // 确保 Widget 还在树中
                  setState(() {
                    _loadingPercentage = progress;
                    _hasError = false; // 开始加载时重置错误状态
                  });
                }
              },
              onPageStarted: (String url) {
                debugPrint('Page started loading: $url');
                if (mounted) {
                  setState(() {
                    _loadingPercentage = 0; // 页面开始加载，进度归零
                    _hasError = false;
                  });
                }
              },
              onPageFinished: (String url) {
                debugPrint('Page finished loading: $url');
                if (mounted) {
                  setState(() {
                    _loadingPercentage = 100; // 页面加载完成
                  });
                }
              },
              onWebResourceError: (WebResourceError error) {
                // 加载资源出错
                debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
                if (mounted && error.isForMainFrame == true) {
                  // 只处理主框架的错误
                  setState(() {
                    _loadingPercentage = 100; // 停止加载进度条
                    _hasError = true; // 标记出错
                  });
                }
              },
              onNavigationRequest: (NavigationRequest request) {
                // 可以在这里决定是否允许导航到新的 URL
                // 例如，阻止打开非 http/https 的链接
                // if (request.url.startsWith('some_scheme://')) {
                //   debugPrint('blocking navigation to $request}');
                //   return NavigationDecision.prevent;
                // }
                debugPrint('allowing navigation to ${request.url}');
                return NavigationDecision.navigate; // 允许导航
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.url)); // 加载初始 URL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? '加载中...'), // 显示传入的标题或默认文本
        actions: [
          // 可以添加刷新按钮等
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _controller.reload(); // 重新加载当前页面
            },
          ),
        ],
      ),
      body: Stack(
        // 使用 Stack 来叠加加载指示器和错误提示
        children: [
          // WebView Widget
          WebViewWidget(controller: _controller),

          // 加载进度条 (加载中且未出错时显示)
          if (_loadingPercentage < 100 && !_hasError)
            LinearProgressIndicator(
              value: _loadingPercentage / 100.0,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),

          // 错误提示 (出错时显示)
          if (_hasError)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 50),
                  SizedBox(height: 10),
                  Text(
                    '页面加载失败',
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _controller.reload(),
                    child: Text('点击重试'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
