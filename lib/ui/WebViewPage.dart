import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key}) : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  WebViewController? _controller;
  int _loadingPercentage = 0;
  bool _isLoading = true;
  bool _hasLoadError = false;
  String? _initialUrl;
  String? _pageTitle;

  @override
  void initState() {
    super.initState();
    final arguments = Get.arguments as Map<String, dynamic>?;
    _initialUrl = arguments?['url'] as String?;
    _pageTitle = arguments?['title'] as String?;

    if (_initialUrl != null && _initialUrl!.isNotEmpty) {
      _controller = WebViewController()
      // ... (之前的 WebView 配置保持不变) ...
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              if (mounted) {
                setState(() => _loadingPercentage = progress);
              }
            },
            onPageStarted: (String url) {
              if (mounted) {
                setState(() {
                  _isLoading = true;
                  _hasLoadError = false;
                  _loadingPercentage = 0;
                });
              }
            },
            onPageFinished: (String url) {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                  _loadingPercentage = 100;
                });
              }
            },
            onWebResourceError: (WebResourceError error) {
              if (mounted && error.isForMainFrame == true) {
                debugPrint('Page resource error: ${error.description}');
                setState(() {
                  _isLoading = false;
                  _hasLoadError = true;
                  _loadingPercentage = 100;
                });
              }
            },
          ),
        )
        ..loadRequest(Uri.parse(_initialUrl!));
    } else {
      print("Error: WebViewPage received null or empty URL");
      // 可以在 build 中显示错误，或者直接标记 _hasLoadError
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if(mounted){
          setState(() {
            _isLoading = false;
            _hasLoadError = true; // URL 无效也算加载错误
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 使用 PopScope 包裹 Scaffold
    return PopScope(
      canPop: false, // 设置为 false，表示默认情况下不允许直接弹出
      onPopInvoked: (bool didPop) async { // 拦截弹出事件
        // 如果 didPop 为 true，说明是由于其他原因（比如代码调用Navigator.pop）导致了弹出，
        // 我们通常不需要处理这种情况，直接返回即可。
        if (didPop) {
          return;
        }

        // 检查 WebView 是否可以返回
        final controller = _controller; // 局部变量防止异步问题
        if (controller != null && await controller.canGoBack()) {
          // 如果可以返回，执行 WebView 的返回操作
          await controller.goBack();
          // 因为 canPop 是 false，这个 pop 已经被阻止了，我们不需要再做什么
        } else {
          // 如果 WebView 不能返回（或者 controller 为 null），
          // 那么我们允许 Flutter 的 Navigator 弹出当前页面
          if (mounted) { // 检查 widget 是否还在树中
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          // AppBar 保持不变
          title: Text(_pageTitle ?? (_controller == null ? '链接错误' : '加载中...')),
          actions: _controller == null ? null : [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _controller?.reload(),
            ),
            // 可以添加关闭按钮，明确退出 WebView
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
          // 你可能需要自定义 leading，因为 PopScope 会影响默认的返回按钮
          // leading: IconButton(
          //   icon: const Icon(Icons.arrow_back),
          //   onPressed: () {
          //     // 手动触发 onPopInvoked 的逻辑
          //     _handleBackButton();
          //   },
          // ),
        ),
        body: Stack(
          // Stack 和内部逻辑保持不变
          children: [
            if (_controller == null && !_isLoading) // URL 无效或控制器初始化失败
              const Center(
                child: Text(
                  '无法加载页面：链接无效',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),

            if (_controller != null)
              WebViewWidget(controller: _controller!),

            if (_controller != null && _isLoading && !_hasLoadError)
              LinearProgressIndicator(
                value: _loadingPercentage / 100.0,
                // ...
              ),

            if (_controller != null && _hasLoadError)
              Center(
                child: Column(
                  // ... 错误提示和重试按钮 ...
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 50),
                    SizedBox(height: 10),
                    Text('页面加载失败', style: TextStyle(fontSize: 16, color: Colors.red)),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (_initialUrl != null && _initialUrl!.isNotEmpty) {
                          setState(() {
                            _hasLoadError = false;
                            _isLoading = true;
                            _loadingPercentage = 0;
                          });
                          _controller?.loadRequest(Uri.parse(_initialUrl!));
                        }
                      },
                      child: Text('点击重试'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

// (可选) 如果你需要自定义 AppBar 的返回按钮，可以调用这个方法
// void _handleBackButton() async {
//      final controller = _controller;
//      if (controller != null && await controller.canGoBack()) {
//         await controller.goBack();
//      } else {
//         if (mounted) {
//            Navigator.of(context).pop();
//         }
//      }
// }
}