import '../model/amap_base_model.dart';

class AMapLocationReGeocodeLanguage {
  ///<默认，根据地区选择语言
  static const int auto = 0;

  ///<中文
  static const int chinese = 1;

  ///<英文
  static const int english = 2;
}

class LocationAccuracy {
  /// 精度要求最高
  static const LocationAccuracyBest = 'LocationAccuracyBest';

  /// 10米
  static const LocationAccuracyNearestTenMeters =
      'LocationAccuracyNearestTenMeters';

  /// 百米
  static const LocationAccuracyHundredMeters = 'LocationAccuracyHundredMeters';

  /// 千米
  static const LocationAccuracyKilometer = 'LocationAccuracyKilometer';

  /// 3千米
  static const LocationAccuracyThreeKilometers =
      'LocationAccuracyThreeKilometers';
}

class LocationModel {
  /// 高精度定位模式：在这种定位模式下，将同时使用高德网络定位和卫星定位,优先返回精度高的定位
  static const Hight_Accuracy = 0;

  /// 低功耗定位模式：在这种模式下，将只使用高德网络定位
  static const Battery_Saving = 1;

  /// 仅设备定位模式：在这种模式下，将只使用卫星定位。
  static const Device_Sensors = 2;
}

class AMapLocationOptions extends AMapBaseModel {
  /// [ios]设定定位的最小更新距离。单位米，默认为 DistanceFilterNone，表示只要检测到设备位置发生变化就会更新位置信息。
  final double distanceFilter;

  /// [ios]设定期望的定位精度。单位米，默认为 LocationAccuracyBest。定位服务会尽可能去获取满足desiredAccuracy的定位结果，但不保证一定会得到满足期望的结果。 \n注意：设置为LocationAccuracyBest或LocationAccuracyBestForNavigation时，单次定位会在达到locationTimeout设定的时间后，将时间内获取到的最高精度的定位结果返回。
  final desiredAccuracy;

  /// [Android]定位模式，目前支持三种定位模式
  final locationModel;

  ///[ios]指定定位是否会被系统自动暂停。默认为NO。
  final bool pausesLocationUpdatesAutomatically;

  ///[ios]是否允许后台定位。默认为NO。只在iOS 9.0及之后起作用。设置为YES的时候必须保证 Background Modes 中的 Location updates 处于选中状态，否则会抛出异常。由于iOS系统限制，需要在定位未开始之前或定位停止之后，修改该属性的值才会有效果。
  final bool allowsBackgroundLocationUpdates;

  ///指定单次定位超时时间,默认为10s。最小值是2s。注意单次定位请求前设置。注意: 单次定位超时时间从确定了定位权限(非AuthorizationStatusNotDetermined状态)后开始计算。
  final int locationTimeout;

  ///[ios]指定单次定位逆地理超时时间,默认为5s。最小值是2s。注意单次定位请求前设置。
  final int reGeocodeTimeout;

  ///连续定位是否返回逆地理信息，默认NO。
  final bool locatingWithReGeocode;

  // 逆地址语言类型，默认是AMapLocationRegionLanguageAuto
  final reGeocodeLanguage;

  // 是否是逆地址单次定位
  final bool isReGeocode;

  AMapLocationOptions({
    this.distanceFilter = 0.0,
    this.desiredAccuracy = LocationAccuracy.LocationAccuracyBest,
    this.locationModel = LocationModel.Hight_Accuracy,
    this.pausesLocationUpdatesAutomatically = false,
    this.allowsBackgroundLocationUpdates = false,
    this.locationTimeout = 10,
    this.reGeocodeTimeout = 5,
    this.locatingWithReGeocode = false,
    this.reGeocodeLanguage = AMapLocationReGeocodeLanguage.auto,
    this.isReGeocode = false,
  });

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'distanceFilter': distanceFilter,
      'desiredAccuracy': desiredAccuracy,
      'locationModel': locationModel,
      'pausesLocationUpdatesAutomatically': pausesLocationUpdatesAutomatically,
      'allowsBackgroundLocationUpdates': allowsBackgroundLocationUpdates,
      'locationTimeout': locationTimeout,
      'reGeocodeTimeout': reGeocodeTimeout,
      'locatingWithReGeocode': locatingWithReGeocode,
      'reGeocodeLanguage': reGeocodeLanguage,
      'isReGeocode': isReGeocode
    };
    return map;
  }
}
