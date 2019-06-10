//
// Created by 冯顺 on 2019-06-09.
//

import Foundation
import AMapFoundationKit
import AMapSearchKit
import Flutter

class FlutterAMapSearchRegister: NSObject {

}

class FlutterAMapRoutePlan: NSObject {
//    let _routePlanParam: RoutePlanParam!
    var _search: AMapSearchAPI!
    var _result: FlutterResult!

    public override init() {
        super.init()
        _search = AMapSearchAPI()
        _search.delegate = self

        let startCoordinate = CLLocationCoordinate2DMake(39.910267, 116.370888)
        let destinationCoordinate = CLLocationCoordinate2DMake(39.989872, 116.481956)
        let request = AMapDrivingRouteSearchRequest()
        request.origin = AMapGeoPoint.location(withLatitude: CGFloat(startCoordinate.latitude), longitude: CGFloat(startCoordinate.longitude))
        request.destination = AMapGeoPoint.location(withLatitude: CGFloat(destinationCoordinate.latitude), longitude: CGFloat(destinationCoordinate.longitude))

        request.requireExtension = true

        _search.aMapDrivingRouteSearch(request)
    }

    @objc public func onMethod(call: FlutterMethodCall!, result: FlutterResult!) {
    }
}

// AMapSearchDelegate
extension FlutterAMapRoutePlan: AMapSearchDelegate {
    public func onRouteSearchDone(_ request: AMapRouteSearchBaseRequest!, response: AMapRouteSearchResponse!) {

    }

    public func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {

    }
}