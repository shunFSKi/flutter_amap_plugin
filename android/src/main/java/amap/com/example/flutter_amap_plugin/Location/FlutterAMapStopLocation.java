package amap.com.example.flutter_amap_plugin.Location;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class FlutterAMapStopLocation implements MethodChannel.MethodCallHandler {

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        FlutterAMapLocationRegister.mLocationClient.stopLocation();
        FlutterAMapLocationRegister.mLocationClient.onDestroy();//销毁定位客户端，同时销毁本地定位服务。
        FlutterAMapLocationRegister.mLocationClient.setLocationListener(null);
        FlutterAMapLocationRegister.mLocationClient = null;
        result.success("stop location");
    }
}
