import 'dart:async';

import 'package:flutter/services.dart';

export './amap_map/amap_map_controller.dart';
export './amap_map/amap_map_view.dart';
export './amap_map/amap_map_options.dart';
export './amap_nav/amap_nav_view.dart';
export './amap_nav/amap_nav_controller.dart';
export './common/coordinate.dart';
export './amap_annotation/amap_annotation_options.dart';
export './amap_nav/amap_nav_options.dart';
export 'amap_location/amap_location_controller.dart';
export 'amap_location/amap_location_options.dart';
export './amap_search/amap_route/amap_route_controller.dart';
export './amap_search/amap_route/amap_route_options.dart';
export './amap_search/amap_convert/amap_convert_controller.dart';

class FlutterAmapPlugin {
  static const MethodChannel _channel = const MethodChannel('plugin/base/init');

  /// [initAMapIOSKey]仅支持设置iOS key,Android在项目内设置
  static Future initAMapIOSKey(String iosKey) async {
    var _result = _channel.invokeMethod('initKey', {'iosKey': iosKey});
    return _result;
  }
}
