package amap.com.example.flutter_amap_plugin;

import android.Manifest;
import android.app.Activity;
import android.app.Application;
import android.os.Bundle;

import com.amap.api.maps.model.LatLng;
import com.amap.api.maps.model.Poi;
import com.amap.api.navi.AmapNaviPage;
import com.amap.api.navi.AmapNaviParams;
import com.amap.api.navi.AmapNaviType;
import com.amap.api.navi.AmapPageType;
import com.mylhyl.acp.Acp;
import com.mylhyl.acp.AcpListener;
import com.mylhyl.acp.AcpOptions;

import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

import amap.com.example.flutter_amap_plugin.Location.FlutterAMapLocationRegister;
import amap.com.example.flutter_amap_plugin.Location.FlutterAMapStartLocation;
import amap.com.example.flutter_amap_plugin.Location.FlutterAMapStopLocation;
import amap.com.example.flutter_amap_plugin.Map.FlutterAMapView;
import amap.com.example.flutter_amap_plugin.Map.FlutterAMapViewFactory;
import amap.com.example.flutter_amap_plugin.Nav.Component.FlutterAMapComponentNavView;
import amap.com.example.flutter_amap_plugin.Nav.FlutterAMapNavFactory;
import amap.com.example.flutter_amap_plugin.Nav.FlutterAMapNavView;
import amap.com.example.flutter_amap_plugin.Search.FlutterAMapConvertRegister;
import amap.com.example.flutter_amap_plugin.Search.FlutterAMapSearchRegister;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import static amap.com.example.flutter_amap_plugin.Location.FlutterAMapLocationRegister.LOCATION_CHANNEL_NAME;
import static amap.com.example.flutter_amap_plugin.Search.FlutterAMapConvertRegister.SEARCH_CONVERT_CHANNEL_NAME;
import static amap.com.example.flutter_amap_plugin.Search.FlutterAMapSearchRegister.SEARCH_ROUTE_CHANNEL_NAME;

/**
 * FlutterAmapPlugin
 */
public class FlutterAmapPlugin implements MethodCallHandler {
    /**
     * Plugin registration.
     */

    public static final String MAP_BASE_CHANNEL = "plugin/base/init";

    public static Registrar registrar;
    public static MethodChannel locChannel;
    public static MethodChannel routeChannel;
    public static MethodChannel convertChannel;

    // 当前Activity环境
    private static FlutterActivity root;
    public static final int CREATED = 1;
    public static final int STARTED = 2;
    public static final int RESUMED = 3;
    public static final int PAUSED = 4;
    public static final int STOPPED = 5;
    public static final int DESTROYED = 6;


    private final AtomicInteger state = new AtomicInteger(0);

    private String[] maniFests = {
            Manifest.permission.ACCESS_COARSE_LOCATION,
            Manifest.permission.WRITE_EXTERNAL_STORAGE,
            Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.READ_EXTERNAL_STORAGE,
            Manifest.permission.READ_PHONE_STATE};

    public FlutterAmapPlugin(FlutterActivity activity) {
        FlutterAmapPlugin.root = activity;
        FlutterAmapPlugin.root.getApplication()
                .registerActivityLifecycleCallbacks(new Application.ActivityLifecycleCallbacks() {
                    @Override
                    public void onActivityCreated(Activity activity, Bundle savedInstanceState) {
                        if (activity != root) {
                            return;
                        }
                        state.set(CREATED);
                    }

                    @Override
                    public void onActivityStarted(Activity activity) {
                        if (activity != root) {
                            return;
                        }
                        state.set(STARTED);
                    }

                    @Override
                    public void onActivityResumed(Activity activity) {
                        if (activity != root) {
                            return;
                        }
                        state.set(RESUMED);

                    }

                    @Override
                    public void onActivityPaused(Activity activity) {
                        if (activity != root) {
                            return;
                        }
                        state.set(PAUSED);
                    }

                    @Override
                    public void onActivityStopped(Activity activity) {
                        if (activity != root) {
                            return;
                        }
                        state.set(STOPPED);
                    }

                    @Override
                    public void onActivitySaveInstanceState(Activity activity, Bundle outState) {
                        if (activity != root) {
                            return;
                        }
                    }

                    @Override
                    public void onActivityDestroyed(Activity activity) {
                        if (activity != root) {
                            return;
                        }
                        state.set(DESTROYED);
                    }
                });

        requestPermission();
    }

