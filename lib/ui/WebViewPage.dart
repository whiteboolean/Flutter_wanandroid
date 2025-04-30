import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 导入 GetX
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  // 不再需要构造函数参数 url 和 title
  const WebViewPage({Key? key}) : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  WebViewController? _controller; // 改为 nullable，因为可能初始化失败
  int _loadingPercentage = 0;
  bool _isLoading = true; // 初始状态是加载中
  bool _hasLoadError = false; // 标记是否是加载过程中出错

  String? _initialUrl; // 用于存储从 Get.arguments 获取的 URL
  String? _pageTitle; // 用于存储从 Get.arguments 获取的 Title

  @override
  void initState() {
    super.initState();

    // 通过 Get.arguments 获取传递过来的参数
    final arguments = Get.arguments as Map<String, dynamic>?; // 断言为 Map 或 null
    _initialUrl = arguments?['url'] as String?; // 获取 url
    _pageTitle = arguments?['title'] as String?; // 获取 title

    // 只有当 URL 有效时才初始化 WebView 控制器
    if (_initialUrl != null && _initialUrl!.isNotEmpty) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              if (mounted) {
                setState(() {
                  _loadingPercentage = progress;
                });
              }
            },
            onPageStarted: (String url) {
              if (mounted) {
                setState(() {
                  _isLoading = true;
                  _hasLoadError = false; // 重置错误状态
                  _loadingPercentage = 0;
                });
              }
            },
            onPageFinished: (String url) {
              if (mounted) {
                setState(() {
                  _isLoading = false; // 加载完成
                  _loadingPercentage = 100;
                });
              }
            },
            onWebResourceError: (WebResourceError error) {
              // 只处理主框架错误以显示错误页面
              if (mounted && error.isForMainFrame == true) {
                debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
                ''');
                setState(() {
                  _isLoading = false; // 加载结束（虽然是失败）
                  _hasLoadError = true; // 标记加载出错
                  _loadingPercentage = 100;
                });
              }
            },
            // onNavigationRequest 可以保持不变
          ),
        )
        ..loadRequest(Uri.parse(_initialUrl!)); // 加载获取到的 URL
    } else {
      // 如果 URL 无效，在 build 方法中处理错误显示
      print("Error: WebViewPage received null or empty URL via Get.arguments");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 优先使用传递的 title，如果 URL 无效显示错误，否则显示加载中
        title: Text(_pageTitle ?? (_controller == null ? '链接错误' : '加载中...')),
        actions: _controller == null ? null : [ // 只有控制器有效时才显示操作按钮
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _controller?.reload(); // 使用 ?. 防止 controller 为 null 时出错
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // 1. 处理 URL 无效的情况 (控制器未初始化)
          if (_controller == null)
            const Center(
              child: Text(
                '无法加载页面：链接无效或丢失',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),

          // 2. 控制器有效，显示 WebView
          if (_controller != null)
            WebViewWidget(controller: _controller!),

          // 3. 控制器有效，且正在加载中，且未出错时，显示进度条
          if (_controller != null && _isLoading && !_hasLoadError)
            LinearProgressIndicator(
              value: _loadingPercentage / 100.0,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),

          // 4. 控制器有效，且加载出错时，显示错误提示和重试按钮
          if (_controller != null && _hasLoadError)
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
                    onPressed: () {
                      // 重试时重置状态并重新加载
                      setState(() {
                        _hasLoadError = false;
                        _isLoading = true;
                        _loadingPercentage = 0;
                      });
                      _controller?.loadRequest(Uri.parse(_initialUrl!));
                    },
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