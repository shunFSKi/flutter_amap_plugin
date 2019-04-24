import '../model/amap_base_model.dart';

class AMapNavTrackingMode {
  ///< 0 地图朝北
  static const int mapNorth = 0;

  ///< 1 车头朝北
  static const int carNorth = 1;
}

class AMapNavOptions extends AMapBaseModel {
  ///导航界面跟随模式,默认AMapNaviViewTrackingModeMapNorth
  final int trackingMode;

  ///是否显示界面元素,默认YES
  final bool showUIElements;

  ///是否显示路口放大图,默认YES
  final bool showCrossImage;

  ///是否显示实时交通按钮,默认YES
  final bool showTrafficButton;

  ///是否显示路况光柱,默认YES
  final bool showTrafficBar;

  ///是否显示全览按钮,默认YES
  final bool showBrowseRouteButton;

  ///是否显示更多按钮,默认YES
  final bool showMoreButton;

  AMapNavOptions({
    this.trackingMode = AMapNavTrackingMode.carNorth,
    this.showUIElements = true,
    this.showCrossImage = true,
    this.showTrafficButton = true,
    this.showTrafficBar = true,
    this.showBrowseRouteButton = true,
    this.showMoreButton = true,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'trackingMode': trackingMode,
      'showUIElements': showUIElements,
      'showCrossImage': showCrossImage,
      'showTrafficButton': showTrafficButton,
      'showTrafficBar': showTrafficBar,
      'showBrowseRouteButton': showBrowseRouteButton,
      'showMoreButton': showMoreButton,
    };
  }
}
