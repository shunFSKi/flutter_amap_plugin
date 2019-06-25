//
// Created by 冯顺 on 2019-06-10.
//

import Foundation
import HandyJSON

class AMapRoutePlanningModel: NSObject, HandyJSON {
    required override init() {

    }
}

class RoutePlanningModel: AMapRoutePlanningModel {

    ///出发点
    var origin: Coordinate!

    ///目的地
    var destination: Coordinate!

    /**
     驾车导航策略，默认策略为0。
        0，速度优先（时间)；
        1，费用优先（不走收费路段的最快道路）；
        2，距离优先；
        3，不走快速路；
        4，躲避拥堵；
        5，多策略（同时使用速度优先、费用优先、距离优先三个策略计算路径），其中必须说明，就算使用三个策略算路，会根据路况不固定的返回一至三条路径规划信息；
        6，不走高速；
        7，不走高速且避免收费；
        8，躲避收费和拥堵；
        9，不走高速且躲避收费和拥堵；
        10，多备选，时间最短，距离最短，躲避拥堵（考虑路况）；
        11，多备选，时间最短，距离最短；
        12，多备选，躲避拥堵（考虑路况）；
        13，多备选，不走高速；
        14，多备选，费用优先；
        15，多备选，躲避拥堵，不走高速（考虑路况）；
        16，多备选，费用有限，不走高速；
        17，多备选，躲避拥堵，费用优先（考虑路况）；
        18，多备选，躲避拥堵，不走高速，费用优先（考虑路况）；
        19，多备选，高速优先；
        20，多备选，高速优先，躲避拥堵（考虑路况）
     */
    var strategy: Int!

    ///途经点 AMapGeoPoint 数组，最多支持16个途经点
    var waypoints: [Coordinate]!

    ///避让区域 AMapGeoPolygon 数组，最多支持100个避让区域，每个区域16个点
    var avoidpolygons: [Coordinate]!

    ///避让道路名
    var avoidroad: String!

    ///出发点 POI ID
    var originId: String!

    ///目的地 POI ID
    var destinationId: String!

    ///出发点POI类型编码
    var origintype: String!

    ///目的地POI类型编码
    var destinationtype: String!

    ///是否返回扩展信息，默认为 NO
    var requireExtension: Bool!

    ///车牌省份，用汉字填入车牌省份缩写。用于判断是否限行
    var plateProvince: String!

    ///车牌详情,填入除省份及标点之外的字母和数字（需大写）。用于判断是否限行。
    var plateNumber: String!

    ///使用轮渡,0使用1不使用,默认为0使用
    var ferry: Int!
}
