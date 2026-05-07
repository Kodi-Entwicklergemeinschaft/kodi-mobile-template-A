import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

// TODO: Custom webview doesn't support geolocation handling. Need to implement it when integrating suc services.
class CustomWebViewScreen extends StatefulWidget {
  final String url;
  final String? title;

  const CustomWebViewScreen({
    super.key,
    required this.url,
    this.title,
  });

  @override
  State<CustomWebViewScreen> createState() => _CustomWebViewScreenState();

  static void showAsBottomSheet({
    required BuildContext context,
    required String url,
    String? title,
  }) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              // padding: const EdgeInsets.only(top: kToolbarHeight),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: CustomWebViewScreen(
                url: url,
                title: title,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CustomWebViewScreenState extends State<CustomWebViewScreen> {
  InAppWebViewController? webViewController;
  bool isLoading = true;
  Timer? _timer;

  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
    Factory<VerticalDragGestureRecognizer>(
      () => VerticalDragGestureRecognizer(),
    ),
  };

  final mangelmelderHtml = """
        <!DOCTYPE html>
        <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <script defer src="https://www.meldooplus.de/webV3/js/bundle.min.js"></script>
        </head>
        <body style="margin:0;padding:0;">
          <div id="webReportsContainer" data-key="rottenburg"></div>
        </body>
        </html>
        """;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = theme.scaffoldBackgroundColor;
    final loaderColor = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        backgroundColor: backgroundColor,
        title: Text(
          (widget.title ?? widget.url.toString()),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
            child: InAppWebView(
              // initialUrlRequest:
              //     URLRequest(url: WebUri.uri(Uri.parse(widget.url))),
              gestureRecognizers: gestureRecognizers,
              onWebViewCreated: (controller) {
                webViewController = controller;
                if (widget.url.trim().startsWith("<!DOCTYPE html>") ||
                    widget.url.trim().startsWith("<html")) {
                  controller.loadData(data: widget.url);
                } else {
                  controller.loadUrl(
                    urlRequest: URLRequest(url: WebUri.uri(Uri.parse(widget.url))),
                  );
                }
              },
              onLoadStart: (controller, url) {
                setState(() {
                  isLoading = true;
                });
                _startProgressTimer();
              },
              onLoadStop: (controller, url) async {
                if (Platform.isIOS) {
                  await controller.evaluateJavascript(source: """
                  var metaTags = document.querySelectorAll('meta[http-equiv="Content-Security-Policy"]');
                  metaTags.forEach(function(tag) { tag.parentNode.removeChild(tag); });
                """);
                }

                _timer?.cancel;
                _timer = null;
                setState(() {
                  isLoading = false;
                });

                // // Hide elements with the "flex" class - Commenting it since Daniel don't remember why it was added
                // await controller.evaluateJavascript(
                //   source:
                //       "document.querySelector('.flex').style.display = 'none';",
                // );
              },
              onPermissionRequest: null,
              initialSettings: InAppWebViewSettings(
                  useWideViewPort: null,
                  geolocationEnabled: null,
                  javaScriptEnabled: true,
                  domStorageEnabled: true,
                  allowsInlineMediaPlayback: true,
                  mediaPlaybackRequiresUserGesture: false,
                  iframeAllow: "camera; microphone",
                  userAgent:
                      "Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36"),
              onReceivedServerTrustAuthRequest: (controller, challenge) async {
                return ServerTrustAuthResponse(
                    action: ServerTrustAuthResponseAction.PROCEED);
              },
              onGeolocationPermissionsShowPrompt: null,
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                final url = navigationAction.request.url.toString();
                if (url.startsWith("https://go.ridedott.com/vehicles/")) {
                  _launchUrlExternally(url);
                  return NavigationActionPolicy
                      .CANCEL; // Prevent navigation inside WebView
                }
                return NavigationActionPolicy.ALLOW;
              },
            ),
          ),

          // Loading indicator overlay
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: backgroundColor
                    .withAlpha((0.8 * 255).toInt()), // Matches theme
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(loaderColor),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _launchUrlExternally(String url) async {
    try {
      final uri = Uri.parse(url);
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      // ignore: empty_catches
    } catch (e) {}
  }

  void _startProgressTimer() {
    _timer = Timer(const Duration(seconds: 5), () {
      if (isLoading) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }
}
