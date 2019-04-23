import 'dart:convert';

class AMapBaseModel {
  const AMapBaseModel();

  Map<String, dynamic> toJson() {
    return {};
  }

  String toJsonString() => jsonEncode(toJson());
}
