//
// Created by 冯顺 on 2019-06-04.
//

import Foundation
import AMapFoundationKit
import AMapLocationKit
import Flutter

private var _locationManager: AMapLocationManager!

public class FlutterAMapLocation: NSObject {
    public override init() {
        super.init()
        _locationManager = AMapLocationManager()
    }
    
    deinit {
        print("FlutterAMapLocation delloc")
    }
}

public class FlutterAMapStartLocation: NSObject {
    
    public override init() {
        super.init()
    }
    
    deinit {
        print("FlutterAMapStartLocation delloc")
    }

    @objc public func onMethod(call: FlutterMethodCall!, result: FlutterResult!) {
        var options: LocationOptions? = nil
        if let arg = LocationOptions.deserialize(from: call?.arguments as? String) {
            options = arg
            configOptions(options)
            result("start location")
            singleLocation(options?.isReGeocode)
        } else {
            result(FlutterError.init(code: "0", message: "arg not string", details: nil))
        }
    }

    func configOptions(_ options: LocationOptions!) {
        _locationManager.distanceFilter = options.distanceFilter
        switch options.desiredAccuracy {
        case "LocationAccuracyBest":
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        case "LocationAccuracyNearestTenMeters":
            _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        case "LocationAccuracyHundredMeters":
            _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        case "LocationAccuracyKilometer":
            _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        case "LocationAccuracyThreeKilometers":
            _locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        default:
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
        _locationManager.pausesLocationUpdatesAutomatically = options.pausesLocationUpdatesAutomatically
        _locationManager.allowsBackgroundLocationUpdates = options.allowsBackgroundLocationUpdates
        _locationManager.locationTimeout = options.locationTimeout
        _locationManager.reGeocodeTimeout = options.reGeocodeTimeout
        _locationManager.locatingWithReGeocode = options.locatingWithReGeocode
        switch options.reGeocodeLanguage {
        case 0:
            _locationManager.reGeocodeLanguage = .default
        case 1:
            _locationManager.reGeocodeLanguage = .chinse
        case 2:
            _locationManager.reGeocodeLanguage = .english
        default:
            _locationManager.reGeocodeLanguage = .default
        }
    }

    func singleLocation(_ isReGeocode:Bool!) {
        _locationManager.requestLocation(withReGeocode: isReGeocode, completionBlock: { (location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in

            if let error = error {
                let error = error as NSError

                if error.code == AMapLocationErrorCode.locateFailed.rawValue {
                    //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
                    NSLog("定位错误:{\(error.code) - \(error.localizedDescription)};")
                    FlutterAmapPlugin.locationChannel().invokeMethod("locationError", arguments: "定位错误:{\(error.code) - \(error.localizedDescription)}")
                    return
                } else if error.code == AMapLocationErrorCode.reGeocodeFailed.rawValue
                                  || error.code == AMapLocationErrorCode.timeOut.rawValue
                                  || error.code == AMapLocationErrorCode.cannotFindHost.rawValue
                                  || error.code == AMapLocationErrorCode.badURL.rawValue
                                  || error.code == AMapLocationErrorCode.notConnectedToInternet.rawValue
                                  || error.code == AMapLocationErrorCode.cannotConnectToHost.rawValue {

                    //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
                    NSLog("逆地理错误:{\(error.code) - \(error.localizedDescription)};")
                    FlutterAmapPlugin.locationChannel().invokeMethod("locationError", arguments: "逆地理错误:{\(error.code) - \(error.localizedDescription)}")
                } else {
                    //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
                }
            }
            if let location = location {
                if isReGeocode {
                    if let reGeocode = reGeocode {
                        NSLog("reGeocode:%@", reGeocode)
                        FlutterAmapPlugin.locationChannel().invokeMethod("reGeocodeSuccess", arguments: ["address":reGeocode.formattedAddress ?? "","lat":location.coordinate.latitude,"lon":location.coordinate.longitude])
                    }
                } else {
                    NSLog("location:%@", location)
                    FlutterAmapPlugin.locationChannel().invokeMethod("locationSuccess", arguments: ["lat":location.coordinate.latitude,"lon":location.coordinate.longitude])
                }
            }
        })
    }
}

public class FlutterAMapStopLocation: NSObject {
    public override init() {
        super.init()
    }

    @objc public func onMethod(call: FlutterMethodCall?, result: FlutterResult) {
        _locationManager.stopUpdatingLocation()
        _locationManager.delegate = nil
        _locationManager = nil
        result("stop location")
    }
    
    deinit {
        print("FlutterAMapStopLocation delloc")
    }
}
