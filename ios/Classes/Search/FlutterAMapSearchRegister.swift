//
// Created by 冯顺 on 2019-06-09.
//

import Foundation
import AMapFoundationKit
import AMapSearchKit
import Flutter

//private var _search: AMapSearchAPI!

public class FlutterAMapSearch: NSObject {
    var _search: AMapSearchAPI!

    public override init() {
        super.init()
    }

    deinit {
        print("FlutterAMapSearch delloc")
    }
}

public class FlutterAMapRoutePlan: FlutterAMapSearch, AMapSearchDelegate {

    public override init() {
        super.init()
        _search = AMapSearchAPI()
        _search.delegate = self
    }

    public func onMethod(call: FlutterMethodCall!, result: FlutterResult!) {
        if let options = RoutePlanningModel.deserialize(from: call?.arguments as? String) {
            routePlanning(options)
            routeShareUrl(options)
            result("start route planning")
        } else {
            result(FlutterError.init(code: "0", message: "arg not string", details: nil))
        }
    }

    func routePlanning(_ options: RoutePlanningModel!) {
        let request = AMapDrivingRouteSearchRequest()
        request.origin = AMapGeoPoint.location(withLatitude: CGFloat(options.origin.latitude), longitude: CGFloat(options.origin.longitude))
        request.destination = AMapGeoPoint.location(withLatitude: CGFloat(options.destination.latitude), longitude: CGFloat(options.destination.longitude))
        request.strategy = options.strategy
        request.requireExtension = true

        _search.aMapDrivingRouteSearch(request)
    }

    func routeShareUrl(_ options: RoutePlanningModel!) {
        let request = AMapRouteShareSearchRequest()
        request.strategy = options.strategy
        request.startCoordinate = AMapGeoPoint.location(withLatitude: CGFloat(options.destination.latitude), longitude: CGFloat(options.destination.longitude))
        request.destinationCoordinate = AMapGeoPoint.location(withLatitude: CGFloat(options.destination.latitude), longitude: CGFloat(options.destination.longitude))
        _search.aMapRouteShareSearch(request)
    }

    public func onRouteSearchDone(_ request: AMapRouteSearchBaseRequest!, response: AMapRouteSearchResponse!) {
        if response.route.paths.count > 0 {
            let path: AMapPath = response.route.paths[0]
            SwiftFlutterAmapPlugin.routeChannel.invokeMethod(
                    "onRouteSearchDone",
                    arguments: ["duration": path.duration,
                                "distance": path.distance,
                                "strategy": path.strategy!,
                                "totalTrafficLights": path.totalTrafficLights])
        } else {
            SwiftFlutterAmapPlugin.routeChannel.invokeMethod("routePlanningError", arguments: "路线规划错误:{0000 - 未发现有效路径}")
        }
    }

    public func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        if let error = error {
            let error = error as NSError
            SwiftFlutterAmapPlugin.routeChannel.invokeMethod("routePlanningError", arguments: "路线规划错误:{\(error.code) - \(error.localizedDescription)}")
        }
    }

    public func onShareSearchDone(_ request: AMapShareSearchBaseRequest!, response: AMapShareSearchResponse!) {
        SwiftFlutterAmapPlugin.routeChannel.invokeMethod("onShareSearchDone", arguments: ["shareURL": response.shareURL])
    }

    deinit {
        print("route delloc")
    }
}

