import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

const _mapChannelPrefix = 'plugin/amap/map';

typedef void MapViewWillStartLoadingMap();
typedef void MapViewDidFinishLoadingMap();

class AMapMapController {
  final MethodChannel _mapChannel;
  final MapViewWillStartLoadingMap onMapStartLodingMap;
  final MapViewDidFinishLoadingMap onMapFinishLodingMap;

  AMapMapController.viewId({
    @required int viewId,
    this.onMapStartLodingMap,
    this.onMapFinishLodingMap,
  }) : _mapChannel = MethodChannel('$_mapChannelPrefix/$viewId');

  void dispose() {}

  void initMapChannel() {
    _mapChannel.setMethodCallHandler((handler) {
      switch (handler.method) {
        case 'mapViewWillStartLoadingMap':
          if (onMapStartLodingMap != null) {
            onMapStartLodingMap();
          }
          break;
        case 'mapViewDidFinishLoadingMap':
          if (onMapFinishLodingMap != null) {
            onMapFinishLodingMap();
          }
          break;
        default:
      }
    });
  }
}
