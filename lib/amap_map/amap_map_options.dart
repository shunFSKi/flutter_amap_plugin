import '../model/amap_base_model.dart';

class AMapMapType {
  ///< 普通地图
  static const int standard = 0;

  ///< 卫星地图
  static const int satellite = 1;

  ///< 夜间视图
  static const int standardNight = 2;

  ///< 导航视图
  static const int navi = 3;

  ///< 公交视图
  static const int bus = 4;
}

class AMapUserTrackingMode {
  ///< 不追踪用户的location更新
  static const int none = 0;

  ///< 追踪用户的location更新
  static const int follow = 1;

  ///< 追踪用户的location与heading更新
  static const int followWithHeading = 2;
}

class AMapMapOptions extends AMapBaseModel {
  /// 地图类型
  final int mapType;

  /// 缩放级别（默认3-19，有室内地图时为3-20）
  final double zoomLevel;

  /// 当前地图的中心点坐标
  final Coordinate centerCoordinate;

  ///最小缩放级别
  final double minZoomLevel;

  ///最大缩放级别（有室内地图时最大为20，否则为19）
  final double maxZoomLevel;

  ///设置地图旋转角度(逆时针为正向)
  final double rotationDegree;

  ///设置地图相机角度(范围为[0.f, 60.f]，但高于40度的角度需要在16级以上才能生效)
  final double cameraDegree;

  ///是否以screenAnchor点作为锚点进行缩放，默认为YES。如果为NO，则以手势中心点作为锚点
  final bool zoomingInPivotsAroundAnchorPoint;

  ///是否支持缩放, 默认YES
  final bool zoomEnabled;

  ///是否支持平移, 默认YES
  final bool scrollEnabled;

  ///是否支持旋转, 默认YES
  final bool rotateEnabled;

  ///是否支持camera旋转, 默认YES
  final bool rotateCameraEnabled;

  ///是否显示比例尺, 默认YES
  final bool showsScale;

  ///是否显示用户位置
  final bool showsUserLocation;

  ///是否显示指南针, 默认YES
  final bool showsCompass;

  ///是否显示交通路况图层, 默认为NO
  final showTraffic;

  ///定位用户位置的模式,
  ///注意：在follow模式下，设置地图中心点、设置可见区域、滑动手势、选择annotation操作会取消follow模式
  final userTrackingMode;

  AMapMapOptions({
    this.mapType = AMapMapType.standard,
    this.zoomLevel = 15,
    this.centerCoordinate,
    // = const Coordinate(39.8994731, 116.4142794),
    this.minZoomLevel = 3,
    this.maxZoomLevel = 19,
    this.rotationDegree = 0.0,
    this.cameraDegree = 0.0,
    this.zoomingInPivotsAroundAnchorPoint = true,
    this.zoomEnabled = true,
    this.scrollEnabled = true,
    this.rotateEnabled = true,
    this.rotateCameraEnabled = true,
    this.showsScale = true,
    this.showsUserLocation = false,
    this.showsCompass = true,
    this.showTraffic = false,
    this.userTrackingMode = AMapUserTrackingMode.none,
  });

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'mapType': mapType,
      'zoomLevel': zoomLevel,
      'minZoomLevel': minZoomLevel,
      'maxZoomLevel': maxZoomLevel,
      'rotationDegree': rotationDegree,
      'cameraDegree': cameraDegree,
      'zoomingInPivotsAroundAnchorPoint': zoomingInPivotsAroundAnchorPoint,
      'zoomEnabled': zoomEnabled,
      'scrollEnabled': scrollEnabled,
      'rotateEnabled': rotateEnabled,
      'rotateCameraEnabled': rotateCameraEnabled,
      'showsScale': showsScale,
      'showsUserLocation': showsUserLocation,
      'showsCompass': showsCompass,
      'showTraffic': showTraffic,
      'userTrackingMode': userTrackingMode,
    };
    if (centerCoordinate != null) {
      map['centerCoordinate'] = centerCoordinate.toJson();
    }

    return map;
  }
}

class Coordinate extends AMapBaseModel {
  final double latitude;
  final double longitude;

  Coordinate(this.latitude, this.longitude);

  @override
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
