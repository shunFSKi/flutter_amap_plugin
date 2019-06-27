import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../common/coordinate.dart';

const _navChannelPrefix = 'plugin/amap/nav';

typedef void NavCloseHandler();
typedef void NavMoreHandler();

class AMapNavController {
  final MethodChannel _navChannel;
  final NavCloseHandler onCloseHandler;
  final NavMoreHandler onMoreHandler;
  final MethodChannel _componentChannel;

  AMapNavController({
    int viewId,
    this.onCloseHandler,
    this.onMoreHandler,
  })  : _navChannel = MethodChannel('$_navChannelPrefix/$viewId'),
        _componentChannel = MethodChannel('$_navChannelPrefix');

  Future startAMapNav({
    @required Coordinate coordinate,
  }) {
    return _navChannel
        .invokeMethod('startNav', coordinate.toJsonString())
        .then((onValue) {
      return onValue;
    });
  }

  Future startComponent({
    @required Coordinate coordinate,
  }) {
    return _componentChannel
        .invokeMethod('startComponentNav', coordinate.toJsonString())
        .then((onValue) {
      return onValue;
    });
  }

  void initNavChannel(BuildContext context) {
    _navChannel.setMethodCallHandler((handler) {
      switch (handler.method) {
        case 'close_nav':
          if (onCloseHandler != null) {
            onCloseHandler();
          } else {
            Navigator.pop(context);
          }
          break;
        case 'more_nav':
          if (onMoreHandler != null) {
            onMoreHandler();
          }
          break;
        default:
      }
    });
  }

  void dispose() {}
}
