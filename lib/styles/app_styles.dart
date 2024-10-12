import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

part 'color_styles.dart';
part 'text_styles.dart';

/// Estils de l'aplicació
abstract final class AppStyles {
  /// Plantilla de colors
  static ColorStyles get color => _color;
  static late ColorStyles _color;

  /// Estils de textos
  static TextStyles get text => _text;
  static late TextStyles _text;

  /// Espai per afegir marge vertical
  static const space = SizedBox(height: 24);

  /// Inicialitza el tema de l'aplicació
  static ThemeData theme(BuildContext context) {
    final ThemeData defaultTheme = Theme.of(context);

    // Inicialitza els colors a partir del context
    _color = ColorStyles._(defaultTheme.colorScheme);

    // Inicialitza els textos a partir del context
    _text = TextStyles._(defaultTheme.textTheme);

    // Inicialitza el tema
    return ThemeData.from(
      useMaterial3: true,
      colorScheme: color.scheme,
      textTheme: text.theme,
    ).copyWith(
      // Altres temes dels widgets de l'aplicació
      appBarTheme: AppBarTheme(
        backgroundColor: color.scheme.primary,
        foregroundColor: color.scheme.onPrimary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: color.scheme.primary,
          foregroundColor: color.scheme.onPrimary,
          disabledBackgroundColor: color.gray,
          disabledForegroundColor: color.scheme.onInverseSurface,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: color.scheme.primary,
        selectedItemColor: color.scheme.onPrimary,
        selectedLabelStyle: text.bold,
        unselectedItemColor: color.scheme.inversePrimary,
        unselectedLabelStyle: text.normal,
        selectedIconTheme: const IconThemeData(size: 28),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: color.scheme.secondary,
      ),
      listTileTheme: ListTileThemeData(
        selectedColor: defaultTheme.colorScheme.primary,
      ),
      dividerTheme: DividerThemeData(color: color.scheme.outlineVariant),
    );
  }
}
