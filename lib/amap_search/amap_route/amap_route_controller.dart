import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './amap_route_options.dart';

const _routeChannelPrefix = 'plugin/amap/search/route';

typedef void RoutePlanningCallHandler(
    RouteSearchDoneModel routeModel, String shareURL, Error error);

class AMapRouteController {
  final MethodChannel _routeChannel;

  AMapRouteController() : _routeChannel = MethodChannel(_routeChannelPrefix);

  void initRouteChannel({
    @required RoutePlanningCallHandler onRoutePlanningCallHandler,
  }) {
    _routeChannel.setMethodCallHandler((handler) {
      switch (handler.method) {
        case 'onRouteSearchDone':
          RouteSearchDoneModel model = RouteSearchDoneModel();
          model.distance = handler.arguments['distance'];
          model.duration = handler.arguments['duration'];
          model.strategy = handler.arguments['strategy'];
          model.totalTrafficLights = handler.arguments['totalTrafficLights'];
          if (onRoutePlanningCallHandler != null) {
            onRoutePlanningCallHandler(model, null, null);
          }
          break;
        case 'onShareSearchDone':
          if (onRoutePlanningCallHandler != null) {
            onRoutePlanningCallHandler(
                null, handler.arguments['shareURL'], null);
          }
          break;
        case 'routePlanningError':
          if (onRoutePlanningCallHandler != null) {
            onRoutePlanningCallHandler(
                null, null, FlutterError(handler.arguments));
          }
          break;
        default:
      }
    });
  }

  Future routePlanning(AMapRouteOptions options) async {
    var result = await _routeChannel.invokeMethod(
      'startRoutePlanning',
      options.toJsonString(),
    );
    return result;
  }
}

class RouteSearchDoneModel {
  ///预计耗时（单位：秒）
  var duration;

  ///起点和终点的距离
  var distance;

  ///导航策略
  var strategy;

  ///此方案交通信号灯个数
  var totalTrafficLights;
}
