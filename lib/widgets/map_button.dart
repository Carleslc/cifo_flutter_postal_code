import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/postal_places.dart';
import '../utils/error.dart';

/// Botó que obre una ubicació a Google Maps
class MapButton extends StatelessWidget {
  final String placeName;
  final double? latitude;
  final double? longitude;
  final String? label;

  MapButton({super.key, required Place place, this.label})
      : latitude = double.tryParse(place.latitude),
        longitude = double.tryParse(place.longitude),
        placeName = place.name;

  const MapButton.fromPlaceName(this.placeName, {super.key})
      : label = placeName,
        latitude = null,
        longitude = null;

  /// Nom del lloc o coordenades
  /// Si les coordenades estan incompletes es busca pel nom del lloc
  String get _mapsQuery {
    if (placeName.isNotEmpty) {
      return placeName;
    }
    if (latitude != null && longitude != null) {
      return '$latitude,$longitude';
    }
    return '';
  }

  /// URL de Google Maps per obrir la ubicació
  String get _mapsUrl => 'https://maps.google.com/maps?q=$_mapsQuery';

  /// Obre la ubicació a Google Maps
  void _launchMap(BuildContext context) {
    try {
      launchUrl(Uri.parse(_mapsUrl));
    } on Exception catch (e) {
      showErrorMessage(context, "No s'ha pogut obrir el mapa", e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_mapsQuery.isEmpty) {
      return const SizedBox.shrink();
    }
    Widget child;
    Icon icon = const Icon(Icons.map);
    onPressed() => _launchMap(context);

    // Mostra IconButton o FilledButton si té label
    if (label == null) {
      child = IconButton.filledTonal(
        icon: icon,
        onPressed: onPressed,
      );
    } else {
      child = FilledButton.tonalIcon(
        icon: icon,
        label: Text(label!),
        onPressed: onPressed,
      );
    }

    // Coordenades o nom del lloc
    String tooltip = latitude != null || longitude != null
        ? "${latitude ?? '?'}, ${longitude ?? '?'}"
        : placeName;

    return Tooltip(
      message: tooltip,
      showDuration: const Duration(seconds: 3),
      child: child,
    );
  }
}
