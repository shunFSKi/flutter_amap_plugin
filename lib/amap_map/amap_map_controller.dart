import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

const channelPrefix = 'plugin/amap';

typedef void MapViewWillStartLoadingMap();
typedef void MapViewDidFinishLoadingMap();

class AMapMapController {
  final MethodChannel _mapChannel;
  final MapViewWillStartLoadingMap onMapStartLodingMap;
  final MapViewDidFinishLoadingMap onMapFinishLodingMap;

  AMapMapController.viewId(int viewId, this.onMapStartLodingMap, this.onMapFinishLodingMap)
      : _mapChannel = MethodChannel('$channelPrefix/map/$viewId');

  void dispose() {}

  void initMapChannel() {
    
    _mapChannel.setMethodCallHandler((handler) {
      switch (handler.method) {
        case 'mapViewWillStartLoadingMap':
          print(handler.arguments);
          break;
        case 'mapViewDidFinishLoadingMap':
          print(handler.arguments);
          break;
        default:
      }
    });
  }
}
