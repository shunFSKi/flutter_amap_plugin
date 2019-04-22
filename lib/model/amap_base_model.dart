import 'dart:convert';

class AMapBaseModel {
  
  Map<String, dynamic> toJson() {
    return {};
  }

  String toJsonString() => jsonEncode(toJson());
}
