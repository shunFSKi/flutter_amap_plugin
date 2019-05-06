package amap.com.example.flutter_amap_plugin.Nav;

import android.content.Context;

import com.google.gson.Gson;

import java.util.concurrent.atomic.AtomicInteger;

import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class FlutterAMapNavFactory extends PlatformViewFactory {

    private final AtomicInteger mActivityState;
    private final PluginRegistry.Registrar mPluginRegistrar;


    public FlutterAMapNavFactory(AtomicInteger state, PluginRegistry.Registrar registrar) {
        super(StandardMessageCodec.INSTANCE);
        mActivityState = state;
        mPluginRegistrar = registrar;
    }

    @Override
    public PlatformView create(Context context, int id, Object o) {
        Gson gson = new Gson();
        AMapNavModel model = new AMapNavModel();
        if (o instanceof String) {
            model = gson.fromJson(o.toString(), AMapNavModel.class);
        }
        FlutterAMapNavView aMapNavView = new FlutterAMapNavView(context, mActivityState, mPluginRegistrar, id, mPluginRegistrar.activity(), model);
        aMapNavView.setup();
        return aMapNavView;
    }
}

