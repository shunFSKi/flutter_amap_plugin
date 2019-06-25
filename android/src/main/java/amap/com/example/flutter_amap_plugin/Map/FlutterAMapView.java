package amap.com.example.flutter_amap_plugin.Map;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.os.Bundle;
import android.view.View;

import com.amap.api.maps.AMap;
import com.amap.api.maps.AMapOptions;
import com.amap.api.maps.CameraUpdateFactory;
import com.amap.api.maps.TextureMapView;
import com.amap.api.maps.model.LatLng;
import com.amap.api.maps.model.Marker;
import com.amap.api.maps.model.MarkerOptions;
import com.amap.api.maps.model.MyLocationStyle;
import com.google.gson.Gson;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

import amap.com.example.flutter_amap_plugin.PluginAssets;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.platform.PlatformView;

import static amap.com.example.flutter_amap_plugin.FlutterAmapPlugin.CREATED;
import static amap.com.example.flutter_amap_plugin.FlutterAmapPlugin.DESTROYED;
import static amap.com.example.flutter_amap_plugin.FlutterAmapPlugin.RESUMED;
import static amap.com.example.flutter_amap_plugin.FlutterAmapPlugin.STOPPED;

public class FlutterAMapView implements PlatformView, MethodChannel.MethodCallHandler, Application.ActivityLifecycleCallbacks, AMap.OnMapLoadedListener, AMap.OnInfoWindowClickListener {

    public static final String MAP_CHANNEL_NAME = "plugin/amap/map";

    private final Context context;
    private final AtomicInteger atomicInteger;
    private final PluginRegistry.Registrar registrar;
    private final MethodChannel mapChannel;
    private AMapMapModel options;

    private TextureMapView mapView;
    private AMap aMap;

    private boolean disposed = false;
    private ArrayList<MarkerOptions> annotations = new ArrayList<MarkerOptions>();
    private AnnotationOptions annotationOptions;
    private boolean addAnnotations = false;
    private boolean mapLoaded = false;
    private ArrayList<LatLng> positions = new ArrayList<>();

    public FlutterAMapView(Context context, AtomicInteger atomicInteger, PluginRegistry.Registrar registrar, int id, AMapMapModel model) {
        this.context = registrar.activity().getApplicationContext();
        this.atomicInteger = atomicInteger;
        this.registrar = registrar;
        this.options = model;


        mapChannel = new MethodChannel(registrar.messenger(), MAP_CHANNEL_NAME + "/" + id);
        mapChannel.setMethodCallHandler(this);

        mapView = new TextureMapView(this.context);
        mapView.onCreate(null);

        setUpMap();
    }

    private void setUpMap() {
        if (aMap == null) {
            aMap = mapView.getMap();
            if (options != null) {
                aMap.setMapType(options.mapType + 1);
                aMap.setMyLocationEnabled(options.showsUserLocation);
                aMap.moveCamera(CameraUpdateFactory.zoomTo(options.zoomLevel));
                aMap.setMaxZoomLevel(options.maxZoomLevel);
                aMap.setMinZoomLevel(options.minZoomLevel);
                aMap.getUiSettings().setMyLocationButtonEnabled(false);// 设置默认定位按钮是否显示
                aMap.getUiSettings().setScaleControlsEnabled(options.showsScale);
                aMap.getUiSettings().setZoomControlsEnabled(options.zoomEnabled);
                aMap.getUiSettings().setCompassEnabled(options.showsCompass);
                aMap.getUiSettings().setScrollGesturesEnabled(options.scrollEnabled);
                aMap.getUiSettings().setTiltGesturesEnabled(options.rotateCameraEnabled);
                aMap.getUiSettings().setRotateGesturesEnabled(options.rotateEnabled);
                aMap.setMyLocationStyle(new MyLocationStyle().myLocationType(options.userTrackingMode));
                if (options.centerCoordinate != null) {
                    aMap.moveCamera(CameraUpdateFactory.newCameraPosition(options.centerCoordinate.toCameraPosition()));
                }
                aMap.setTrafficEnabled(options.showTraffic);
            }
        }
        aMap.setOnMapLoadedListener(this);
    }

    public void setup() {
        switch (atomicInteger.get()) {
            case STOPPED:
                mapView.onCreate(null);
                mapView.onResume();
                mapView.onPause();
                break;
            case RESUMED:
                mapView.onCreate(null);
                mapView.onResume();
                break;
            case CREATED:
                mapView.onCreate(null);
                break;
            case DESTROYED:

                break;
        }

        registrar.activity().getApplication().registerActivityLifecycleCallbacks(this);
    }

