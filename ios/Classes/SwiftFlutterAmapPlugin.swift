import Flutter
import UIKit
import AMapNaviKit

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

private let MAP_CHANNEL_NAME = "plugin/amap/map"
class FlutterAMapView: NSObject, FlutterPlatformView {
    fileprivate var viewId: Int64!
    fileprivate var methodChannel:FlutterMethodChannel!
    fileprivate var mapView:MAMapView!
    fileprivate var mapOptions:MapOptions!
    
    func view() -> UIView {
        return self.mapView ?? UIView()
    }
    
    public init(withFrame frame: CGRect, viewIdentifier viewId: Int64, binaryMessenger: FlutterBinaryMessenger, options: MapOptions?) {
        super.init()
        
        self.viewId = viewId
        self.mapOptions = options
        self.mapView = MAMapView.init(frame: frame)
        self.mapView.delegate = self
        
        configMapOptions()
        
        self.methodChannel = FlutterMethodChannel(name: "\(MAP_CHANNEL_NAME)_\(viewId)", binaryMessenger: binaryMessenger)
        
        self.methodChannel.setMethodCallHandler {[weak self] (call: FlutterMethodCall, result:@escaping FlutterResult) in
            if let this = self {
                if !this.onMethodCall(call: call, result: result) {
                    result(FlutterMethodNotImplemented)
                }
            }
        }
    }
    
    func configMapOptions() {
        if mapOptions != nil {
            mapView.mapType = MAMapType(rawValue: mapOptions.mapType!)!
            mapView.isShowTraffic = mapOptions.showTraffic
            mapView.showsScale = mapOptions.showsScale
            mapView.showsCompass = mapOptions.showsCompass
            mapView.showsUserLocation = mapOptions.showsUserLocation
            mapView.userTrackingMode = MAUserTrackingMode(rawValue: mapOptions.userTrackingMode!)!
            if mapOptions.centerCoordinate != nil {
                mapView.centerCoordinate = mapOptions.centerCoordinate.toCLLocationCoordinate2D()
            }
            mapView.zoomLevel = mapOptions.zoomLevel
            mapView.minZoomLevel = mapOptions.minZoomLevel
            mapView.maxZoomLevel = mapOptions.maxZoomLevel
            mapView.rotationDegree = mapOptions.rotationDegree
            mapView.cameraDegree = mapOptions.cameraDegree
            mapView.zoomingInPivotsAroundAnchorPoint = mapView.zoomingInPivotsAroundAnchorPoint
            mapView.isZoomEnabled = mapOptions.zoomEnabled
            mapView.isScrollEnabled = mapOptions.scrollEnabled
            mapView.isRotateEnabled = mapOptions.rotateEnabled
        }
    }
    
    func onMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) -> Bool {
        let method = call.method
        if method == "initKey" {
            
        } else {
            return false
        }
        return true
    }
    
    deinit {
        print("success release")
    }
    
}

// MARK: - MAMapViewDelegate
extension FlutterAMapView:MAMapViewDelegate {
    
    func mapViewWillStartLoadingMap(_ mapView: MAMapView!) {
        print("mapViewWillStartLoadingMap")
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MAMapView!) {
        print("mapViewDidFinishLoadingMap")
    }
    
    public func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if (annotation is MAUserLocation) {
            return nil
        }
        return nil
    }
}

public class FlutterAMapViewFactory:NSObject, FlutterPlatformViewFactory {
    var messenger: FlutterBinaryMessenger!
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
    
    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        
        var options:MapOptions? = nil
        
        if let result = MapOptions.deserialize(from: args as? String) {
            options = result
        }
        
        return FlutterAMapView.init(withFrame: frame, viewIdentifier: viewId, binaryMessenger: messenger, options: options)
    }
    
    @objc public init(messenger: (NSObject & FlutterBinaryMessenger)?) {
        super.init()
        self.messenger = messenger
    }
    
}
