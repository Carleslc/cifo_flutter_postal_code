import 'package:flutter/material.dart';

import '../models/iso_country.dart';
import '../models/postal_places.dart';
import '../services/zippopotam_service.dart';
import '../utils/error.dart';
import '../utils/logger.dart';
import '../widgets/places_list.dart';
import '../widgets/searching_indicator.dart';

/// Busca els llocs d'un país a partir del codi postal
class PlaceByCodeResults extends StatelessWidget {
  static final _postalCodeService = ZippopotamService();

  /// País del codi postal
  final Country country;

  /// Codi postal
  final String postCode;

  const PlaceByCodeResults({
    super.key,
    required this.postCode,
    required this.country,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${country.flag} Codi postal'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: FutureBuilder(
          future: _postalCodeService.fetchPlacesByCode(
            countryCode: country.code,
            postCode: postCode,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SearchingIndicator(label: 'Buscant codi postal...'),
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
              emptyMessage =
                  "No s'ha trobat cap localitat amb el codi postal $postCode"
                  ' a ${country.nameCa}';
            }

            String countryCode = places.country.isNotEmpty
                ? places.countryAbbreviation
                : country.code;

            log(
              'Country: ${places.country} (${countryCode}),'
              ' Places [$postCode]: ${places.places.length}',
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
