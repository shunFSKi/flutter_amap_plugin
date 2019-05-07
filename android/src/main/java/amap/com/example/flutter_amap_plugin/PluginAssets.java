package amap.com.example.flutter_amap_plugin;

import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.graphics.BitmapFactory;

import com.amap.api.maps.model.BitmapDescriptor;
import com.amap.api.maps.model.BitmapDescriptorFactory;

import java.io.IOException;

import static amap.com.example.flutter_amap_plugin.FlutterAmapPlugin.registrar;

public class PluginAssets {
    private static AssetManager assetManager = registrar.context().getAssets();

    public static BitmapDescriptor defaultAssetPath(String asset) {
        return BitmapDescriptorFactory.fromAsset(registrar.lookupKeyForAsset(asset, "flutter_amap_plugin"));
    }

    public static BitmapDescriptor assetpath(String asset) throws IOException {
        AssetFileDescriptor assetFileDescriptor = PluginAssets.assetManager.openFd(registrar.lookupKeyForAsset(asset));
        return BitmapDescriptorFactory.fromBitmap(BitmapFactory.decodeStream(assetFileDescriptor.createInputStream()));
    }
}
