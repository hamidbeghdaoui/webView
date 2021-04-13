import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'config.dart';

class NavigationHomeControls extends StatelessWidget {
  NavigationHomeControls(this._webViewControllerFuture, this.changeSpiner)
      : assert(_webViewControllerFuture != null, changeSpiner != null);

  final Future<WebViewController> _webViewControllerFuture;
  Function changeSpiner;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController controller = snapshot.data;

        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: !webViewReady
                      ? null
                      : () {
                          changeSpiner();
                          controller.loadUrl(URL);
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
      },
    );
  }
}
