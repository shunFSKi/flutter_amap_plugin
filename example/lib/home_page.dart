import 'package:flutter/material.dart';
import './amap_drawer.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AMap plugin demo'),
      ),
      body: Container(),
      drawer: AMapDrawer(),
    );
  }
}