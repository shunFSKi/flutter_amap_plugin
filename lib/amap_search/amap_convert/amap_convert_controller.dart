import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_amap_plugin/common/coordinate.dart';

const _convertChannelPrefix = 'plugin/amap/search/convert';

typedef void ConvertCallHandler(
    Coordinate coordinate, String address, Error error);

class AMapConvertController {
  final MethodChannel _convertChannel;

  AMapConvertController()
      : _convertChannel = MethodChannel(_convertChannelPrefix);

  void initConvertChannel({
    @required ConvertCallHandler onConvertCallHandler,
  }) {
    _convertChannel.setMethodCallHandler((handler) {
      switch (handler.method) {
        case 'onCoordinateToGeo':
          if (onConvertCallHandler != null) {
            String address = handler.arguments['address'].toString();
            onConvertCallHandler(null, address, null);
          }
          break;
        case 'onGeoToCoordinate':
          if (onConvertCallHandler != null) {
            Coordinate coordinate = Coordinate(
                double.parse(handler.arguments['lat'].toString()),
                double.parse(handler.arguments['lon'].toString()));
            onConvertCallHandler(coordinate, null, null);
          }
          break;
        case 'onConvertError':
          if (onConvertCallHandler != null) {
            onConvertCallHandler(
                null, null, FlutterError(handler.arguments.toString()));
          }
          break;
      }
    });
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
