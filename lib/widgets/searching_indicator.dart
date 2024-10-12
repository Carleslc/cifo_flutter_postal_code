import 'package:flutter/material.dart';

import '../styles/app_styles.dart';

/// Indicador de progrés circular amb un missatge a sota
class SearchingIndicator extends StatelessWidget {
  final String label;

  const SearchingIndicator({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
        Text(
          label,
          style: AppStyles.text.normal.copyWith(
            color: AppStyles.color.scheme.secondary,
          ),
        ),
      ],
    );
  }
}
