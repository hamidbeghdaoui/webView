import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'config.dart';

class NavigationReloadControls extends StatelessWidget {
  NavigationReloadControls(this._webViewControllerFuture, this.changeSpiner)
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
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 150),
            child: FloatingActionButton(
              onPressed: !webViewReady
                      ? null
                      : () {
                          changeSpiner();
                          controller.reload();
                        },
              child: Icon(
                Icons.replay_rounded,
                color: Colors.white,
              ),
              backgroundColor: COLOR,
            ),
          ),
        );
      },
    );
  }
}
