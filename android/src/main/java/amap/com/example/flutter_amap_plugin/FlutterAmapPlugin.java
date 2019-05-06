package amap.com.example.flutter_amap_plugin;

import android.Manifest;
import android.app.Activity;
import android.app.Application;
import android.os.Bundle;

import com.mylhyl.acp.Acp;
import com.mylhyl.acp.AcpListener;
import com.mylhyl.acp.AcpOptions;

import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

import amap.com.example.flutter_amap_plugin.Map.FlutterAMapView;
import amap.com.example.flutter_amap_plugin.Map.FlutterAMapViewFactory;
import amap.com.example.flutter_amap_plugin.Nav.FlutterAMapNavFactory;
import amap.com.example.flutter_amap_plugin.Nav.FlutterAMapNavView;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterAmapPlugin */
public class FlutterAmapPlugin implements MethodCallHandler {
    /** Plugin registration. */

    public static final String MAP_BASE_CHANNEL = "plugin/base/init";
    public static Registrar registrar;
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

        final FlutterAmapPlugin plugin = new FlutterAmapPlugin(root);

        registrar.platformViewRegistry().registerViewFactory(FlutterAMapView.MAP_CHANNEL_NAME,
                new FlutterAMapViewFactory(plugin.state, registrar));
        registrar.platformViewRegistry().registerViewFactory(FlutterAMapNavView.Nav_CHANNEL_NAME,
                new FlutterAMapNavFactory(plugin.state, registrar));
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else if (call.method.equals("initKey")) {
            result.success("init");
        } else {
            result.notImplemented();
        }
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
