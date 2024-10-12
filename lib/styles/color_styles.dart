part of 'app_styles.dart';

/// Defineix els colors de l'aplicació.
///
/// Exemple d'accés: `AppStyles.color.primary`
final class ColorStyles {
  //
  // Paleta de colors
  //

  // Genera: ColorScheme.fromSeed
  final Color seed = Colors.blueGrey;

  //
  // Altres colors
  //

  /// Color dels textos per defecte
  /// ColorScheme: onSurface
  late final Color textColor;

  /// Color dels títols
  final Color titleTextColor = Colors.black54;

  /// Color pels dividers i butons inactius
  final Color gray = Colors.grey;

  /// Esquema de colors del tema
  ///
  /// Spec: https://m3.material.io/styles/color/roles
  late final ColorScheme scheme;

  /// Inicialitza el tema de colors
  ColorStyles._(ColorScheme defaultScheme) {
    // Genera un tema a partir d'un color
    final generated = ColorScheme.fromSeed(seedColor: seed);

    scheme = generated.copyWith(
      outlineVariant: gray,
    );

    // Valors per defecte
    textColor = scheme.onSurface;
  }
}
