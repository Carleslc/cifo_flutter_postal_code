import 'package:flutter/material.dart';

import '../models/iso_country.dart';
import '../models/postal_places.dart';
import '../services/zippopotam_service.dart';
import '../utils/error.dart';
import '../utils/logger.dart';
import '../widgets/places_list.dart';
import '../widgets/searching_indicator.dart';

/// Busca els llocs d'un país a partir d'un nom
class PlacesByNameResults extends StatelessWidget {
  static final _postalCodeService = ZippopotamService();

  /// País dels llocs
  final Country country;

  /// Regió dels llocs
  final Subdivision? subdivision;

  /// Nom a cercar
  final String name;

  const PlacesByNameResults({
    super.key,
    required this.name,
    required this.country,
    required this.subdivision,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${subdivision?.code ?? ''} ${country.flag} $name"),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: FutureBuilder(
          future: _postalCodeService.fetchPlacesByName(
            countryCode: country.code,
            subdivisionId: subdivision?.id ?? '',
            search: name,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SearchingIndicator(label: 'Buscant localització...'),
              );
            }

            PostalPlaces places;
            String? emptyMessage;

            if (snapshot.hasError) {
              showErrorMessage(context, 'Error al buscar', snapshot.error);
              emptyMessage = 'Error trobant llocs';
            }

            if (snapshot.hasData) {
              places = snapshot.data!;
            } else {
              places = PostalPlaces.empty();
              emptyMessage = "No s'ha trobat cap localitat amb el nom $name"
                  " a ${subdivision?.nameCa ?? ''} (${country.nameCa})";
            }

            String countryCode = places.country.isNotEmpty
                ? places.countryAbbreviation
                : country.code;

            log(
              'Country: ${places.country} (${countryCode}),'
              ' Places [$name]: ${places.places.length}',
            );

            return PlacesList(
              postalPlaces: places,
              emptyText: emptyMessage,
              countryCode: countryCode,
            );
          },
        ),
      ),
    );
  }
}
