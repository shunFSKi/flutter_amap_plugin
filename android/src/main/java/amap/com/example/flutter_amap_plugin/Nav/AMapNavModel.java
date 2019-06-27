package amap.com.example.flutter_amap_plugin.Nav;

public class AMapNavModel {
    ///导航界面跟随模式,默认AMapNaviViewTrackingModeMapNorth
    int trackingMode;

    ///是否显示界面元素,默认YES
    boolean showUIElements;

    ///是否显示路口放大图,默认YES
    boolean showCrossImage;

    ///是否显示实时交通按钮,默认YES
    boolean showTrafficButton;

    ///是否显示路况光柱,默认YES
    boolean showTrafficBar;

    ///是否显示全览按钮,默认YES
    boolean showBrowseRouteButton;

    ///是否显示更多按钮,默认YES
    boolean showMoreButton;

    ///是否使用导航组件,默认false
    boolean isUseComponent;
}
