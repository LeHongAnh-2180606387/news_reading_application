import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:share_plus/share_plus.dart'; // Import share_plus

class WebViewScreen extends StatelessWidget {
  final String url;

  const WebViewScreen({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WebUri? webUri = WebUri.uri(Uri.tryParse(url)!);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'News Article',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: webUri),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _shareUrl();
        },
        child: const Icon(Icons.share),
      ),
    );
  }

  void _shareUrl() {
    Share.share(url);
  }
}
