import 'package:flutter/material.dart';
import 'package:flutter_amap_plugin/flutter_amap_plugin.dart';

class RoutePlanningPage extends StatefulWidget {
  final String title;

  RoutePlanningPage({Key key, this.title}) : super(key: key);

  @override
  _RoutePlanningPageState createState() => _RoutePlanningPageState();
}

class _RoutePlanningPageState extends State<RoutePlanningPage> {
  AMapRouteController _aMapRouteController = AMapRouteController();
  String _routeInfo = '';
  String _shareUrl = '';
  String _error = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 100.0),
            child: Column(
              children: <Widget>[
                Text(
                  '目前只返回规划路线默认第一条',
                  style: TextStyle(fontSize: 15),
                ),
                RaisedButton(
                  onPressed: _startRoutePlanning,
                  child: Text('获取路径规划信息'),
                ),
                Text(_routeInfo),
                Text(_shareUrl),
                Text(_error),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _startRoutePlanning() {
    _routeInfo = '规划路线中';
    _shareUrl = '规划中';
    setState(() {});
    _aMapRouteController.initRouteChannel(
        onRoutePlanningCallHandler: (routeModel, shareURL, error) {
      if (routeModel != null) {
        _routeInfo =
            '距离：${routeModel.distance}\n时间：${routeModel.duration}\n规划策略：${routeModel.strategy}\n沿途红绿灯个数：${routeModel.totalTrafficLights}';
      }
      if (shareURL != null) {
        _shareUrl = shareURL.toString();
      }
      if (error != null) {
        _error = error.toString();
      }
      setState(() {});
    });
    _aMapRouteController.routePlanning(
      AMapRouteOptions(
        origin: Coordinate(39.910267, 116.370888),
        destination: Coordinate(39.989872, 116.481956),
        strategy: 0,
      ),
    );
  }
}
