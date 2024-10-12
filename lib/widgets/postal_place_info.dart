import 'package:flutter/material.dart';

import '../models/iso_country.dart';
import '../models/postal_places.dart';
import '../services/zippopotam_service.dart';
import '../styles/app_styles.dart';
import '../utils/strings.dart';
import 'map_button.dart';
import 'text_label_value.dart';

/// Mostra la informació que compareteixen les localitats (país, regió, codi postal)
class PostalPlaceInfo extends StatefulWidget {
  final PostalPlaces postalPlaces;

  PostalPlaceInfo({super.key, required this.postalPlaces});

  @override
  State<PostalPlaceInfo> createState() => _PostalPlaceInfoState();
}

class _PostalPlaceInfoState extends State<PostalPlaceInfo> {
  static final _postalCodeService = ZippopotamService();

  late String countryName;
  late String stateName;

  @override
  void initState() {
    super.initState();
    _setCountryStateName(widget.postalPlaces);
  }

  /// Inicialitza el nom del país i la regió dels llocs
  void _setCountryStateName(final PostalPlaces place) {
    super.initState();

    countryName = place.country;

    Country? country =
        _postalCodeService.getCountryByCode(place.countryAbbreviation);

    if (country != null) {
      // Aplica la traducció del nom del país
      countryName = country.nameCa;

      if (place is PostalPlacesByName) {
        Subdivision? subdivision =
            country.getSubdivisionById(place.stateAbbreviation);

        if (subdivision != null) {
          // Aplica la traducció de la regió
          stateName = subdivision.nameCa;
        } else {
          stateName = place.state;
        }
      }
    }
  }

  /// Nom del país que correspon als llocs a mostrar\
  /// amb el seu codi ISO-3166-1-alpha2
  String get _countryLabel => joinAbbreviation(
        countryName,
        widget.postalPlaces.countryAbbreviation,
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // País
        if (_countryLabel.isNotEmpty)
          TextLabelValue(
            label: 'País',
            value: _countryLabel,
            valueStyle: AppStyles.text.bold,
          ),
        const Divider(height: 20),
        // Altres atributs
        _buildChildSection(widget.postalPlaces),
      ],
    );
  }

  /// Atributs específics de la cerca (ByCode: postCode, ByName: placeName, state)
  Widget _buildChildSection(PostalPlaces postalPlaces) {
    if (postalPlaces is PostalPlacesByCode) {
      return TextLabelValue(
        label: 'Codi postal',
        value: postalPlaces.postCode,
        labelStyle: AppStyles.text.big,
        valueStyle: AppStyles.text.bold,
      );
    } else if (postalPlaces is PostalPlacesByName) {
      // Nom de la regió que correspon als llocs a mostrar amb el seu codi ISO-3166-2
      var subdivisionLabel = joinAbbreviation(
        stateName,
        postalPlaces.stateAbbreviation,
      );
      return Column(
        children: [
          TextLabelValue(
            label: 'Regió',
            value: subdivisionLabel,
            valueStyle: AppStyles.text.italic,
          ),
          // Lloc principal resultant de la cerca
          if (postalPlaces.placeName.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              // Botó que obre la ubicació a Google Maps
              child: MapButton.fromPlaceName(postalPlaces.placeName),
            ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}
