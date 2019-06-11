import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../amap_annotation/amap_annotation_options.dart';

const _mapChannelPrefix = 'plugin/amap/map';

typedef void MapViewWillStartLoadingMap();
typedef void MapViewDidFinishLoadingMap();
typedef void MapAnnotationTap(int index);

class AMapMapController {
  final MethodChannel _mapChannel;
  final MapViewWillStartLoadingMap onMapStartLodingMap;
  final MapViewDidFinishLoadingMap onMapFinishLodingMap;
  final MapAnnotationTap onMapAnnotationTap;

  AMapMapController.viewId({
    @required int viewId,
    this.onMapStartLodingMap,
    this.onMapFinishLodingMap,
    this.onMapAnnotationTap,
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
        case 'annotation_tap':
          if (onMapAnnotationTap != null) {
            onMapAnnotationTap(handler.arguments['tapIndex']);
          }
          break;
        default:
      }
    });
  }

  Future addAnnotation({
    @required AMapAnnotationOptions options,
  }) async {
    return _mapChannel.invokeMethod(
        'annotation_add', options.toJsonString());
  }

  Future clearAllAnnotations() async {
    var result = await _mapChannel.invokeMethod('annotation_clear');
    return result;
  }
}
