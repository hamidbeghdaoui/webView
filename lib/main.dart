import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import './config.dart';
import 'package:connectivity/connectivity.dart';

String selectedUrl = URL;
final Set<JavascriptChannel> jsChannels = [
  JavascriptChannel(
      name: 'Print',
      onMessageReceived: (JavascriptMessage message) {
        print(message.message);
      }),
].toSet();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  bool isConnect = true;
  StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    super.initState();

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        setState(() {
          isConnect = false;
        });
      } else {
        setState(() {
          isConnect = true;
        });
      }
    });
  }

  @override
  dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farah',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 20),
                clipBehavior: Clip.none,
                child: !isConnect
                    ? Center(
                        child: Text(
                          "Il n'y a pas d'Internet ....",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color.fromARGB(255, 114, 44, 72),
                              fontSize: 14),
                        ),
                      )
                    : buildWebviewScaffold(),
              ),
            ),
            buildStackBtn(),
          ],
        ),
      ),
    );
  }

  WebviewScaffold buildWebviewScaffold() {
    return WebviewScaffold(
      url: selectedUrl,
      javascriptChannels: jsChannels,
      mediaPlaybackRequiresUserGesture: true,
      // withZoom: true,
      withLocalStorage: true,
      // hidden: true,
      initialChild: Container(
        color: Colors.transparent,
        child: const Center(
          child: CircularProgressIndicator(
            backgroundColor: COLOR,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
    );
  }

  Stack buildStackBtn() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        buildBtnController(),
        buildBtnHome(),
      ],
    );
  }

  Container buildBtnController() {
    return Container(
      height: 60,
      color: COLOR_OP,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 20,
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: COLOR,
                  ),
                  onPressed: () {
                    flutterWebViewPlugin.goBack();
                  },
                ),
                IconButton(
                  iconSize: 20,
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: COLOR,
                  ),
                  onPressed: () {
                    flutterWebViewPlugin.goForward();
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            width: 60,
          ),
          IconButton(
            icon: Icon(
              Icons.replay_rounded,
              size: 30,
              color: COLOR,
            ),
            onPressed: () {
              flutterWebViewPlugin.reload();
            },
          ),
        ],
      ),
    );
  }

  Align buildBtnHome() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.transparent,
        height: 90,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                flutterWebViewPlugin.reloadUrl(selectedUrl);
              },
              child: Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                    color: COLOR,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Center(
                  child: Icon(
                    Icons.home_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Text(
              'Home',
              style: TextStyle(color: Colors.black54),
            )
          ],
        ),
      ),
    );
  }
}
