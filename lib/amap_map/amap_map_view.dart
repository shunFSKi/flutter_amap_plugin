import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import './amap_map_controller.dart';
import './amap_map_options.dart';

const _viewType = 'plugin/amap/map';
typedef void MapViewCreateCallHandler(AMapMapController controller);

class AMapMapView extends StatelessWidget {
  final MapViewCreateCallHandler onMapViewCreate;

  /// 地图开始加载回调
  final MapViewWillStartLoadingMap onMapStartLodingMap;

  /// 地图加载成功回调
  final MapViewDidFinishLoadingMap onMapFinishLodingMap;

  /// 标记视图点击回调
  final MapAnnotationTap onMapAnnotationTap;
  final AMapMapOptions options;

  const AMapMapView({
    Key key,
    this.onMapViewCreate,
    this.options,
    this.onMapStartLodingMap,
    this.onMapFinishLodingMap,
    this.onMapAnnotationTap,
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
        creationParams: options == null ? options : options.toJsonString(),
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    } else if (Platform.isAndroid) {
      return AndroidView(
        viewType: _viewType,
        gestureRecognizers: gestureRecognizers,
        creationParamsCodec: StandardMessageCodec(),
        creationParams: options == null ? options : options.toJsonString(),
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    } else {
      return Text(
        'AMap_plugin does not support $defaultTargetPlatform',
      );
    }
  }

  void _onPlatformViewCreated(int viewId) {
    if (onMapViewCreate != null) {
      onMapViewCreate(AMapMapController.viewId(
        viewId: viewId,
        onMapStartLodingMap: onMapStartLodingMap,
        onMapFinishLodingMap: onMapFinishLodingMap,
        onMapAnnotationTap: onMapAnnotationTap,
      ));
    }
  }
}
