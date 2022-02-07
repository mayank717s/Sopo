import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GoogleScreen extends StatelessWidget {
  final String link;
  const GoogleScreen({Key? key, required this.link}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final barColor = const Color(0xFFE94C21);
    final bgColor = const Color(0xFF151515);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: barColor,
      ),
      body: SafeArea(
        child: WebView(
          backgroundColor: bgColor,
          initialUrl: link,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
