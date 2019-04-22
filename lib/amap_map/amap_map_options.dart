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

class AMapMapOptions extends AMapBaseModel {
  /// 地图类型
  final int mapType;

  /// 缩放级别（默认3-19，有室内地图时为3-20）
  final double zoomLevel;

  /// 当前地图的中心点坐标
  final Coordinate coordinate;

  AMapMapOptions({
    this.mapType = AMapMapType.standard,
    this.zoomLevel = 15,
    this.coordinate,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'mapType': mapType,
      'zoomLevel': zoomLevel,
    };
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
