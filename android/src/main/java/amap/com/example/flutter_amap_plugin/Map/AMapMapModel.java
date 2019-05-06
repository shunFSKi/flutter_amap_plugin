package amap.com.example.flutter_amap_plugin.Map;

public class AMapMapModel {
    /// 地图类型
    int mapType;

    /// 当前地图的中心点坐标
    Coordinate centerCoordinate;

    ///缩放级别（默认3-19，有室内地图时为3-20）
    float zoomLevel;

    ///最小缩放级别
    float minZoomLevel;

    ///最大缩放级别（有室内地图时最大为20，否则为19）
    float maxZoomLevel;

    ///设置地图旋转角度(逆时针为正向)
    float rotationDegree;

    ///设置地图相机角度(范围为[0.f, 60.f]，但高于40度的角度需要在16级以上才能生效)
    float cameraDegree;

    ///是否以screenAnchor点作为锚点进行缩放，默认为YES。如果为NO，则以手势中心点作为锚点
    boolean zoomingInPivotsAroundAnchorPoint;

    ///是否支持缩放, 默认YES
    boolean zoomEnabled;

    ///是否支持平移, 默认YES
    boolean scrollEnabled;

    ///是否支持旋转, 默认YES
    boolean rotateEnabled;

    ///是否支持camera旋转, 默认YES
    boolean rotateCameraEnabled;

    ///是否显示比例尺, 默认YES
    boolean showsScale;

    ///是否显示用户位置
    boolean showsUserLocation;

    ///是否显示指南针, 默认YES
    boolean showsCompass;

    ///是否显示交通路况图层, 默认为NO
    boolean showTraffic;

    ///定位用户位置的模式, 注意：在follow模式下，设置地图中心点、设置可见区域、滑动手势、选择annotation操作会取消follow模式
    int userTrackingMode;
}


