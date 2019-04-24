//
//  FlutterAMapNavFactory.swift
//  Runner
//
//  Created by 冯顺 on 2019/4/23.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Flutter
import UIKit
import AMapNaviKit

private let NAV_CHANNEL_NAME = "plugin/amap/nav"
public class FlutterAMapNavFactory : NSObject, FlutterPlatformViewFactory {
    var messenger: FlutterBinaryMessenger!
    
    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        var options:NavOptions? = nil
        
        if let result = NavOptions.deserialize(from: args as? String) {
            options = result
        }
        return FlutterAmapNavView.init(withFrame: frame, viewIdentifier: viewId, binaryMessenger: messenger, options: options)
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
    
    @objc public init(messenger: (NSObject & FlutterBinaryMessenger)?) {
        super.init()
        self.messenger = messenger
    }
    
}

class FlutterAmapNavView: NSObject, FlutterPlatformView {
    fileprivate var viewId: Int64!
    fileprivate var methodChannel:FlutterMethodChannel!
    fileprivate var navView:AMapNaviDriveView!
    fileprivate var navOptions:NavOptions!
    
    func view() -> UIView {
        return self.navView ?? UIView()
    }
    
    public init(withFrame frame: CGRect, viewIdentifier viewId: Int64, binaryMessenger: FlutterBinaryMessenger, options: NavOptions?) {
        super.init()
        
        navView = AMapNaviDriveView(frame: frame)
        navView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        navView.delegate = self
        
        navOptions = options
        configNavOptions()
        
        // 创建 AMapNaviDriveManager
        AMapNaviDriveManager.sharedInstance().delegate = self
        
        AMapNaviDriveManager.sharedInstance().allowsBackgroundLocationUpdates = true
        AMapNaviDriveManager.sharedInstance().pausesLocationUpdatesAutomatically = false
        
        //将driveView添加为导航数据的Representative，使其可以接收到导航诱导数据
        AMapNaviDriveManager.sharedInstance().addDataRepresentative(navView)
        
        methodChannel = FlutterMethodChannel.init(name: "\(NAV_CHANNEL_NAME)/\(viewId)", binaryMessenger: binaryMessenger)
        methodChannel.setMethodCallHandler {[weak self] (call, result) in
            if let this = self {
                if !this.onMethodCall(call: call, result: result) {
                    result(FlutterMethodNotImplemented)
                }
            }
        }
    }
    
    func configNavOptions() {
        if navOptions != nil {
            navView.trackingMode = AMapNaviViewTrackingMode(rawValue: (navOptions.trackingMode)!)!
            navView.showUIElements = navOptions.showUIElements
            navView.showCrossImage = navOptions.showCrossImage
            navView.showTrafficButton = navOptions.showTrafficButton
            navView.showTrafficBar = navOptions.showTrafficBar
            navView.showBrowseRouteButton = navOptions.showBrowseRouteButton
            navView.showMoreButton = navOptions.showMoreButton
        }
    }
    
    func onMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) -> Bool {
        let method = call.method
        if method == "startNav" {
            guard let arg = call.arguments as? String else {
                result("args is not string")
                return true
            }
            
            guard let latlon = LatLon.deserialize(from: arg) else {
                result("args is not vaild json string")
                return true
            }
            
            let endPoint = AMapNaviPoint.location(withLatitude: latlon.latitude, longitude: latlon.longitude)!
            //进行路径规划
            AMapNaviDriveManager.sharedInstance().calculateDriveRoute(withEnd: [endPoint], wayPoints: nil, drivingStrategy: .singleDefault)
            result("startNav")
        } else {
            return false
        }
        return true
    }
    
    deinit {
        releaseMap()
    }
    
    func releaseMap() {
        AMapNaviDriveManager.sharedInstance().stopNavi()
        AMapNaviDriveManager.sharedInstance().removeDataRepresentative(self.navView)
        AMapNaviDriveManager.sharedInstance().delegate = nil
        let isSuccess = AMapNaviDriveManager.destroyInstance()
        print("release--\(isSuccess)")
        self.navView.removeFromSuperview()
        self.navView.delegate = nil
    }
    
}

extension FlutterAmapNavView: AMapNaviDriveViewDelegate,AMapNaviDriveManagerDelegate {
    
    func driveManager(_ driveManager: AMapNaviDriveManager, onCalculateRouteSuccessWith type: AMapNaviRoutePlanType) {
        //算路成功后开始GPS导航
        AMapNaviDriveManager.sharedInstance().startGPSNavi()
    }
    
    func driveManager(_ driveManager: AMapNaviDriveManager, error: Error) {
        print(String(format: "error:{%ld - %@}", Int(error._code), error.localizedDescription))
    }
    
    func driveViewCloseButtonClicked(_ driveView: AMapNaviDriveView) {
        methodChannel.invokeMethod("close_nav", arguments: nil)
    }
    
    func driveViewMoreButtonClicked(_ driveView: AMapNaviDriveView) {
        methodChannel.invokeMethod("more_nav", arguments: nil)
    }
}
