import 'dart:convert';

import 'data_model.dart';

/// Llocs d'un país amb informació postal
class PostalPlaces extends JsonDataModel {
  final String country;
  final String countryAbbreviation;
  final List<Place> places;

  PostalPlaces({
    required this.country,
    required this.countryAbbreviation,
    required this.places,
  });

  /// Constructor sense llocs
  PostalPlaces.empty({
    this.country = '',
    this.countryAbbreviation = '',
  }) : places = List<Place>.empty();

  factory PostalPlaces.fromJson(Map<String, dynamic> json) {
    return PostalPlaces(
      country: json['country'],
      countryAbbreviation: json['country abbreviation'],
      places: List<Place>.from(
        json['places'].map((x) => Place.fromJson(x)),
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'country': country,
        'country abbreviation': countryAbbreviation,
        'places': List<dynamic>.from(places.map((x) => x.toJson())),
      };
}

/// Llocs d'un país amb informació postal a partir del codi postal
///
/// Per convertir desde JSON: `PostalPlacesByCode.fromJsonString(jsonString)`
class PostalPlacesByCode extends PostalPlaces {
  final String postCode;

  PostalPlacesByCode({
    required this.postCode,
    required super.country,
    required super.countryAbbreviation,
    required List<PlaceByCode> super.places,
  });

  factory PostalPlacesByCode.fromJsonString(String jsonString) =>
      PostalPlacesByCode.fromJson(json.decode(jsonString));

  factory PostalPlacesByCode.fromJson(Map<String, dynamic> json) {
    return PostalPlacesByCode(
      postCode: json['post code'],
      country: json['country'],
      countryAbbreviation: json['country abbreviation'],
      places: List<PlaceByCode>.from(
        json['places'].map((x) => PlaceByCode.fromJson(x)),
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'post code': postCode,
        'country': country,
        'country abbreviation': countryAbbreviation,
        'places': List<dynamic>.from(places.map((x) => x.toJson())),
      };
}

/// Llocs d'un país amb informació postal a partir del nom de la ciutat
///
/// Per convertir desde JSON: `PostalPlacesByName.fromJsonString(jsonString)`
class PostalPlacesByName extends PostalPlaces {
  final String placeName;
  final String state;
  final String stateAbbreviation;

  PostalPlacesByName({
    required super.country,
    required super.countryAbbreviation,
    required this.placeName,
    required this.state,
    required this.stateAbbreviation,
    required List<PlaceByName> super.places,
  });

  factory PostalPlacesByName.fromJsonString(String jsonString) =>
      PostalPlacesByName.fromJson(json.decode(jsonString));

  factory PostalPlacesByName.fromJson(Map<String, dynamic> json) {
    return PostalPlacesByName(
      country: json['country'],
      countryAbbreviation: json['country abbreviation'],
      placeName: json['place name'],
      state: json['state'],
      stateAbbreviation: json['state abbreviation'],
      places: List<PlaceByName>.from(
        json['places'].map((x) => PlaceByName.fromJson(x)),
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'country': country,
        'country abbreviation': countryAbbreviation,
        'place name': placeName,
        'state': state,
        'state abbreviation': stateAbbreviation,
        'places': List<dynamic>.from(places.map((x) => x.toJson()).toList()),
      };
}

/// Informació d'un lloc
class Place extends JsonDataModel {
  final String name;
  final String latitude;
  final String longitude;

  Place({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory Place.fromJson(Map<String, dynamic> json) => Place(
        name: json['place name'],
        latitude: json['latitude'],
        longitude: json['longitude'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'place name': name,
        'latitude': latitude,
        'longitude': longitude,
      };
}

/// Informació postal d'un lloc a partir del codi postal
class PlaceByCode extends Place {
  final String state;
  final String stateAbbreviation;

  PlaceByCode({
    required super.name,
    required super.latitude,
    required super.longitude,
    required this.state,
    required this.stateAbbreviation,
  });

  factory PlaceByCode.fromJson(Map<String, dynamic> json) => PlaceByCode(
        name: json['place name'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        state: json['state'],
        stateAbbreviation: json['state abbreviation'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'place name': name,
        'latitude': latitude,
        'longitude': longitude,
        'state': state,
        'state abbreviation': stateAbbreviation,
      };
}

/// Informació postal d'un lloc a partir del nom
class PlaceByName extends Place {
  final String postCode;

  PlaceByName({
    required super.name,
    required super.latitude,
    required super.longitude,
    required this.postCode,
  });

  factory PlaceByName.fromJson(Map<String, dynamic> json) => PlaceByName(
        name: json['place name'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        postCode: json['post code'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'place name': name,
        'latitude': latitude,
        'longitude': longitude,
        'post code': postCode,
      };
}
