import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

class WebView extends StatefulWidget {
  const WebView({super.key});

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  final GlobalKey webViewKey = GlobalKey();
  late final InAppWebViewController webViewController;
  CookieManager cookieManager = CookieManager.instance();
  final baseUrl = 'https://digitaloffice.g4sindonesia.com/dashboard-tablet/';

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      key: webViewKey,
      initialUrlRequest: URLRequest(url: WebUri.uri(Uri.parse(baseUrl))),
      initialOptions: InAppWebViewGroupOptions(
          android: AndroidInAppWebViewOptions(
            domStorageEnabled: true,
            databaseEnabled: true,
          ),
          crossPlatform: InAppWebViewOptions(
              javaScriptEnabled: true, supportZoom: false, cacheEnabled: true),
          ios: IOSInAppWebViewOptions(
            sharedCookiesEnabled: true,
            allowsInlineMediaPlayback: true,
            allowsAirPlayForMediaPlayback: true,
            allowsPictureInPictureMediaPlayback: true,
          )),
      onWebViewCreated: (controller) {
        webViewController = controller;
      },
      initialSettings: InAppWebViewSettings(
        mediaPlaybackRequiresUserGesture: false,
        iframeAllow: 'camera; microphone',
        allowsInlineMediaPlayback: true,
      ),
      onPermissionRequest: (controller, request) async {
        final resources = <PermissionResourceType>[];
        if (request.resources.contains(PermissionResourceType.CAMERA)) {
          final cameraStatus = await Permission.camera.request();
          if (!cameraStatus.isDenied) {
            resources.add(PermissionResourceType.CAMERA);
          }
        }
        if (request.resources.contains(PermissionResourceType.MICROPHONE)) {
          final microphoneStatus = await Permission.microphone.request();
          if (!microphoneStatus.isDenied) {
            resources.add(PermissionResourceType.MICROPHONE);
          }
        }
        // only for iOS and macOS
        if (request.resources
            .contains(PermissionResourceType.CAMERA_AND_MICROPHONE)) {
          final cameraStatus = await Permission.camera.request();
          final microphoneStatus = await Permission.microphone.request();
          if (!cameraStatus.isDenied && !microphoneStatus.isDenied) {
            resources.add(PermissionResourceType.CAMERA_AND_MICROPHONE);
          }
        }
        return PermissionResponse(
            resources: resources,
            action: resources.isEmpty
                ? PermissionResponseAction.DENY
                : PermissionResponseAction.GRANT);
      },
      androidOnPermissionRequest: (InAppWebViewController webViewController,
          String origin, List<String> resources) async {
        return PermissionRequestResponse(
            resources: resources,
            action: PermissionRequestResponseAction.GRANT);
      },
      onReceivedServerTrustAuthRequest: (webViewController, challenge) async {
        return ServerTrustAuthResponse(
            action: ServerTrustAuthResponseAction.PROCEED);
      },
      onLoadStart: (InAppWebViewController webViewController, Uri? url) {},
      onLoadStop: (InAppWebViewController controller, Uri? url) async {
        if (url?.toString().startsWith(baseUrl) ?? false) {
          // get  token from url
          RegExp regExp = RegExp("access_token=(.*)");
          String? token = regExp.firstMatch(url?.toString() ?? '')?.group(1);
          if (kDebugMode) {
            print(token);
          }

          // or using CookieManager
          Cookie? cookie = await cookieManager.getCookie(
              url: WebUri.uri(Uri.parse(baseUrl)), name: "access_token");
          if (kDebugMode) {
            print(cookie?.value ?? '');
          }
          await cookieManager.setCookie(
            url: WebUri.uri(Uri.parse(baseUrl)),
            name: 'myCookie',
            value: 'myValue',
            isSecure: true,
          );

          // or using javascript to get access_token from localStorage
          String? tokenFromJSEvaluation = await controller.evaluateJavascript(
              source: "localStorage.getItem('access_token')");
          if (kDebugMode) {
            print(tokenFromJSEvaluation);
          }
        }
      },
    );
  }
}
