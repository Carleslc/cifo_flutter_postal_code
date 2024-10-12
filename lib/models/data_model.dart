import 'dart:convert';

/// Models per definir els paràmetres dels diferents endpoints
abstract class JsonDataModel {
  Map<String, dynamic> toJson();

  String toJsonString() => json.encode(toJson());
}
