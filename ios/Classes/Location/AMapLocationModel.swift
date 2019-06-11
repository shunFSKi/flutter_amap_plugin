//
// Created by 冯顺 on 2019-06-04.
//

import UIKit
import HandyJSON
//import AMapLocationKit

class AMapLocationModel: NSObject, HandyJSON {
    required override init() {
    }
}

class LocationOptions: AMapLocationModel {
    ///设定定位的最小更新距离。单位米，默认为 kCLDistanceFilterNone，表示只要检测到设备位置发生变化就会更新位置信息。
    var distanceFilter: Double!


    ///设定期望的定位精度。单位米，默认为 kCLLocationAccuracyBest。定位服务会尽可能去获取满足desiredAccuracy的定位结果，但不保证一定会得到满足期望的结果。 \n注意：设置为kCLLocationAccuracyBest或kCLLocationAccuracyBestForNavigation时，单次定位会在达到locationTimeout设定的时间后，将时间内获取到的最高精度的定位结果返回。
    var desiredAccuracy: String!


    ///指定定位是否会被系统自动暂停。默认为NO。
    var pausesLocationUpdatesAutomatically: Bool!


    ///是否允许后台定位。默认为NO。只在iOS 9.0及之后起作用。设置为YES的时候必须保证 Background Modes 中的 Location updates 处于选中状态，否则会抛出异常。由于iOS系统限制，需要在定位未开始之前或定位停止之后，修改该属性的值才会有效果。
    var allowsBackgroundLocationUpdates: Bool!


    ///指定单次定位超时时间,默认为10s。最小值是2s。注意单次定位请求前设置。注意: 单次定位超时时间从确定了定位权限(非kCLAuthorizationStatusNotDetermined状态)后开始计算。
    var locationTimeout: Int!


    ///指定单次定位逆地理超时时间,默认为5s。最小值是2s。注意单次定位请求前设置。
    var reGeocodeTimeout: Int!


    ///连续定位是否返回逆地理信息，默认NO。
    var locatingWithReGeocode: Bool!


    // 逆地址语言类型，默认是AMapLocationRegionLanguageDefault
    var reGeocodeLanguage: Int!
    
    // 单次定位是否返回逆地理信息
    var isReGeocode:Bool!
    

}
