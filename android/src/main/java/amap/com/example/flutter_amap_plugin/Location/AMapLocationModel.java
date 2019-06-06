package amap.com.example.flutter_amap_plugin.Location;

/**
 * Created by fengshun
 * Create Date 2019-06-06 17:02
 * amap.com.example.flutter_amap_plugin.Location
 */
public class AMapLocationModel {


    /**
     * 定位模式，目前支持三种定位模式
     * 高精度定位模式：
     *
     * 在这种定位模式下，将同时使用高德网络定位和卫星定位,优先返回精度高的定位
     * 低功耗定位模式：
     *
     * 在这种模式下，将只使用高德网络定位
     * 仅设备定位模式：
     *
     * 在这种模式下，将只使用卫星定位。
     */
    int locationModel;

    ///指定单次定位超时时间,默认为10s。最小值是2s。注意单次定位请求前设置。注意: 单次定位超时时间从确定了定位权限(非AuthorizationStatusNotDetermined状态)后开始计算。
    int locationTimeout;

    // 逆地址语言类型，默认是AMapLocationRegionLanguageAuto
    int reGeocodeLanguage;

    // 是否是逆地址单次定位
    Boolean isReGeocode;
}
