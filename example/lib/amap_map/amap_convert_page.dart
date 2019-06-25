import 'package:flutter/material.dart';
import 'package:flutter_amap_plugin/flutter_amap_plugin.dart';

class ConvertPage extends StatefulWidget {
  final String title;

  ConvertPage({Key key, this.title}) : super(key: key);

  @override
  _ConvertPageState createState() => _ConvertPageState();
}

class _ConvertPageState extends State<ConvertPage> {
  AMapConvertController _aMapConvertController = AMapConvertController();
  TextEditingController _addressController =
      TextEditingController(text: '安徽青网科技园');
  TextEditingController _latController =
      TextEditingController(text: '39.910267');
  TextEditingController _lonController =
      TextEditingController(text: '116.370888');

  String _address = '';
  String _coordinate = '';
  String _error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
          child: ListView(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.all(10.0),
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              hintText: '输入详细地址',
              border: OutlineInputBorder(),
            ),
            style: TextStyle(color: Colors.black26),
            controller: _addressController,
            validator: (value) {
              if (value.isEmpty) {
                return '输入详细地址';
              }
            },
          ),
          Text(_coordinate),
          RaisedButton(
            onPressed: () {
              _geoConvertToCoordinate(_addressController.text);
            },
            child: Text('geoToCoordinate'),
          ),
          Padding(padding: EdgeInsets.only(top: 50)),
          TextFormField(
            decoration: InputDecoration(
              hintText: '输入维度',
              border: OutlineInputBorder(),
            ),
            style: TextStyle(color: Colors.black26),
            controller: _latController,
            validator: (value) {
              if (value.isEmpty) {
                return '输入维度';
              }
            },
          ),
          Padding(padding: EdgeInsets.only(top: 10)),
          TextFormField(
            decoration: InputDecoration(
              hintText: '输入经度',
              border: OutlineInputBorder(),
            ),
            style: TextStyle(color: Colors.black26),
            controller: _lonController,
            validator: (value) {
              if (value.isEmpty) {
                return '输入经度';
              }
            },
          ),
          Text(_address),
          RaisedButton(
            onPressed: () {
              _coordinateToGeo(_latController.text, _lonController.text);
            },
            child: Text('geoToCoordinate'),
          ),
          Text(_error),
        ],
      )),
    );
  }

  void _geoConvertToCoordinate(String address) {
    _aMapConvertController.initConvertChannel(
      onConvertCallHandler: _onConvertCallHandler,
    );
    _aMapConvertController.geoConvertToCoordinate(address);
  }

  void _coordinateToGeo(String lat, String lon) {
    _aMapConvertController.coordinateConvertToGeo(
        Coordinate(double.parse(lat), double.parse(lon)));
  }

  void _onConvertCallHandler(
    Coordinate coordinate,
    String address,
    Error error,
  ) {
    if (coordinate != null) {
      _coordinate = 'lat:${coordinate.latitude}  lon:${coordinate.longitude}';
    }
    if (address != null) {
      _address = address;
    }
    if (error != null) {
      _error = error.toString();
    }
    setState(() {});
  }
}
