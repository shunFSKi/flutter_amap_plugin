package amap.com.example.flutter_amap_plugin;

import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.graphics.BitmapFactory;

import com.amap.api.maps.model.BitmapDescriptor;
import com.amap.api.maps.model.BitmapDescriptorFactory;

import java.io.IOException;

public class PluginAssets {
    private static AssetManager assetManager = FlutterAmapPlugin.registrar.context().getAssets();

    public static BitmapDescriptor defaultAssetPath(String asset) {
        return BitmapDescriptorFactory.fromAsset(FlutterAmapPlugin.registrar.lookupKeyForAsset(asset, "flutter_amap_plugin"));
    }

    public static BitmapDescriptor asserpath(String asset) throws IOException {
        AssetFileDescriptor assetFileDescriptor = PluginAssets.assetManager.openFd(FlutterAmapPlugin.registrar.lookupKeyForAsset(asset));
        return BitmapDescriptorFactory.fromBitmap(BitmapFactory.decodeStream(assetFileDescriptor.createInputStream()));
    }
}
