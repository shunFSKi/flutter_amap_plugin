# flutter_amap_plugin

A Flutter plugin that provides a AMap Maps widget.

Base on PlatformView.

## Usage

git:

```
flutter_amap_plugin:
    git:
      url: https://github.com/shunFSKi/flutter_amap_plugin.git
      ref: develop
```

pub:

```
pubspec.yaml add
flutter_amap_plugin
```

# Getting Started

## SetKey

#### iOS

```
FlutterAmapPlugin.initAMapIOSKey('AMapAPPKey_iOS')
```

#### Android

```
flutter_amap_plugin/example/android/app/src/main/AndroidManifest.xml

<application
    android:name="io.flutter.app.FlutterApplication"
    android:label="flutter_amap_plugin_example"
    android:icon="@mipmap/ic_launcher">
    <meta-data
        android:name="com.amap.api.v2.apikey"
        android:value="AMapAPPKey_Android">
    </meta-data>
    ...
 </application>

```

## config

#### iOS

```
info.plist

<key>io.flutter.embedded_views_preview</key>
	<true/>
```

```
open Capabilities/Background Modes/Location updates
```

#### Android

```
Just config amap key, nothing else
```

## Languages And SDK

#### Languages

```
Java
swift -- 5.0
Dart -- 2.3.0
```
#### SDK

```
Flutter -- stable 1.5
```
```
iOS：
'AMapNavi-NO-IDFA', '6.7.0'
'AMapLocation-NO-IDFA', '2.6.2'
'HandyJSON', '5.0.0-beta.1'

Android：
'com.amap.api:navi-3dmap:6.5.0_3dmap6.5.0'
'com.amap.api:search:6.5.0.1'
'com.amap.api:location:4.4.0'
'com.google.code.gson:gson:2.2.4'
'com.mylhyl:acp:1.2.0'
```

## Preview
![](https://github.com/shunFSKi/flutter_amap_plugin/blob/master/example/IMG_0182.PNG)
![](https://github.com/shunFSKi/flutter_amap_plugin/blob/master/example/IMG_0184.PNG)

