part of 'app_styles.dart';

/// Defineix els estils dels textos de l'aplicació.
///
/// Exemple d'accés: `AppStyles.text.title`
final class TextStyles {
  /// Font dels textos
  static const font = GoogleFonts.montserrat;
  static const fontTheme = GoogleFonts.montserratTextTheme;
  static final fontFamily = font().fontFamily;

  /// Títols
  final title = textStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppStyles.color.titleTextColor,
  );

  /// Textos de mida gran
  final big = textStyle(fontSize: 18);

  /// Textos de mida mitjana
  final medium = textStyle(fontSize: 16);

  /// Textos de mida normal
  final normal = textStyle(fontSize: 14);

  /// Textos de mida petita
  final small = textStyle(fontSize: 12);

  /// Text en negreta utilitzant la variant de font en negreta
  final bold = textStyle(fontWeight: FontWeight.bold);

  /// Text en cursiva utilitzant la variant de font en negreta
  final italic = textStyle(fontStyle: FontStyle.italic);

  /// Tema dels textos
  ///
  // Spec: https://m3.material.io/styles/typography/type-scale-tokens
  late final TextTheme theme;

  /// Inicialitza el tema dels textos
  TextStyles._(TextTheme defaultTheme) {
    theme = fontTheme(
      defaultTheme.merge(TextTheme(
        bodyLarge: medium,
        bodyMedium: normal,
        bodySmall: small,
        // ...
      )),
    );
  }

  /// Crea un TextStyle amb la font de l'aplicació aplicada.\
  /// Si `applyFontVariant` és true llavors s'aplica la font amb la variant
  /// corresponent, si és false només s'aplica la fontFamily genèrica
  static TextStyle textStyle({
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    Color? color,
    bool applyFontVariant = true,
  }) {
    final textStyle = TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontFamily: fontFamily,
      color: color ?? AppStyles.color.textColor,
    );
    return applyFontVariant ? textStyle.withAppFont : textStyle;
  }
}

extension TextStyleExtensions on TextStyle {
  /// Aplica la font de l'aplicació amb la variant corresponent\
  /// p.e. Montserrat_bold o Montserrat_700
  TextStyle get withAppFont => TextStyles.font(textStyle: this);

  /// Hereda les propietats per defecte
  TextStyle withDefaults(TextStyle? defaults) => defaults?.merge(this) ?? this;
}
