package amap.com.example.flutter_amap_plugin.Location;

import com.amap.api.location.AMapLocationClient;

import amap.com.example.flutter_amap_plugin.FlutterAmapPlugin;
import io.flutter.app.FlutterPluginRegistry;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * Created by fengshun
 * Create Date 2019-06-06 16:56
 * amap.com.example.flutter_amap_plugin.Location
 */
public class FlutterAMapLocationRegister implements MethodChannel.MethodCallHandler {
    public static final String LOCATION_CHANNEL_NAME = "plugin/amap/location";
    public static AMapLocationClient mLocationClient = null;

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        mLocationClient = new AMapLocationClient(FlutterAmapPlugin.registrar.activity().getApplicationContext());
    }
}

