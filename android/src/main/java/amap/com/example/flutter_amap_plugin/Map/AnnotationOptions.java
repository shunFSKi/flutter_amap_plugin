package amap.com.example.flutter_amap_plugin.Map;

import java.util.List;

public class AnnotationOptions {
    ///默认为YES,当为NO时view忽略触摸事件
    boolean enabled;

    ///是否高亮
    boolean highlighted;

    ///设置是否处于选中状态, 外部如果要选中请使用mapView的selectAnnotation方法
    boolean selected;

    ///是否允许弹出callout
    boolean canShowCallout;

    ///是否支持拖动
    boolean draggable;

    /// 坐标集合
    List<AMapAnnotationModel> annotationCoordinates;

    String annotationIcon;
}

