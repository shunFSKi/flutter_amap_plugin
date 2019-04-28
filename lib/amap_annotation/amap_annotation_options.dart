import '../model/amap_base_model.dart';
import '../common/coordinate.dart';
import 'package:flutter/material.dart';

class AMapAnnotationOptions extends AMapBaseModel {
  ///默认为YES,当为NO时view忽略触摸事件
  final bool enabled;

  ///是否高亮
  final bool highlighted;

  ///是否允许弹出callout
  final bool canShowCallout;

  ///是否支持拖动
  final bool draggable;

  /// 自定义的标记图标，默认大头针样式
  final String annotationIcon;

  /// 显示的标记坐标
  final List<AMapAnnotationModel> annotationCoordinates;

  AMapAnnotationOptions({
    this.enabled = true,
    this.highlighted = false,
    this.canShowCallout = true,
    this.draggable = true,
    this.annotationIcon,
    @required this.annotationCoordinates,
  });

  @override
  Map<String, dynamic> toJson() {
    var coordinates = [];
    for (var coordinate in annotationCoordinates) {
      coordinates.add(coordinate.toJson());
    }
    return {
      'enabled': enabled,
      'highlighted': highlighted,
      'canShowCallout': canShowCallout,
      'draggable': draggable,
      'annotationIcon': annotationIcon,
      'annotationCoordinates': coordinates,
    };
  }
}

class AMapAnnotationModel extends AMapBaseModel {
  /// 坐标
  final Coordinate coordinate;

  /// 标题
  final String title;

  /// 副标题
  final String subTitle;

  /// 自定义的标记图标，默认大头针样式
  final String annotationIcon;

  AMapAnnotationModel({
    @required this.coordinate,
    this.title,
    this.subTitle,
    this.annotationIcon,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'coordinate': coordinate.toJson(),
      'title': title,
      'subTitle': subTitle,
      'annotationIcon': annotationIcon,
    };
  }
}
