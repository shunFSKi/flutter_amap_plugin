//
//  FlutterAMapViewFactory.swift
//  Runner
//
//  Created by 冯顺 on 2019/4/23.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Flutter
import UIKit
import AMapNaviKit

private let MAP_CHANNEL_NAME = "plugin/amap/map"
class FlutterAMapView: NSObject, FlutterPlatformView {
    fileprivate var viewId: Int64!
    fileprivate var methodChannel:FlutterMethodChannel!
    fileprivate var aMapView:MAMapView!
    fileprivate var mapOptions:MapOptions!
    fileprivate var annoOptions:AnnotationOptions!
    var annotations: Array<MAPointAnnotation>!
    var addAnnotitons = false
    
    
    func view() -> UIView {
        return self.aMapView ?? UIView()
    }
    
    public init(withFrame frame: CGRect, viewIdentifier viewId: Int64, binaryMessenger: FlutterBinaryMessenger, options: MapOptions?) {
        super.init()
        
        self.viewId = viewId
        self.mapOptions = options
        self.aMapView = MAMapView.init(frame: frame)
        self.aMapView.delegate = self
        
        configMapOptions()
        
        self.methodChannel = FlutterMethodChannel(name: "\(MAP_CHANNEL_NAME)/\(viewId)", binaryMessenger: binaryMessenger)
        
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
            aMapView.mapType = MAMapType(rawValue: mapOptions.mapType!)!
            aMapView.isShowTraffic = mapOptions.showTraffic
            aMapView.showsScale = mapOptions.showsScale
            aMapView.showsCompass = mapOptions.showsCompass
            aMapView.showsUserLocation = mapOptions.showsUserLocation
            aMapView.userTrackingMode = MAUserTrackingMode(rawValue: mapOptions.userTrackingMode!)!
            if mapOptions.centerCoordinate != nil {
                aMapView.centerCoordinate = mapOptions.centerCoordinate.toCLLocationCoordinate2D()
            }
            aMapView.zoomLevel = mapOptions.zoomLevel
            aMapView.minZoomLevel = mapOptions.minZoomLevel
            aMapView.maxZoomLevel = mapOptions.maxZoomLevel
            aMapView.rotationDegree = mapOptions.rotationDegree
            aMapView.cameraDegree = mapOptions.cameraDegree
            aMapView.zoomingInPivotsAroundAnchorPoint = mapOptions.zoomingInPivotsAroundAnchorPoint
            aMapView.isZoomEnabled = mapOptions.zoomEnabled
            aMapView.isScrollEnabled = mapOptions.scrollEnabled
            aMapView.isRotateEnabled = mapOptions.rotateEnabled
        }
    }
    
    func configAnnotationOptions(_ annotationView: MAAnnotationView!) {
        if annoOptions != nil {
            annotationView!.canShowCallout = annoOptions.canShowCallout
            annotationView!.isDraggable = annoOptions.draggable
            if annoOptions.annotationIcon != nil {
                let image = UIImage.init(contentsOfFile: PluginAssets.defaultAssestPath(asset: annoOptions.annotationIcon))
                
                annotationView.image = image
            }
        }
    }
    
    func initAnnotations() {
        
        annotations = Array()
        
        for (idx, coor) in annoOptions.annotationCoordinates.enumerated() {
            let anno = MAPointAnnotation()
            anno.coordinate = coor.coordinate.toCLLocationCoordinate2D()
            anno.title = coor.title
            anno.subtitle = coor.subTitle
            annotations.append(anno)
        }
        
        aMapView.addAnnotations(annotations)
        aMapView.showAnnotations(annotations, animated: true)
    }
    
    
    func onMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) -> Bool {
        let method = call.method
        if method == "annotation_add" {
            if let options = AnnotationOptions.deserialize(from: call.arguments as? String) {
                annoOptions = options
                addAnnotitons = true
            } else {
                result(FlutterError.init(code: "0", message: "args not json string", details: nil))
            }
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
        methodChannel.invokeMethod("mapViewWillStartLoadingMap", arguments: "start")
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MAMapView!) {
        methodChannel.invokeMethod("mapViewDidFinishLoadingMap", arguments: "finish")
    }
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKind(of: MAUserLocation.self) {
            return nil
        }
        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: MAAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) 
            
            if annotationView == nil {
                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
                configAnnotationOptions(annotationView)
            }
            
            if let index = annotations.firstIndex(of: annotation as! MAPointAnnotation) {
                if annoOptions.annotationCoordinates[index].annotationIcon != nil {
                    if let image = UIImage.init(contentsOfFile: PluginAssets.defaultAssestPath(asset: annoOptions.annotationCoordinates[index].annotationIcon)) {
                        annotationView?.image = image
                    }
                }
            }
            
            if annotationView?.image != nil {
                let size = annotationView!.imageView.frame.size
                annotationView?.frame = CGRect.init(x: annotationView!.center.x + size.width/2, y: annotationView!.center.y, width: 36, height: 36)
                annotationView?.centerOffset = CGPoint.init(x: 0, y: -18)
                
            }
            
            return annotationView!
        }
        
        return nil
    }
    
    func mapInitComplete(_ mapView: MAMapView!) {
        
        if addAnnotitons {
            initAnnotations()
        }
        
    }
    
    func mapView(_ mapView: MAMapView!, didAnnotationViewTapped view: MAAnnotationView!) {
        
    }
    
    func mapView(_ mapView: MAMapView!, didAnnotationViewCalloutTapped view: MAAnnotationView!) {
        if let index = annotations.firstIndex(of: view!.annotation as! MAPointAnnotation) {
            methodChannel.invokeMethod("annotation_tap", arguments: ["tapIndex":index])
        }
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

