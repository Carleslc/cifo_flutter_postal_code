import 'package:flutter/services.dart' show rootBundle;

import '../models/iso_country.dart';

/// Servei per obtenir els codis i noms dels països
class CountryService {
  static const String countriesFile = 'iso-3166-ca.json';

  /// Carrega tots els països desde l'arxiu [countriesFile] `iso-3166-ca.json`
  Future<List<Country>> getCountries() async {
    final response = await rootBundle.loadString('assets/$countriesFile');
    Iso3166 iso3166 = Iso3166.fromJsonString(response);
    return iso3166.countries;
  }
}
