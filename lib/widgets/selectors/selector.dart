import 'package:flutter/material.dart';

/// Selector d'elements genèric
class Selector<T> extends StatelessWidget {
  final String label;
  final T? initialSelection;
  final List<T> availableItems;
  final ValueChanged<T?> onSelected;
  final DropdownMenuEntry<T> Function(T item) entry;
  final Widget? leadingIcon;
  final double? width;
  final double? menuHeight;

  const Selector({
    super.key,
    required this.label,
    this.initialSelection,
    required this.availableItems,
    required this.entry,
    required this.onSelected,
    this.leadingIcon,
    this.width,
    this.menuHeight,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<T>(
      helperText: label,
      initialSelection: initialSelection,
      onSelected: onSelected,
      // Opcions
      dropdownMenuEntries: availableItems.map(entry).toList(),
      // Icona del selector
      leadingIcon: this.leadingIcon,
      // Altres paràmetres
      menuHeight: this.menuHeight,
      width: this.width,
    );
  }
}
