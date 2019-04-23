import 'package:flutter/material.dart';
import 'package:flutter_amap_plugin/flutter_amap_plugin.dart';

class MapPage extends StatefulWidget {
  final String title;

  const MapPage({Key key, this.title}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  AMapMapController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: AMapMapView(
          onMapViewCreate: (controller) {
            _controller = controller;
          },
          options: AMapMapOptions(
            mapType: AMapMapType.standardNight,
            zoomLevel: 12,
            showsUserLocation: true,
            showsCompass: false,
            showTraffic: true,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