    @Override
    public void onMethodCall(MethodCall methodCall, final MethodChannel.Result result) {
        if (methodCall.method.equals("annotation_add")) {
            if (methodCall.arguments instanceof String) {
                Gson gson = new Gson();
                AnnotationOptions model = new AnnotationOptions();
                model = gson.fromJson(methodCall.arguments.toString(), AnnotationOptions.class);
                this.annotationOptions = model;
                addAnnotations = true;
                addAnnotationsOnMap();
            }
        } else if (methodCall.method.equals("annotation_clear")) {
            aMap.clear(true);
            new Thread(new Runnable() {
                @Override
                public void run() {
                    result.success("clear_success");
                }
            }).start();
        }
    }

    @Override
    public View getView() {
        return mapView;
    }

    @Override
    public void dispose() {
        if (disposed) {
            return;
        }
        disposed = true;
        aMap.setOnInfoWindowClickListener(null);
        mapView.onDestroy();

        registrar.activity().getApplication().unregisterActivityLifecycleCallbacks(this);
    }

    @Override
    public void onActivityCreated(Activity activity, Bundle savedInstanceState) {
        if (disposed || activity.hashCode() != registrar.activity().hashCode()) {
            return;
        }
        mapView.onCreate(savedInstanceState);
    }

    @Override
    public void onActivityStarted(Activity activity) {
        if (disposed || activity.hashCode() != registrar.activity().hashCode()) {
            return;
        }
    }

    @Override
    public void onActivityResumed(Activity activity) {
        if (disposed || activity.hashCode() != registrar.activity().hashCode()) {
            return;
        }
        mapView.onResume();
    }

    @Override
    public void onActivityPaused(Activity activity) {
        if (disposed || activity.hashCode() != registrar.activity().hashCode()) {
            return;
        }
        mapView.onPause();
    }

    @Override
    public void onActivityStopped(Activity activity) {
        if (disposed || activity.hashCode() != registrar.activity().hashCode()) {
            return;
        }
    }

    @Override
    public void onActivitySaveInstanceState(Activity activity, Bundle outState) {
        if (disposed || activity.hashCode() != registrar.activity().hashCode()) {
            return;
        }
        mapView.onSaveInstanceState(outState);
    }

    @Override
    public void onActivityDestroyed(Activity activity) {
        if (disposed || activity.hashCode() != registrar.activity().hashCode()) {
            return;
        }
        mapView.onDestroy();
    }

    private void initAnnotations() throws IOException {
        if (aMap == null) {
            aMap = mapView.getMap();
        }
        aMap.setOnInfoWindowClickListener(this);
        this.annotations.clear();
        this.positions.clear();
        for (AMapAnnotationModel coor :
                this.annotationOptions.annotationCoordinates) {
            MarkerOptions markerOption = new MarkerOptions()
                    .position(coor.coordinate.toLatLng())
                    .draggable(annotationOptions.draggable)
                    .title(coor.title)
                    .snippet(coor.subTitle);
            if (coor.annotationIcon != null) {
                markerOption.icon(PluginAssets.assetpath(coor.annotationIcon));
            } else {
                if (this.annotationOptions.annotationIcon != null) {
                    markerOption.icon(PluginAssets.assetpath(this.annotationOptions.annotationIcon));
                }
            }
            this.annotations.add(markerOption);
            this.positions.add(coor.coordinate.toLatLng());
        }
        aMap.addMarkers(this.annotations, true);
    }

    /*
     * OnInfoWindowClickListener
     * */
    @Override
    public void onInfoWindowClick(Marker marker) {
        Map<String, Integer> arg = new HashMap<>();
        int index = this.positions.indexOf(marker.getPosition());
//        if (index > 0) {
        arg.put("tapIndex", index);
        mapChannel.invokeMethod("annotation_tap", arg);
//        }
    }

    @Override
    public void onMapLoaded() {
        mapLoaded = true;
        addAnnotationsOnMap();
    }

    private void addAnnotationsOnMap() {
        if (addAnnotations && mapLoaded) {
            try {
                initAnnotations();
            } catch (IOException e) {
                e.printStackTrace();
            }
            addAnnotations = false;
        }
    }
}
