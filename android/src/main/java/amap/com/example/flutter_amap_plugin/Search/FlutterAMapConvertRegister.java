package amap.com.example.flutter_amap_plugin.Search;

import com.amap.api.services.core.LatLonPoint;
import com.amap.api.services.geocoder.GeocodeQuery;
import com.amap.api.services.geocoder.GeocodeResult;
import com.amap.api.services.geocoder.GeocodeSearch;
import com.amap.api.services.geocoder.RegeocodeQuery;
import com.amap.api.services.geocoder.RegeocodeResult;
import com.google.gson.Gson;

import java.util.HashMap;
import java.util.Map;

import amap.com.example.flutter_amap_plugin.FlutterAmapPlugin;
import amap.com.example.flutter_amap_plugin.Map.Coordinate;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class FlutterAMapConvertRegister implements MethodChannel.MethodCallHandler, GeocodeSearch.OnGeocodeSearchListener {
    public static final String SEARCH_CONVERT_CHANNEL_NAME = "plugin/amap/search/convert";
    private GeocodeSearch geocoderSearch;

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        geocoderSearch = new GeocodeSearch(FlutterAmapPlugin.registrar.activity().getApplicationContext());
        geocoderSearch.setOnGeocodeSearchListener(this);
        if (methodCall.method.equals("geoToCoordinate")) {
            if (methodCall.arguments instanceof String) {
                geoConvertToCoordinate(methodCall.arguments.toString());
            }
        } else if (methodCall.method.equals("coordinateToGeo")) {
            if (methodCall.arguments instanceof String) {
                Coordinate model = new Gson().fromJson(methodCall.arguments.toString(), Coordinate.class);
                coordinateConvertToGeo(model);
            }
        }
    }

    private void geoConvertToCoordinate(String address) {
        GeocodeQuery query = new GeocodeQuery(address, "");
        geocoderSearch.getFromLocationNameAsyn(query);
    }

    private void coordinateConvertToGeo(Coordinate coordinate) {
        RegeocodeQuery query = new RegeocodeQuery(new LatLonPoint(coordinate.latitude, coordinate.longitude), 200, GeocodeSearch.AMAP);
        geocoderSearch.getFromLocationAsyn(query);
    }

    @Override
    public void onRegeocodeSearched(RegeocodeResult regeocodeResult, int i) {
        if (i == 1000) {
            Map<String, Object> map = new HashMap<>();
            map.put("address", regeocodeResult.getRegeocodeAddress().getFormatAddress());
            FlutterAmapPlugin.convertChannel.invokeMethod("onCoordinateToGeo", map);
        } else {
            FlutterAmapPlugin.locChannel.invokeMethod("onConvertError",
                    "坐标转地址错误:{" + i + " - 未发现有效地址}");
        }
    }

    @Override
    public void onGeocodeSearched(GeocodeResult geocodeResult, int i) {
        if (i == 1000 && geocodeResult.getGeocodeAddressList().size() > 0) {
            LatLonPoint latLonPoint = geocodeResult.getGeocodeAddressList().get(0).getLatLonPoint();
            Map<String, Object> map = new HashMap<>();
            map.put("lat", latLonPoint.getLatitude());
            map.put("lon", latLonPoint.getLongitude());
            FlutterAmapPlugin.convertChannel.invokeMethod("onGeoToCoordinate", map);

        } else {
            FlutterAmapPlugin.locChannel.invokeMethod("onConvertError",
                    "地址转坐标错误:{" + i + " - 未发现有效地址}");
        }

    }
}
