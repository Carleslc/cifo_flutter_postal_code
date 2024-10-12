import 'package:flutter/material.dart';

import '../models/iso_country.dart';
import '../services/zippopotam_service.dart';

/// Provider per la selecció de país i regió
class CountryProvider extends ChangeNotifier {
  static final _postalCodeService = ZippopotamService();

  static const String defaultCountryCode = 'ES'; // Espanya
  static const String defaultSubdivisionId = 'CT'; // Catalunya

  /// País seleccionat
  late Country country;

  /// Regió seleccionada
  late Subdivision? subdivision;

  CountryProvider() {
    /// Inicialitza el país i regió per defecte
    setCountry(_postalCodeService.getCountryByCode(defaultCountryCode)!);
    setSubdivision(country.getSubdivisionById(defaultSubdivisionId)!);
  }

  /// Llista de països suportats
  List<Country> get supportedCountries => _postalCodeService.supportedCountries;

  /// Canvia el país
  void setCountry(Country country) {
    this.country = country;
    // Ordena les regions del país per nom
    country.subdivisions.sort(
      (sub1, sub2) => sub1.nameCa.compareTo(sub2.nameCa),
    );
    // Selecciona la primera regió
    subdivision = country.subdivisions.firstOrNull;
    notifyListeners();
  }

  /// Canvia la regió
  void setSubdivision(Subdivision? subdivision) {
    this.subdivision = subdivision;
    notifyListeners();
  }
}
