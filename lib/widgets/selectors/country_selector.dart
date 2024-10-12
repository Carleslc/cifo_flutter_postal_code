import 'package:flutter/material.dart';

import '../../models/iso_country.dart';
import 'selector.dart';

/// Selector de país
class CountrySelector extends StatelessWidget {
  final String label;
  final Country? initialCountry;
  final List<Country> availableCountries;
  final ValueChanged<Country> onSelected;
  final double? menuHeight;
  final double? width;

  const CountrySelector({
    super.key,
    this.initialCountry,
    required this.availableCountries,
    required this.onSelected,
    required this.label,
    this.menuHeight,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<Country>(
      label: label,
      initialSelection: initialCountry,
      availableItems: availableCountries,
      entry: (Country country) => DropdownMenuEntry<Country>(
        value: country,
        label: country.nameCa,
        leadingIcon: Text(country.flag),
        trailingIcon: Text(country.code),
      ),
      onSelected: (Country? country) {
        if (country != null) {
          onSelected(country);
        }
      },
      leadingIcon: const Icon(Icons.public),
      menuHeight: menuHeight,
      width: width,
    );
  }
}
