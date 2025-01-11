import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewScreen extends StatelessWidget {
  final String url;

  const WebViewScreen({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WebUri? webUri = WebUri.uri(Uri.tryParse(url)!);
    return Scaffold(
      appBar: AppBar(title: const Text('News Article', style: TextStyle(fontSize: 20),)),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: webUri),
      ),
    );
  }
}
