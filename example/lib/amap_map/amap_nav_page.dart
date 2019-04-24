import 'package:flutter/material.dart';
import 'package:flutter_amap_plugin/flutter_amap_plugin.dart';

class NavPage extends StatefulWidget {
  final String title;

  const NavPage({Key key, this.title}) : super(key: key);
  @override
  _NavPageState createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  AMapNavController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: AMapNavView(
          onNavViewCreate: (controller) {
            _controller = controller;
            _controller.initNavChannel(context);
            _controller.startAMapNav(
                coordinate: Coordinate(31.712799, 117.168188));
          },
          onCloseHandler: () {
            print('close');
            Navigator.pop(context);
          },
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
