import 'package:flutter/material.dart';

import '../models/iso_country.dart';
import '../models/postal_places.dart';
import '../services/zippopotam_service.dart';
import '../styles/app_styles.dart';
import '../utils/strings.dart';
import 'map_button.dart';

/// Mostra informació d'una localitat
class PlaceInfo extends StatefulWidget {
  final Place place;
  final String countryCode;

  const PlaceInfo({super.key, required this.place, required this.countryCode});

  @override
  State<PlaceInfo> createState() => _PlaceInfoState();
}

class _PlaceInfoState extends State<PlaceInfo> {
  static final _postalCodeService = ZippopotamService();

  late String stateName;

  @override
  void initState() {
    super.initState();
    _setStateName(widget.place);
  }

  /// Inicialitza el nom de la regió del lloc
  void _setStateName(final Place place) {
    if (place is PlaceByCode) {
      stateName = place.state;

      Country? country =
          _postalCodeService.getCountryByCode(widget.countryCode);

      if (country != null) {
        Subdivision? subdivision =
            country.getSubdivisionById(place.stateAbbreviation);

        // Aplica la traducció de la regió
        if (subdivision != null) {
          stateName = subdivision.nameCa;
        }
      }
    } else {
      stateName = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget? subtitle;

    // Variable local per que el compilador faci el cast
    final Place place = widget.place;

    if (place is PlaceByName) {
      subtitle = SelectableText(place.postCode, style: AppStyles.text.medium);
    } else if (place is PlaceByCode) {
      subtitle = Text(joinAbbreviation(stateName, place.stateAbbreviation));
    }

    return ListTile(
      title: SelectableText(place.name, style: AppStyles.text.bold),
      subtitle: subtitle,
      trailing: SizedBox(
        width: 64,
        child:
            MapButton(place: place), // botó per obrir la ubicació a Google Maps
      ),
      contentPadding: const EdgeInsets.only(left: 12, right: 4),
    );
  }
}
