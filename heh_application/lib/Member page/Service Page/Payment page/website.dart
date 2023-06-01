import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class VNPayPage extends StatefulWidget {
  VNPayPage({Key? key, this.payments}) : super(key: key);
  String? payments;

  @override
  State<VNPayPage> createState() => _VNPayPageState();
}

class _VNPayPageState extends State<VNPayPage> {
  InAppWebViewController? _webViewController;
  double _progress = 0;
  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialUrlRequest: URLRequest(
        url: Uri.parse(widget.payments!),
      ),
      onWebViewCreated: (controller) {
        _webViewController = controller;
      },
      onProgressChanged: (controller, progress) {
        setState(() {
          _progress = progress / 100;
        });
      },
      onLoadStop: (controller, url) {
        String domainName = Uri.parse(widget.payments!).host;

        // Check if the domain name contains a random subdirectory.
        bool containsRandomSubdirectory = domainName.contains(
            r'https://taskuatapi.hisoft.vn/api/Payment/callbackVNPayGW');
        if (containsRandomSubdirectory) {
          // Navigator.pop(context);
          controller.goBack();
        }
      },
    );
  }
}
