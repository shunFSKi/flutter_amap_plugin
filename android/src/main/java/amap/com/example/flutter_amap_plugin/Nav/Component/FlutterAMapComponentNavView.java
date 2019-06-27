package amap.com.example.flutter_amap_plugin.Nav.Component;

import android.app.Activity;
import android.content.Context;
import android.util.Log;
import android.view.View;

import com.amap.api.maps.model.LatLng;
import com.amap.api.maps.model.Poi;
import com.amap.api.navi.AmapNaviPage;
import com.amap.api.navi.AmapNaviParams;
import com.amap.api.navi.AmapNaviType;
import com.amap.api.navi.AmapPageType;
import com.amap.api.navi.INaviInfoCallback;
import com.amap.api.navi.model.AMapNaviLocation;
import com.google.gson.Gson;

import amap.com.example.flutter_amap_plugin.Map.Coordinate;
import amap.com.example.flutter_amap_plugin.Nav.AMapNavModel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.platform.PlatformView;

/**
 * Created by fengshun
 * Create Date 2019-06-27 15:25
 * amap.com.example.flutter_amap_plugin.Nav.Component
 */
public class FlutterAMapComponentNavView implements INaviInfoCallback, MethodChannel.MethodCallHandler {
    private final Context context;
    private Coordinate latlon;

    public FlutterAMapComponentNavView(PluginRegistry.Registrar registrar) {
        this.context = registrar.context();
    }

    void initNav() {
//        LatLng p4 = new LatLng(39.773801, 116.368984);//新三余公园(南5环)
//        Poi end = new Poi("新三余公园(南5环)", p4, "");
        Poi end = new Poi(null, new LatLng(latlon.latitude, latlon.longitude), "");
        AmapNaviParams amapNaviParams = new AmapNaviParams(null, null, end, AmapNaviType.DRIVER, AmapPageType.NAVI);
        amapNaviParams.setUseInnerVoice(true);
        AmapNaviPage.getInstance().showRouteActivity(context, amapNaviParams, this);
    }

    @Override
    public void onInitNaviFailure() {
    }

    @Override
    public void onGetNavigationText(String s) {
    }

    @Override
    public void onLocationChange(AMapNaviLocation aMapNaviLocation) {
    }

    @Override
    public void onArriveDestination(boolean b) {
    }

    @Override
    public void onStartNavi(int i) {
    }

    @Override
    public void onCalculateRouteSuccess(int[] ints) {
    }

    @Override
    public void onCalculateRouteFailure(int i) {
    }

    @Override
    public void onStopSpeaking() {

    }

    @Override
    public void onReCalculateRoute(int i) {
    }

    @Override
    public void onExitPage(int i) {

    }

    @Override
    public void onStrategyChanged(int i) {

    }

    @Override
    public View getCustomNaviBottomView() {
        return null;
    }

    @Override
    public View getCustomNaviView() {
        return null;
    }

    @Override
    public void onArrivedWayPoint(int i) {

    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        if (methodCall.method.equals("startComponentNav")) {
            if (methodCall.arguments instanceof String) {
                Gson gson = new Gson();
                Coordinate model;
                model = gson.fromJson(methodCall.arguments.toString(), Coordinate.class);
                latlon = model;
                initNav();
            }
        }
    }
}
