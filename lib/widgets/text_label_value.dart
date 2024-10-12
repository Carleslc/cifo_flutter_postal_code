import 'package:flutter/material.dart';

import '../styles/app_styles.dart';

/// Mostra un label i un valor en diferents estils
class TextLabelValue extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  const TextLabelValue({
    super.key,
    required this.label,
    required this.value,
    this.textStyle,
    this.labelStyle,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: labelStyle,
          ),
          TextSpan(text: value, style: valueStyle),
        ],
      ),
      style: textStyle ?? AppStyles.text.big,
    );
  }
}
