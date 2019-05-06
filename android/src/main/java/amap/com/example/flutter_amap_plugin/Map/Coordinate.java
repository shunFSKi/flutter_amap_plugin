package amap.com.example.flutter_amap_plugin.Map;


import com.amap.api.maps.model.CameraPosition;
import com.amap.api.maps.model.LatLng;

public class Coordinate {
    public float latitude;
    public float longitude;

    CameraPosition toCameraPosition() {
        return new CameraPosition(new LatLng(latitude,longitude), 10, 0, 0);
    }

    LatLng toLatLng() {
        return new LatLng(latitude, longitude);
    }
}
