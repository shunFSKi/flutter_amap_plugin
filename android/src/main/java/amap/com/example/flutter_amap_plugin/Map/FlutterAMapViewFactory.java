package amap.com.example.flutter_amap_plugin.Map;

import android.content.Context;
import android.view.View;

import com.amap.api.maps.AMap;
import com.amap.api.maps.CameraUpdateFactory;
import com.amap.api.maps.TextureMapView;
import com.google.gson.Gson;

import java.util.concurrent.atomic.AtomicInteger;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;


public class FlutterAMapViewFactory extends PlatformViewFactory {

    private final AtomicInteger mActivityState;
    private final PluginRegistry.Registrar mPluginRegistrar;

    public FlutterAMapViewFactory(AtomicInteger state, PluginRegistry.Registrar registrar) {
        super(StandardMessageCodec.INSTANCE);
        mActivityState = state;
        mPluginRegistrar = registrar;
    }

    @Override
    public PlatformView create(Context context, int id, Object o) {
        Gson gson = new Gson();
        AMapMapModel model = new  AMapMapModel();
        if (o instanceof String) {
            model = gson.fromJson(o.toString(),AMapMapModel.class);
        }
        FlutterAMapView aMapView = new FlutterAMapView(context, mActivityState, mPluginRegistrar, id, model);
        aMapView.setup();
        return aMapView;
    }
}

