//  Runner
//
//  Created by 冯顺 on 2019/4/23.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import UIKit
import HandyJSON

class AMapNavModel: NSObject, HandyJSON {
    required override init() {
    }
}

class NavOptions: AMapNavModel {

    ///导航界面跟随模式,默认AMapNaviViewTrackingModeMapNorth
    var trackingMode: Int!

    ///是否显示界面元素,默认YES
    var showUIElements: Bool!

    ///是否显示路口放大图,默认YES
    var showCrossImage: Bool!

    ///是否显示实时交通按钮,默认YES
    var showTrafficButton: Bool!

    ///是否显示路况光柱,默认YES
    var showTrafficBar: Bool!

    ///是否显示全览按钮,默认YES
    var showBrowseRouteButton: Bool!

    ///是否显示更多按钮,默认YES
    var showMoreButton: Bool!


}

class LatLon: AMapNavModel {
    var latitude: CGFloat!
    var longitude: CGFloat!

}
