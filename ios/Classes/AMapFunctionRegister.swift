//
// Created by 冯顺 on 2019-06-10.
//

import Foundation

public class AMapSearchFunctionRegister: NSObject {
    static var _routeDic: Dictionary<String, FlutterAMapSearch>!

    static public func routePlanningFuntionHandler() -> Dictionary<String, FlutterAMapSearch> {
        if _routeDic == nil {
            _routeDic = ["startRoutePlanning": FlutterAMapRoutePlan()]
        }
        return _routeDic
    }
}
