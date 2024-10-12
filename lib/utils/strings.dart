/// Afegeix una abreviació [abbreviation] (p.e. ES) a un string [s] (p.e. Spain)\
/// Exemple: Spain (ES)
String joinAbbreviation(String s, String abbreviation) {
  if (abbreviation.isNotEmpty) {
    s += ' (${abbreviation.toUpperCase()})';
  }
  return s.trim();
}
