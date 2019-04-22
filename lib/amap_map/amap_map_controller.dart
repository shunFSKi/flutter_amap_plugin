
import 'package:flutter/services.dart';

const channelPrefix = 'plugin/amap';
class AMapMapController {
  final MethodChannel _mapChannel;

  AMapMapController.viewId(int viewId)
      : _mapChannel = MethodChannel('$channelPrefix/map/$viewId');

  void dispose() {}
}