package amap.com.example.flutter_amap_plugin.Search;


import com.amap.api.services.core.LatLonPoint;
import com.amap.api.services.route.BusRouteResult;
import com.amap.api.services.route.DrivePath;
import com.amap.api.services.route.DriveRouteResult;
import com.amap.api.services.route.RideRouteResult;
import com.amap.api.services.route.RouteSearch;
import com.amap.api.services.route.WalkRouteResult;
import com.amap.api.services.share.ShareSearch;
import com.google.gson.Gson;

import java.util.HashMap;
import java.util.Map;

import amap.com.example.flutter_amap_plugin.FlutterAmapPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * Created by fengshun
 * Create Date 2019-06-11 14:44
 * amap.com.example.flutter_amap_plugin.Search
 */
public class FlutterAMapSearchRegister implements MethodChannel.MethodCallHandler, RouteSearch.OnRouteSearchListener, ShareSearch.OnShareSearchListener {
    public static final String SEARCH_ROUTE_CHANNEL_NAME = "plugin/amap/search/route";
    private RouteSearch mRouteSearch;
    private ShareSearch mShareSearch;

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        if (methodCall.arguments instanceof String) {
            AMapRoutePlanningModel model = new Gson().fromJson(methodCall.arguments.toString(), AMapRoutePlanningModel.class);
            mRouteSearch = new RouteSearch(FlutterAmapPlugin.registrar.activity().getApplicationContext());
            mRouteSearch.setRouteSearchListener(this);
            routePlanning(model);

            mShareSearch = new ShareSearch(FlutterAmapPlugin.registrar.activity().getApplicationContext());
            mShareSearch.setOnShareSearchListener(this);
            routeShareUrl(model);
        }


    }

    private void routePlanning(AMapRoutePlanningModel model) {
        LatLonPoint mStartPoint = new LatLonPoint(model.origin.latitude, model.origin.longitude);//起点，39.942295,116.335891
        LatLonPoint mEndPoint = new LatLonPoint(model.destination.latitude, model.destination.longitude);//终点，39.995576,116.481288
        final RouteSearch.FromAndTo fromAndTo = new RouteSearch.FromAndTo(
                mStartPoint, mEndPoint);
        RouteSearch.DriveRouteQuery query = new RouteSearch.DriveRouteQuery(fromAndTo, model.strategy, null, null, "");
        mRouteSearch.calculateDriveRouteAsyn(query);
    }

    private void routeShareUrl(AMapRoutePlanningModel model) {
        LatLonPoint mStartPoint = new LatLonPoint(model.origin.latitude, model.origin.longitude);//起点，39.942295,116.335891
        LatLonPoint mEndPoint = new LatLonPoint(model.destination.latitude, model.destination.longitude);//终点，39.995576,116.481288
        ShareSearch.ShareFromAndTo fromAndTo = new ShareSearch.ShareFromAndTo(mStartPoint, mEndPoint);
        ShareSearch.ShareDrivingRouteQuery query = new ShareSearch.ShareDrivingRouteQuery(fromAndTo,
                ShareSearch.DrivingDefault);
        mShareSearch.searchDrivingRouteShareUrlAsyn(query);
    }

    @Override
    public void onBusRouteSearched(BusRouteResult busRouteResult, int i) {

    }

    @Override
    public void onDriveRouteSearched(DriveRouteResult driveRouteResult, int i) {
        if (driveRouteResult.getPaths().size() > 0) {
            DrivePath drivePath = driveRouteResult.getPaths().get(0);
            Map<String, Object> map = new HashMap<>();
            map.put("duration", drivePath.getDuration());
            map.put("distance", drivePath.getDistance());
            map.put("strategy", drivePath.getStrategy());
            map.put("totalTrafficLights", drivePath.getTotalTrafficlights());
            FlutterAmapPlugin.routeChannel.invokeMethod("onRouteSearchDone", map);
        } else {
            FlutterAmapPlugin.locChannel.invokeMethod("routePlanningError",
                    "路线规划错误:{" + i + " - 未发现有效路径}");
        }
    }

    @Override
    public void onWalkRouteSearched(WalkRouteResult walkRouteResult, int i) {

    }

    @Override
    public void onRideRouteSearched(RideRouteResult rideRouteResult, int i) {

    }


    //    share
    @Override
    public void onPoiShareUrlSearched(String s, int i) {

    }

    @Override
    public void onLocationShareUrlSearched(String s, int i) {

    }

    @Override
    public void onNaviShareUrlSearched(String s, int i) {

    }

    @Override
    public void onBusRouteShareUrlSearched(String s, int i) {

    }

    @Override
    public void onWalkRouteShareUrlSearched(String s, int i) {

    }

    @Override
    public void onDrivingRouteShareUrlSearched(String s, int i) {
        if (i == 1000) {
            Map<String, Object> map = new HashMap<>();
            map.put("shareURL", s);
            FlutterAmapPlugin.routeChannel.invokeMethod("onShareSearchDone", map);
        } else {
            FlutterAmapPlugin.locChannel.invokeMethod("routePlanningError",
                    "路线规划错误:{" + i + " - 未发现有效路径}");
        }
    }
}
