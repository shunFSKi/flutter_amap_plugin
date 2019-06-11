import 'package:flutter/material.dart';
import 'package:flutter_amap_plugin/common/coordinate.dart';
import 'package:flutter_amap_plugin/model/amap_base_model.dart';

class AMapRouteOptions extends AMapBaseModel {
  ///出发点
  final Coordinate origin;

  ///目的地
  final Coordinate destination;

  /*
  * 驾车导航策略，默认策略为0。
        0，速度优先（时间)；1，费用优先（不走收费路段的最快道路）；
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
        20，多备选，高速优先，躲避拥堵（考虑路况）*/
  final int strategy;

  AMapRouteOptions({
    @required this.origin,
    @required this.destination,
    this.strategy = 0,
  });

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'strategy': strategy,
    };
    if (origin != null && destination != null) {
      map['origin'] = origin.toJson();
      map['destination'] = destination.toJson();
    }
    return map;
  }
}
