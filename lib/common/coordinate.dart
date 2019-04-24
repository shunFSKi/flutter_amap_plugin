import '../model/amap_base_model.dart';

class Coordinate extends AMapBaseModel {
  final double latitude;
  final double longitude;

  Coordinate(this.latitude, this.longitude);

  @override
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}