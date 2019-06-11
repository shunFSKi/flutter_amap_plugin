import Flutter
import UIKit

public class SwiftFlutterAmapPlugin: NSObject, FlutterPlugin {
    static let AMAP_SEARCH_ROUTE_CHANNEL = "plugin/amap/search/route"
    public static var routeChannel: FlutterMethodChannel!;

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
