import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/iso_country.dart';
import '../models/postal_places.dart';
import '../utils/logger.dart';
import 'country_service.dart';

/// Servei per obtenir informació postal d'un lloc en un país
class ZippopotamService {
  static final _apiUrl = Uri.https('api.zippopotam.us');

  // Singleton per carregar els països només una vegada
  static final _instance = ZippopotamService._();
  factory ZippopotamService() => _instance;
  ZippopotamService._();

  /// Obté el lloc amb codi postal [postCode] dins del país definit per [countryCode]
  Future<PostalPlacesByCode?> fetchPlacesByCode({
    required final String countryCode, // ISO-3166-1-alpha2
    required final String postCode,
  }) async {
    assert(isSupportedCountryCode(countryCode));

    // api.zippopotam.us/country/postal-code
    final url = _apiUrl.replace(pathSegments: [
      countryCode.toLowerCase(),
      postCode,
    ]);

    final places = await _request(
      url,
      fromJson: PostalPlacesByCode.fromJson,
    );

    return places;
  }

  /// Obté els llocs que contenen el nom [search] dins del país\
  /// definit per [countryCode] i la regió definida per [subdivisionId]
  Future<PostalPlacesByName?> fetchPlacesByName({
    required final String countryCode, // ISO-3166-1-alpha2
    required final String subdivisionId,
    required final String search,
  }) async {
    assert(isSupportedCountryCode(countryCode));

    // api.zippopotam.us/country/state/city
    final url = _apiUrl.replace(pathSegments: [
      countryCode.toLowerCase(),
      subdivisionId.toLowerCase(),
      search,
    ]);

    final places = await _request(
      url,
      fromJson: PostalPlacesByName.fromJson,
    );

    return places;
  }

  /// Fa una petició GET a la API amb ruta [url] i converteix la resposta\
  /// utilitzant el mètode [fromJson]. Si la resposta es `{}` retorna null
  Future<P?> _request<P extends PostalPlaces>(
    final Uri url, {
    required P Function(Map<String, dynamic> json) fromJson,
  }) async {
    log(url.toString());

    http.Response data = await http.get(url);

    final Map<String, dynamic> json = jsonDecode(data.body);

    return json.isEmpty ? null : fromJson(json);
  }

  /// Servei dels països
  static final _countryService = CountryService();

  /// Llista de països suportats per la API de Zippopotam
  /// https://api.zippopotam.us/#where
  List<Country>? _supportedCountries;

  /// Carrega els països suportats per la API de Zippopotam
  Future<List<Country>> loadSupportedCountries() async {
    if (_supportedCountries == null) {
      final List<Country> countries = await _countryService.getCountries();

      _supportedCountries = countries
          .where((country) => isSupportedCountryCode(country.code))
          .toList()
        ..sort(
          // Ordena els països per nom
          (country1, country2) => country1.nameCa.compareTo(country2.nameCa),
        );
    }
    return _supportedCountries!;
  }

  /// Llista de països suportats per la API de Zippopotam
  List<Country> get supportedCountries {
    if (_supportedCountries == null) {
      throw StateError(
        'Countries are not loaded. Call ZippopotamService().loadSupportedCountries()',
      );
    }
    return _supportedCountries!;
  }

  /// Comprova si la API accepta un país determinat per [countryCode]
  bool isSupportedCountryCode(String countryCode) {
    return _supportedCountryCodes.contains(countryCode.toUpperCase());
  }

  /// Obté el país amb el codi ISO-3166-1-alpha2 [countryCode], o
  /// null si no està suportat
  Country? getCountryByCode(String countryCode) {
    countryCode = countryCode.toUpperCase();
    if (!isSupportedCountryCode(countryCode)) {
      return null;
    }
    return supportedCountries.firstWhere(
      (country) => country.code == countryCode,
    );
  }

  /// Comprova si els codis postals d'un país son numèrics
  bool isNumericPostalCodeCountry(String countryCode) =>
      !_alphaCountries.contains(countryCode.toUpperCase());

  /// Països amb codis postals alfanumèrics que tenen caràcters que no son dígits
  static const Set<String> _alphaCountries = {
    'AD',
    'BR',
    'CA',
    'GB',
    'GG',
    'IM',
    'JE',
    'LK',
    'LU',
    'MD',
    'PL',
    'PT',
    'SK'
  };

  /// Països suportats per la API de Zippopotam (ISO-3166-1-alpha2)
  static const Set<String> _supportedCountryCodes = {
    'AD',
    'AR',
    'AS',
    'AT',
    'AU',
    'BD',
    'BE',
    'BG',
    'BR',
    'CA',
    'CH',
    'CZ',
    'DE',
    'DK',
    'DO',
    'ES',
    'FI',
    'FO',
    'FR',
    'GB',
    'GF',
    'GG',
    'GL',
    'GP',
    'GT',
    'GU',
    'GY',
    'HR',
    'HU',
    'IM',
    'IN',
    'IS',
    'IT',
    'JE',
    'JP',
    'LI',
    'LK',
    'LT',
    'LU',
    'MC',
    'MD',
    'MH',
    'MK',
    'MP',
    'MQ',
    'MX',
    'MY',
    'NL',
    'NO',
    'NZ',
    'PH',
    'PK',
    'PL',
    'PM',
    'PR',
    'PT',
    'RE',
    'RU',
    'SE',
    'SI',
    'SJ',
    'SK',
    'SM',
    'TH',
    'TR',
    'US',
    'VA',
    'VI',
    'YT',
    'ZA'
  };
}
