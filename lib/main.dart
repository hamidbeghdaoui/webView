import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import './navigationControls.dart';
import './navigationHomeControls.dart';
import './naviationReloadControls.dart';
import './config.dart';

void main() => runApp(MaterialApp(
      home: WebViewExample(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primaryColor: Colors.green,
          accentColor: Color(0xFFFEF9EB),
          fontFamily: 'Almarai'),
    ));

class WebViewExample extends StatefulWidget {
  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  bool spiner = true;
  Color colorApp = COLOR;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: NavigationReloadControls(_controller.future, this.onChangeSpiner),
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              children: [buildWebView(), buildArrow()],
            ),
            buildHomeWebView(),
          ],
        ),
      ),
    );
  }

  NavigationHomeControls buildHomeWebView() {
    return NavigationHomeControls(_controller.future, this.onChangeSpiner);
  }

  NavigationControls buildArrow() {
    return NavigationControls(_controller.future);
  }

  Expanded buildWebView() {
    return Expanded(
        child: Stack(
      children: [
        Container(
          // color: Colors.white,
          child: WebView(
            initialUrl: URL,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            onProgress: (int progress) {
              print("WebView is loading (progress : $progress%)");
            },
            javascriptChannels: <JavascriptChannel>{
              _toasterJavascriptChannel(context),
            },
            navigationDelegate: (NavigationRequest request) {
              if (request.url.startsWith(URL)) {
                print('blocking navigation to $request}');
                return NavigationDecision.prevent;
              }
              print('allowing navigation to $request');
              return NavigationDecision.navigate;
            },
            onPageStarted: (String url) {
              print('Page started loading: $url');
            },
            onPageFinished: (String url) {
              print('Page finished loading: $url');
              setState(() {
                spiner = false;
              });
            },
            gestureNavigationEnabled: true,
          ),
        ),
        spiner
            ? Container(
                color: Colors.black26,
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: colorApp,
                  ),
                ),
              )
            : SizedBox()
      ],
    ));
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  onChangeSpiner() {
    setState(() {
      spiner = true;
    });
  }
}
