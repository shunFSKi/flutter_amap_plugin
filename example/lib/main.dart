import 'package:flutter/material.dart';
import './home_page.dart';
import 'package:flutter_amap_plugin/flutter_amap_plugin.dart';

Future main() async {
  final result = await FlutterAmapPlugin.initAMapIOSKey(
      '43b92ce7414d30f4dc7d07ae3db596dd');
  print(result);
  runApp(AMapPluginApp());
}

class AMapPluginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: ThemeData(primaryColor: Color(0xff1E1E1E)),
    );
  }
}
