import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_amap_plugin/common/coordinate.dart';

const _routeChannelPrefix = 'plugin/amap/search/convert';

class AMapConvertController {
  final MethodChannel _convertChannel;

  AMapConvertController()
      : _convertChannel = MethodChannel(_routeChannelPrefix);

  void initConvertChannel() {

  }

  Future geoConvertToCoordinate(String geo) async {
    var result = await _convertChannel.invokeMethod('geoToCoordinate', geo);
    return result;
  }

  Future coordinateConvertToGeo(Coordinate coordinate) async {
    var result = await _convertChannel.invokeMethod(
        'coordinateToGeo', coordinate.toJsonString());
    return result;
  }
}
