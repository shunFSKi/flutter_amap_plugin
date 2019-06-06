import 'package:flutter/material.dart';
import './amap_map/amap_map_page.dart';
import './amap_map/amap_nav_page.dart';
import './amap_map/amap_location_page.dart';

class AMapDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Drawer(
        child: Container(
            child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.zero,
              child: Container(
                color: Color(0xff1E1E1E),
              ),
            ),
            ListTile(
              title: Text('地图展示'),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return MapPage(
                    title: '地图展示',
                  );
                }));
              },
            ),
            ListTile(
              title: Text('导航展示'),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return NavPage(
                    title: '导航展示',
                  );
                }));
              },
            ),
            ListTile(
              title: Text('获取单次定位'),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return LocationPage(
                    title: '获取单次定位',
                  );
                }));
              },
            ),
          ],
        )),
      ),
    );
  }
}
