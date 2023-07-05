import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:spaca/services/home.dart';

final blockedWebsites = [
  'example1.com',
  'example2.com',
  // Add more websites here
];

class BlockedWebViewWidget extends StatefulWidget {
  const BlockedWebViewWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BlockedWebViewWidgetState createState() => _BlockedWebViewWidgetState();
}

class _BlockedWebViewWidgetState extends State<BlockedWebViewWidget> {
  InAppWebViewController? webViewController;

  bool isWebsiteBlocked(String url) {
    return blockedWebsites.any((blockedUrl) => url.contains(blockedUrl));
  }

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: Uri.parse('https://example.com')),
      onWebViewCreated: (controller) {
        webViewController = controller;
      },
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        final url = navigationAction.request.url.toString();
        if (isWebsiteBlocked(url)) {
          // Block the website
          return NavigationActionPolicy.CANCEL;
        }
        return NavigationActionPolicy.ALLOW;
      },
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blocked WebView',
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 176, 39, 39),
          foregroundColor: Colors.black,
          title: const Text('Blocked WebView'),
        leading: IconButton(
        icon: const Icon(Icons.arrow_back),
    onPressed: () {
    Navigator.pop(context);
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => const HomeScreen()));
    }
    ),
      ),
      )
    );
  }
}
