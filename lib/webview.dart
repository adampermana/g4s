import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class InAppWebViewPage extends StatefulWidget {
  @override
  _InAppWebViewPageState createState() => new _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  late InAppWebViewController webView;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Column(children: <Widget>[
      Expanded(
        child: InAppWebView(
          initialUrlRequest: URLRequest(
              url: WebUri.uri(Uri.parse(
                  'https://digitaloffice.g4sindonesia.com/dashboard-tablet/'))),
          initialOptions: InAppWebViewGroupOptions(
              android: AndroidInAppWebViewOptions(
                domStorageEnabled: true,
                databaseEnabled: true,
              ),
              crossPlatform: InAppWebViewOptions(
                javaScriptEnabled: true,
                supportZoom: false,
              )),
          onWebViewCreated: (InAppWebViewController controller) {
            webView = controller;
          },
          androidOnPermissionRequest: (InAppWebViewController controller,
              String origin, List<String> resources) async {
            return PermissionRequestResponse(
                resources: resources,
                action: PermissionRequestResponseAction.GRANT);
          },
          onLoadStart: (InAppWebViewController controller, Uri? url) {},
          onLoadStop: (InAppWebViewController controller, Uri? url) async {
            if (url?.toString().startsWith(
                    "https://digitaloffice.g4sindonesia.com/dashboard-tablet") ??
                false) {
              // get  token from url
              RegExp regExp = RegExp("access_token=(.*)");
              String? token =
                  regExp.firstMatch(url?.toString() ?? '')?.group(1);
              print(token);

              // or using CookieManager
              CookieManager cookieManager = CookieManager.instance();
              Cookie? cookie = await cookieManager.getCookie(
                  url: WebUri.uri(Uri.parse(
                      'https://digitaloffice.g4sindonesia.com/dashboard-tablet')),
                  name: "access_token");
              print(cookie?.value ?? '');

              // or using javascript to get access_token from localStorage
              String? tokenFromJSEvaluation =
                  await controller.evaluateJavascript(
                      source: "localStorage.getItem('access_token')");
              print(tokenFromJSEvaluation);
            }
          },
        ),
      ),
    ])));
  }
}
