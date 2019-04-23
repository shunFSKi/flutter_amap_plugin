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
  final AMapMapOptions options;

  const AMapMapView({
    Key key,
    this.onMapViewCreate,
    this.options,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gestureRecognizers = <Factory<OneSequenceGestureRecognizer>>[
      Factory<OneSequenceGestureRecognizer>(
        () => EagerGestureRecognizer(),
      ),
    ].toSet();
    print(options.toJsonString());
    if (Platform.isIOS) {
      return UiKitView(
        viewType: _viewType,
        gestureRecognizers: gestureRecognizers,
        creationParamsCodec: StandardMessageCodec(),
        creationParams: options.toJsonString(),
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    } else if (Platform.isAndroid) {
      return AndroidView(
        viewType: _viewType,
        gestureRecognizers: gestureRecognizers,
        creationParamsCodec: StandardMessageCodec(),
        creationParams: options.toJsonString(),
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
      onMapViewCreate(AMapMapController.viewId(viewId));
    }
  }
}
