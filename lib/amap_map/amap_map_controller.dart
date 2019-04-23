import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

const channelPrefix = 'plugin/amap';

class AMapMapController {
  final MethodChannel _mapChannel;
  final EventChannel _mapEventChannel;
  StreamSubscription _subscription;

  AMapMapController.viewId(int viewId)
      : _mapChannel = MethodChannel('$channelPrefix/map/$viewId'),
        _mapEventChannel = EventChannel('$channelPrefix/map/event/$viewId');

  void dispose() {
    _subscription.cancel();
  }

  void initMapEvent(BuildContext context) {
    _subscription = _mapEventChannel.receiveBroadcastStream().listen((onData) {
      if (onData == 'map_close') {
        Navigator.pop(context);
      }
    });
  }
}
