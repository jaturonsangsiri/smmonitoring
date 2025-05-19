import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();

    // ตั้งค่าก่อนสร้าง controller
    WebViewPlatform.instance = AndroidWebViewPlatform();

    _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.disabled)
    ..setNavigationDelegate(NavigationDelegate(onPageStarted: (_) => setState(() => isLoading = true), onPageFinished: (_) => setState(() => isLoading = false)))
    ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: Text(widget.title, style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: isLoading? Center(
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.all(20),
          child: const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white), strokeWidth: 6.0,),
        ),
      ) : WebViewWidget(controller: _controller,),
    );
  }
}
