import 'package:flutter/material.dart';
import 'package:flutter_amap_plugin/flutter_amap_plugin.dart';

class LocationPage extends StatefulWidget {
  final String title;

  const LocationPage({Key key, this.title}) : super(key: key);

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String _address = '';
  AMapLocationController _aMapLocationController = AMapLocationController();

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
                RaisedButton(
                  onPressed: _startLocation,
                  child: Text('获取逆地理信息定位'),
                ),
                Text(_address),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _startLocation() {
    _aMapLocationController.initLocation(
        onLocationCallHandler: (address, lon, lat, error) {
      if (error == null) {
        print('address: $address\nlon: $lon\nlat: $lat');
        _address = 'address: $address\nlon: $lon\nlat: $lat';
      } else {
        print('error: $error');
        _address = 'error: $error';
      }
      setState(() {});
    });
    _aMapLocationController
        .startSingleLocation(
      options: AMapLocationOptions(
        isReGeocode: true,
        reGeocodeLanguage: AMapLocationReGeocodeLanguage.chinese,
        allowsBackgroundLocationUpdates: true,
        locationTimeout: 2,
        reGeocodeTimeout: 2,
      ),
    )
        .then((value) {
      print('amap_location log: $value');
      _address = '获取定位中';
      setState(() {});
    });
  }
}
