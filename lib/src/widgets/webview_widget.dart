import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smmonitoring/src/widgets/appbar.dart';
import 'package:smmonitoring/src/widgets/utils/responsive.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class WebviewWidget extends StatefulWidget {
  final String title;
  final String url;
  const WebviewWidget({super.key, required this.url, this.title = 'Webview page'});

  @override
  State<WebviewWidget> createState() => _WebviewWidgetState();
}

class _WebviewWidgetState extends State<WebviewWidget> {
  late final WebViewController _controller;
  bool isLoading = true;
  bool hasError = false;
  String? errorMessage;
  BarCustom barCustom = BarCustom();

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    // ตั้งค่าก่อนสร้าง controller
    WebViewPlatform.instance = AndroidWebViewPlatform();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // เปิด JavaScript
      ..setUserAgent('Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36')
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (mounted) {
              setState(() {
                isLoading = true;
                hasError = false;
                errorMessage = null;
              });
            }
          },
          onPageFinished: (String url) {
            if (mounted) {
              setState(() {
                isLoading = false;
              });
            }
          },
          onWebResourceError: (WebResourceError error) {
            if (mounted) {
              setState(() {
                isLoading = false;
                hasError = true;
                errorMessage = 'Error: ${error.description}';
              });
            }
            if (kDebugMode) print('WebView Error: ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (kDebugMode) ('Navigating to: ${request.url}');
            return NavigationDecision.navigate;
          },
        ),
      );

    // ตั้งค่าเพิ่มเติมสำหรับ Android
    if (_controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (_controller.platform as AndroidWebViewController)
        ..setMediaPlaybackRequiresUserGesture(false)
        ..setOnShowFileSelector(_onShowFileSelector);
    }

    // โหลด URL
    _loadUrl();
  }

  Future<List<String>> _onShowFileSelector(FileSelectorParams params) async {
    return <String>[];
  }

  void _loadUrl() {
    try {
      _controller.loadRequest(Uri.parse(widget.url));
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          hasError = true;
          errorMessage = 'Failed to load URL: $e';
        });
      }
    }
  }

  void _reload() {
    setState(() {
      isLoading = true;
      hasError = false;
      errorMessage = null;
    });
    _controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: barCustom.appBarCustomNoTabs(context, widget.title, [ IconButton(icon: Icon(Icons.refresh, color: Colors.white, size: Responsive.isTablet ? 35 : 25), onPressed: _reload) ]),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (hasError) {
      return _buildErrorWidget();
    }

    if (isLoading) {
      return Center(
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.all(20),
          child: const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white), strokeWidth: 6.0),
        ),
      );
    }

    return WebViewWidget(controller: _controller);
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Failed to load page', style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (errorMessage != null)
              Text(errorMessage!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(onPressed: _reload, icon: const Icon(Icons.refresh), label: const Text('Retry')),
                const SizedBox(width: 16),
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Go Back')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}