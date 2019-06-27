import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import './amap_nav_controller.dart';
import './amap_nav_options.dart';

const _viewType = 'plugin/amap/nav';
typedef void NavViewCreateCallHandler(AMapNavController controller);

class AMapNavView extends StatelessWidget {
  final NavViewCreateCallHandler onNavViewCreate;
  final AMapNavOptions options;

  /// 使用此回调会拦截返回事件，需要自己实现pop
  final NavCloseHandler onCloseHandler;
  final NavMoreHandler onMoreHandler;

  const AMapNavView({
    Key key,
    this.onNavViewCreate,
    this.options,
    this.onCloseHandler,
    this.onMoreHandler,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gestureRecognizers = <Factory<OneSequenceGestureRecognizer>>[
      Factory<OneSequenceGestureRecognizer>(
        () => EagerGestureRecognizer(),
      ),
    ].toSet();

    if (Platform.isIOS) {
      return UiKitView(
        viewType: _viewType,
        gestureRecognizers: gestureRecognizers,
        creationParamsCodec: StandardMessageCodec(),
        creationParams: options == null ? AMapNavOptions().toJsonString() : options.toJsonString(),
        onPlatformViewCreated: _onPlatformViewCreated,
        hitTestBehavior: PlatformViewHitTestBehavior.translucent,
      );
    } else if (Platform.isAndroid) {
      return AndroidView(
        viewType: _viewType,
        gestureRecognizers: gestureRecognizers,
        creationParamsCodec: StandardMessageCodec(),
        creationParams: options == null ? AMapNavOptions().toJsonString() : options.toJsonString(),
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    } else {
      return Text(
        'AMap_plugin does not support $defaultTargetPlatform',
      );
    }
  }

  void _onPlatformViewCreated(int viewId) {
    var _controller = AMapNavController(
      viewId: viewId,
      onCloseHandler: onCloseHandler,
      onMoreHandler: onMoreHandler,
    );
    if (onNavViewCreate != null) {
      onNavViewCreate(_controller);
    }
  }
}
