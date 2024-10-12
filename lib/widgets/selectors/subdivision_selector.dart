import 'package:flutter/material.dart';

import '../../models/iso_country.dart';
import 'selector.dart';

/// Selector de regió
class SubdivisionSelector extends StatelessWidget {
  final String label;
  final Subdivision? initialSubdivision;
  final List<Subdivision> availableSubdivisions;
  final ValueChanged<Subdivision?> onSelected;
  final double? menuHeight;
  final double? width;

  const SubdivisionSelector({
    super.key,
    this.initialSubdivision,
    required this.availableSubdivisions,
    required this.onSelected,
    required this.label,
    this.menuHeight,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<Subdivision>(
      label: label,
      leadingIcon: const Icon(Icons.holiday_village),
      initialSelection: initialSubdivision,
      availableItems: availableSubdivisions,
      entry: (subdivision) => DropdownMenuEntry<Subdivision>(
        value: subdivision,
        label: subdivision.nameCa,
        trailingIcon: Text(subdivision.id),
      ),
      onSelected: onSelected,
      menuHeight: menuHeight,
      width: width,
    );
  }
}