    public static void registerWith(Registrar registrar) {
        FlutterAmapPlugin.registrar = registrar;

        final MethodChannel channel = new MethodChannel(registrar.messenger(), MAP_BASE_CHANNEL);
        channel.setMethodCallHandler(new FlutterAmapPlugin((FlutterActivity) registrar.activity()));

        final MethodChannel locChannel = new MethodChannel(registrar.messenger(), LOCATION_CHANNEL_NAME);
        locChannel.setMethodCallHandler(new FlutterAmapPlugin((FlutterActivity) registrar.activity()));
        FlutterAmapPlugin.locChannel = locChannel;

        final MethodChannel routeChannel = new MethodChannel(registrar.messenger(), SEARCH_ROUTE_CHANNEL_NAME);
        routeChannel.setMethodCallHandler(new FlutterAmapPlugin((FlutterActivity) registrar.activity()));
        FlutterAmapPlugin.routeChannel = routeChannel;

        final MethodChannel convertChannel = new MethodChannel(registrar.messenger(), SEARCH_CONVERT_CHANNEL_NAME);
        convertChannel.setMethodCallHandler(new FlutterAmapPlugin((FlutterActivity) registrar.activity()));
        FlutterAmapPlugin.convertChannel = convertChannel;

        final MethodChannel navChannel = new MethodChannel(registrar.messenger(), FlutterAMapNavView.NAV_CHANNEL_NAME);
        navChannel.setMethodCallHandler(new FlutterAmapPlugin((FlutterActivity) registrar.activity()));

        final FlutterAmapPlugin plugin = new FlutterAmapPlugin(root);

        registrar.platformViewRegistry().registerViewFactory(FlutterAMapView.MAP_CHANNEL_NAME,
                new FlutterAMapViewFactory(plugin.state, registrar));
        registrar.platformViewRegistry().registerViewFactory(FlutterAMapNavView.NAV_CHANNEL_NAME,
                new FlutterAMapNavFactory(plugin.state, registrar));
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch (call.method) {
            case "getPlatformVersion":
                result.success("Android " + android.os.Build.VERSION.RELEASE);
                break;
            case "initKey":
                result.success("init");
                break;
            case "initLocation":
                new FlutterAMapLocationRegister().onMethodCall(call, result);
                break;
            case "startSingleLocation":
                new FlutterAMapStartLocation().onMethodCall(call, result);
                break;
            case "stopLocation":
                new FlutterAMapStopLocation().onMethodCall(call, result);
                break;
            case "startRoutePlanning":
                new FlutterAMapSearchRegister().onMethodCall(call, result);
                break;
            case "geoToCoordinate":
                new FlutterAMapConvertRegister().onMethodCall(call, result);
                break;
            case "coordinateToGeo":
                new FlutterAMapConvertRegister().onMethodCall(call, result);
                break;
            case "startComponentNav":
//                initNav();
                new FlutterAMapComponentNavView(registrar).onMethodCall(call,result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    void initNav() {
        LatLng p4 = new LatLng(39.773801, 116.368984);//新三余公园(南5环)
        Poi end = new Poi("新三余公园(南5环)", p4, "");
//        Poi end = new Poi(null, new LatLng(latlon.latitude, latlon.longitude), "");
        AmapNaviParams amapNaviParams = new AmapNaviParams(null, null, end, AmapNaviType.DRIVER, AmapPageType.NAVI);
        amapNaviParams.setUseInnerVoice(true);
        AmapNaviPage.getInstance().showRouteActivity(FlutterAmapPlugin.root.getApplicationContext(), amapNaviParams, null);
    }

    /**
     * 获取权限
     */
    private void requestPermission() {
        Acp.getInstance(root).request(new AcpOptions.Builder().setPermissions(maniFests).build(), new AcpListener() {
            @Override
            public void onGranted() {
            }

            @Override
            public void onDenied(List<String> permissions) {
            }
        });
    }

}
