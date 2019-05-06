import Flutter
import UIKit

public class SwiftFlutterAmapPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_amap_plugin", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterAmapPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        result("iOS " + UIDevice.current.systemVersion)
    }
}

public class PluginAssets : NSObject {
    
    static func defaultAssetPath(asset: String) -> String {
        let key = FlutterAmapPlugin.registar()?.lookupKey(forAsset: asset, fromPackage: "flutter_amap_plugin")
        return Bundle.main.path(forResource: key, ofType: nil) ?? ""
    }
    
    static func assetPath(asset: String) -> String {
        let key = FlutterAmapPlugin.registar()?.lookupKey(forAsset: asset)
        return Bundle.main.path(forResource: key, ofType: nil) ?? ""
    }
}
