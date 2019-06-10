import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _routeChannelPrefix = 'plugin/amap/search/route';

class AMapRouteController {
  final MethodChannel _routeChannel;

  AMapRouteController() : _routeChannel = MethodChannel(_routeChannelPrefix);

  void initRouteChannel() {
    _routeChannel.setMethodCallHandler((handler) {});
  }

  Future routePlanning() async {
    var result = await _routeChannel.invokeMethod('startRoutePlanning');
    return result;
  }
}
