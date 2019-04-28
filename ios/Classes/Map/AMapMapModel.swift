//
//  AMapMapModel.swift
//  Runner
//
//  Created by 冯顺 on 2019/4/22.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import UIKit
import HandyJSON
import MAMapKit

class AMapMapModel: NSObject, HandyJSON {
    required override init() {}
}

class MapOptions: AMapMapModel {
    
    /// 地图类型
    var mapType:Int!
    
    /// 当前地图的中心点坐标
    var centerCoordinate: Coordinate!
    
    ///缩放级别（默认3-19，有室内地图时为3-20）
    var zoomLevel: CGFloat!
    
    ///最小缩放级别
    var minZoomLevel: CGFloat!
    
    ///最大缩放级别（有室内地图时最大为20，否则为19）
    var maxZoomLevel: CGFloat!
    
    ///设置地图旋转角度(逆时针为正向)
    var rotationDegree: CGFloat!
    
    ///设置地图相机角度(范围为[0.f, 60.f]，但高于40度的角度需要在16级以上才能生效)
    var cameraDegree: CGFloat!
    
    ///是否以screenAnchor点作为锚点进行缩放，默认为YES。如果为NO，则以手势中心点作为锚点
    var zoomingInPivotsAroundAnchorPoint: Bool!
    
    ///是否支持缩放, 默认YES
    var zoomEnabled: Bool!
    
    ///是否支持平移, 默认YES
    var scrollEnabled: Bool!
    
    ///是否支持旋转, 默认YES
    var rotateEnabled: Bool!
    
    ///是否支持camera旋转, 默认YES
    var rotateCameraEnabled: Bool!
    
    ///是否显示比例尺, 默认YES
    var showsScale: Bool!
    
    ///是否显示用户位置
    var showsUserLocation: Bool!
    
    ///是否显示指南针, 默认YES
    var showsCompass: Bool!
    
    ///是否显示交通路况图层, 默认为NO
    var showTraffic:Bool!
    
    ///定位用户位置的模式, 注意：在follow模式下，设置地图中心点、设置可见区域、滑动手势、选择annotation操作会取消follow模式，并触发 - (void)mapView:(MAMapView *)mapView didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated;
    var userTrackingMode: Int!

}

class AnnotationOptions: AMapMapModel {
    
    ///默认为YES,当为NO时view忽略触摸事件
    var enabled: Bool!
    
    ///是否高亮
    var highlighted: Bool!
    
    ///设置是否处于选中状态, 外部如果要选中请使用mapView的selectAnnotation方法
    var selected: Bool!
    
    ///是否允许弹出callout
    var canShowCallout: Bool!
    
    ///是否支持拖动
    var draggable: Bool!
    
    /// 坐标集合
    var annotationCoordinates: Array<AMapAnnotationModel>!
    
    var annotationIcon:String!
    

}

class AMapAnnotationModel: AMapMapModel {
    /// 坐标
    var coordinate : Coordinate!
    
    /// 标题
    var title : String!
    
    /// 副标题
    var subTitle : String!
    
    /// 自定义的标记图标，默认大头针样式
    var annotationIcon : String!

}

class Coordinate: AMapMapModel {
    var latitude: Double!
    var longitude: Double!
    
    func toCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(self.latitude, self.longitude)
    }
}
