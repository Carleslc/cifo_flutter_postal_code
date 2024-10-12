import 'package:flutter/material.dart';

import '../models/postal_places.dart';
import '../styles/app_styles.dart';
import 'place_info.dart';
import 'postal_place_info.dart';

/// Llista de llocs d'un país
class PlacesList extends StatelessWidget {
  /// Llocs a mostrar
  final PostalPlaces postalPlaces;

  /// Text per mostrar quan no hi ha cap lloc per mostrar
  final String? emptyText;

  /// Codi del país
  final String countryCode;

  const PlacesList({
    super.key,
    required this.postalPlaces,
    this.emptyText,
    required this.countryCode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Capçalera amb informació compartida per tots els llocs
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: PostalPlaceInfo(postalPlaces: postalPlaces),
        ),
        // Llista de llocs individuals
        _buildPlaces(),
      ],
    );
  }

  /// Llista de llocs amb la seva informació
  Widget _buildPlaces() {
    if (postalPlaces.places.isEmpty) {
      // No s'han trobat llocs
      if (emptyText != null) {
        return Text(
          emptyText!,
          style: AppStyles.text.medium.merge(AppStyles.text.bold),
        );
      }
      return const SizedBox.shrink();
    }
    return Expanded(
      child: ListView(
        children: postalPlaces.places
            .map((place) => PlaceInfo(place: place, countryCode: countryCode))
            .toList(),
      ),
    );
  }
}
