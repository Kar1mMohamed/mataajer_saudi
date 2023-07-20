import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/theme/theme.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CheckoutWebview extends StatefulWidget {
  final String checkoutUrl;
  final String successUrl;
  final String failUrl;
  final String cancelUrl;

  const CheckoutWebview(
      this.checkoutUrl, this.successUrl, this.failUrl, this.cancelUrl,
      {Key? key,
      this.onPaymentSuccess,
      this.onPaymentFailed,
      this.onPaymentCanceled})
      : super(key: key);

  final void Function(Map<String, dynamic> responseQuery)? onPaymentSuccess;
  final void Function()? onPaymentFailed;
  final void Function()? onPaymentCanceled;

  @override
  State<CheckoutWebview> createState() => _CheckoutWebviewState();
}

class _CheckoutWebviewState extends State<CheckoutWebview> {
  // late InAppWebViewController _webViewController;
  final WebViewController webViewController = WebViewController();

  bool loading = true;

// set a HTTP auth credential for a particular Protection Space

  @override
  void initState() {
    super.initState();
    initWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Builder(builder: (BuildContext context) {
        if (loading) {
          return Container(
            color: Colors.white,
            child: MataajerTheme.loadingWidget,
          );
        }
        return Container(
          color: Colors.white,
          child: KeyboardSizeProvider(
            child: Column(
              children: [
                Consumer<ScreenHeight>(builder: (context, screenHeight, child) {
                  return SizedBox(
                    width: double.infinity,
                    height: context.height - screenHeight.keyboardHeight,
                    child: WebViewWidget(
                      controller: webViewController,
                      layoutDirection: TextDirection.rtl,
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      }),
    );
  }

  void initWebView() async {
    await webViewController.loadRequest(Uri.parse(widget.checkoutUrl));
    final navigationDelegate = NavigationDelegate(
      onNavigationRequest: (request) {
        String url = request.url;
        if (url.startsWith(widget.successUrl)) {
          if (widget.onPaymentSuccess != null) {
            final urlQuery = Uri.parse(url).queryParameters;
            log('url query: $urlQuery');
            widget.onPaymentSuccess!(urlQuery);
            return NavigationDecision.prevent;
          }
        } else if (url.startsWith(widget.failUrl)) {
          if (widget.onPaymentFailed != null) {
            widget.onPaymentFailed!();
            return NavigationDecision.prevent;
          }
        } else if (url.startsWith(widget.cancelUrl)) {
          if (widget.onPaymentCanceled != null) {
            widget.onPaymentCanceled!();
            return NavigationDecision.prevent;
          }
        }
        return NavigationDecision.navigate;
      },
      onPageStarted: (String url) {
        final urlQuery = Uri.parse(url).queryParameters;
        log('url: $url ,url query: $urlQuery, successUrl: ${widget.successUrl}, failUrl: ${widget.failUrl}, cancelUrl: ${widget.cancelUrl}');

        if (url.startsWith(widget.successUrl)) {
          if (widget.onPaymentSuccess != null) {
            widget.onPaymentSuccess!(urlQuery);
            return;
          }
        } else if (url.startsWith(widget.failUrl)) {
          if (widget.onPaymentFailed != null) {
            widget.onPaymentFailed!();
            return;
          }
        } else if (url.startsWith(widget.cancelUrl)) {
          if (widget.onPaymentCanceled != null) {
            widget.onPaymentCanceled!();
            return;
          }
        }
      },
      onPageFinished: (String url) {},
    );

    await webViewController.setNavigationDelegate(navigationDelegate);

    await webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);

    setState(() {
      loading = false;
    });
  }
}
