package amap.com.example.flutter_amap_plugin;

import com.amap.api.maps.model.BitmapDescriptor;
import com.amap.api.maps.model.BitmapDescriptorFactory;

public class PluginAssets {
    public static BitmapDescriptor defaultAssestPath(String asset) {
        return BitmapDescriptorFactory.fromAsset(FlutterAmapPlugin.registrar.lookupKeyForAsset(asset, "flutter_amap_plugin"));
    }
}
