import Flutter
import UIKit

public class SwiftFlutterAmapPlugin: NSObject, FlutterPlugin {
    static let AMAP_SEARCH_ROUTE_CHANNEL = "plugin/amap/search/route"
    static let AMAP_SEARCH_CONVERT_CHANNEL = "plugin/amap/search/convert"
    public static var routeChannel: FlutterMethodChannel!;
    public static var convertChannel: FlutterMethodChannel!;

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_amap_plugin", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterAmapPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)

        //路线规划
        let _routeChannel = FlutterMethodChannel(name: AMAP_SEARCH_ROUTE_CHANNEL, binaryMessenger: registrar.messenger())
        _routeChannel.setMethodCallHandler { (call, result) in

            if (call.method == "startRoutePlanning") {
                var routePlan: FlutterAMapRoutePlan? = nil
                routePlan = AMapSearchFunctionRegister.routePlanningFuntionHandler()[call.method] as? FlutterAMapRoutePlan
                routePlan?.onMethod(call: call, result: result)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
        routeChannel = _routeChannel

        let _convertChannel = FlutterMethodChannel(name: AMAP_SEARCH_CONVERT_CHANNEL, binaryMessenger: registrar.messenger())
        _convertChannel.setMethodCallHandler { call, result in
            if (call.method == "geoToCoordinate" || call.method == "coordinateToGeo") {
                var convert: FlutterAMapConvert? = nil
                convert = AMapSearchFunctionRegister.routePlanningFuntionHandler()[call.method] as? FlutterAMapConvert
                convert?.onMethod(call: call, result: result)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
        convertChannel = _convertChannel

    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        result("iOS " + UIDevice.current.systemVersion)
    }
}

public class PluginAssets: NSObject {

    static func defaultAssetPath(asset: String) -> String {
        let key = FlutterAmapPlugin.registar()?.lookupKey(forAsset: asset, fromPackage: "flutter_amap_plugin")
        return Bundle.main.path(forResource: key, ofType: nil) ?? ""
    }

    static func assetPath(asset: String) -> String {
        let key = FlutterAmapPlugin.registar()?.lookupKey(forAsset: asset)
        return Bundle.main.path(forResource: key, ofType: nil) ?? ""
    }
}
