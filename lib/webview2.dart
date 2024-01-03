// // ignore_for_file: unused_local_variable, library_private_types_in_public_api

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// class InAppWebViewPage extends StatefulWidget {
//   const InAppWebViewPage({super.key});

//   @override
//   _InAppWebViewPageState createState() => _InAppWebViewPageState();
// }

// class _InAppWebViewPageState extends State<InAppWebViewPage> {
//   final GlobalKey webViewKey = GlobalKey();
//   InAppWebViewController? webViewController;
//   @override
//   Widget build(BuildContext context) {
//     CookieManager cookieManager = CookieManager.instance();
//     const baseUrl = 'https://digitaloffice.g4sindonesia.com/dashboard-tablet/';
//     // const controller = InAppWebViewController;

//     return Scaffold(
//         body: Column(children: <Widget>[
//       Expanded(
//         child: InAppWebView(
//           key: webViewKey,
//           initialUrlRequest: URLRequest(url: WebUri.uri(Uri.parse(baseUrl))),
//           initialOptions: InAppWebViewGroupOptions(
//               android: AndroidInAppWebViewOptions(
//                 domStorageEnabled: true,
//                 databaseEnabled: true,
//               ),
//               crossPlatform: InAppWebViewOptions(
//                   javaScriptEnabled: true,
//                   supportZoom: false,
//                   cacheEnabled: true),
//               ios: IOSInAppWebViewOptions(
//                 sharedCookiesEnabled: true,
//                 allowsInlineMediaPlayback: true,
//                 allowsAirPlayForMediaPlayback: true,
//                 allowsPictureInPictureMediaPlayback: true,
//               )),
//           onWebViewCreated: (InAppWebViewController webViewController) {},
//           initialSettings: InAppWebViewSettings(
//             mediaPlaybackRequiresUserGesture: false,
//             iframeAllow: 'camera; microphone',
//             allowsInlineMediaPlayback: true,
//           ),
//           onPermissionRequest: (webViewController, request) async {
//             return PermissionResponse(
//                 resources: request.resources,
//                 action: PermissionResponseAction.GRANT);
//           },
//           androidOnPermissionRequest: (InAppWebViewController webViewController,
//               String origin, List<String> resources) async {
//             return PermissionRequestResponse(
//                 resources: resources,
//                 action: PermissionRequestResponseAction.GRANT);
//           },
//           onReceivedServerTrustAuthRequest:
//               (webViewController, challenge) async {
//             return ServerTrustAuthResponse(
//                 action: ServerTrustAuthResponseAction.PROCEED);
//           },
//           onLoadStart: (InAppWebViewController webViewController, Uri? url) {},
//           onLoadStop: (InAppWebViewController controller, Uri? url) async {
//             if (url?.toString().startsWith(baseUrl) ?? false) {
//               // get  token from url
//               RegExp regExp = RegExp("access_token=(.*)");
//               String? token =
//                   regExp.firstMatch(url?.toString() ?? '')?.group(1);
//               if (kDebugMode) {
//                 print(token);
//               }

//               // or using CookieManager
//               Cookie? cookie = await cookieManager.getCookie(
//                   url: WebUri.uri(Uri.parse(baseUrl)), name: "access_token");
//               if (kDebugMode) {
//                 print(cookie?.value ?? '');
//               }
//               await cookieManager.setCookie(
//                 url: WebUri.uri(Uri.parse(baseUrl)),
//                 name: 'myCookie',
//                 value: 'myValue',
//                 isSecure: true,
//               );

//               // or using javascript to get access_token from localStorage
//               String? tokenFromJSEvaluation =
//                   await controller.evaluateJavascript(
//                       source: "localStorage.getItem('access_token')");
//               if (kDebugMode) {
//                 print(tokenFromJSEvaluation);
//               }
//             }
//           },
//         ),
//       ),
//     ]));
//   }
// }
