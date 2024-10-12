import 'dart:convert';

import 'data_model.dart';

/// Informació dels diferents països amb codis de l'estàndar ISO-3166
///
/// Per convertir desde JSON: `Iso3166.fromJsonString(jsonString)`
class Iso3166 extends JsonDataModel {
  final List<Country> countries;

  Iso3166({required this.countries});

  factory Iso3166.fromJsonString(String jsonString) =>
      Iso3166.fromJson(json.decode(jsonString));

  factory Iso3166.fromJson(Map<String, dynamic> json) {
    return Iso3166(
      countries: List<Country>.from(
        json['countries'].map((x) => Country.fromJson(x)),
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'countries': List<dynamic>.from(countries.map((x) => x.toJson())),
      };
}

/// País segons l'estàndar ISO-3166-1
class Country extends JsonDataModel {
  /// ISO-3166-1-alpha2, p.e. ES
  final String code;
  final String name;
  final String nameCa;
  final String flag;
  final List<Subdivision> subdivisions;

  Country({
    required this.name,
    String? nameCa,
    required this.code,
    required this.flag,
    required this.subdivisions,
  }) : nameCa = nameCa ?? name;

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'],
      nameCa: json['name_ca'],
      code: json['code'],
      flag: json['flag'],
      subdivisions: List<Subdivision>.from(
        json['subdivisions'].map((x) => Subdivision.fromJson(x)),
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'name_ca': nameCa,
        'code': code,
        'flag': flag,
        'subdivisions': List<dynamic>.from(subdivisions.map((x) => x.toJson())),
      };

  /// Obté una regió amb un id determinat, o
  /// null si no existeix
  Subdivision? getSubdivisionById(String id) {
    id = id.toUpperCase();
    try {
      return subdivisions.firstWhere(
        (subdivision) => subdivision.id == id,
      );
    } on StateError {
      return null;
    }
  }
}

/// Regió segons l'estàndar ISO-3166-2
class Subdivision extends JsonDataModel {
  /// ISO-3166-2, p.e. ES-CT
  final String code;

  /// p.e. CT
  final String id;
  final String name;
  final String nameCa;
  final String type;
  final List<Subdivision> subdivisions;

  Subdivision({
    required this.name,
    String? nameCa,
    required this.code,
    required this.id,
    required this.type,
    required this.subdivisions,
  }) : nameCa = nameCa ?? name;

  factory Subdivision.fromJson(Map<String, dynamic> json) {
    return Subdivision(
      name: json['name'],
      nameCa: json['name_ca'],
      code: json['code'],
      id: json['id'],
      type: json['type'],
      subdivisions: List<Subdivision>.from(
        json['subdivisions'].map((x) => Subdivision.fromJson(x)),
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'name_ca': nameCa,
        'code': code,
        'id': id,
        'type': type,
        'subdivisions': List<dynamic>.from(subdivisions.map((x) => x.toJson())),
      };
}
