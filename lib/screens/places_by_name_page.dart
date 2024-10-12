import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/country_provider.dart';
import '../styles/app_styles.dart';
import '../widgets/selectors/country_selector.dart';
import '../widgets/selectors/subdivision_selector.dart';
import '../widgets/text_fields/place_name_text_field.dart';
import 'places_by_name_results.dart';

/// Pantalla per buscar llocs d'un país i regió a partir d'un nom
class PlacesByNamePage extends StatefulWidget {
  static const String title = 'Buscar per nom';

  const PlacesByNamePage({super.key});

  @override
  State<PlacesByNamePage> createState() => _PlacesByNamePageState();
}

class _PlacesByNamePageState extends State<PlacesByNamePage> {
  /// Nom per cercar
  String _name = '';
  bool _validName = false;

  /// Amplada del selector
  late double _selectorWidth;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Expandeix horitzontalment ajustat per padding
    _selectorWidth = MediaQuery.of(context).size.width - 48;
  }

  /// Navega a la pàgina de búsqueda i resultats
  void _searchResults(BuildContext context, String name) {
    // Obté el país i la regió del provider
    final provider = context.read<CountryProvider>();

    // Busca localitats per nom
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlacesByNameResults(
          name: name,
          country: provider.country,
          subdivision: provider.subdivision,
        ),
      ),
    );
  }

  /// Text del botó per buscar localitats a partir del nom
  String get _searchButtonText {
    const String searchText = 'Buscar localitats';
    return _validName ? '$searchText ($_name)' : searchText;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Text(PlacesByNamePage.title, style: AppStyles.text.title),
                AppStyles.space,
                const Text(
                  'Introdueix un nom a continuació i busca informació '
                  'sobre les localitats que tenen aquest nom.',
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
            AppStyles.space,
            // Selecció del país
            Consumer<CountryProvider>(
              builder: (context, provider, child) {
                return CountrySelector(
                  label: 'Selecciona el país on buscar localitats',
                  initialCountry: provider.country,
                  availableCountries: provider.supportedCountries,
                  onSelected: provider.setCountry,
                  menuHeight: 400,
                  width: _selectorWidth,
                );
              },
            ),
            AppStyles.space,
            // Selecció de la regió
            Consumer<CountryProvider>(
              builder: (context, provider, child) {
                if (provider.subdivision != null) {
                  return SubdivisionSelector(
                    label: 'Selecciona la regió on buscar localitats',
                    initialSubdivision: provider.subdivision,
                    availableSubdivisions: provider.country.subdivisions,
                    onSelected: provider.setSubdivision,
                    menuHeight: 400,
                    width: _selectorWidth,
                  );
                }
                return const SizedBox.shrink(); // país sense regions
              },
            ),
            AppStyles.space,
            // Entrada del nom
            PlaceNameTextField(
              onChanged: (name, valid) {
                setState(() {
                  _name = name;
                  _validName = valid;
                });
              },
              onSubmit: _searchResults,
            ),
            const SizedBox(height: 24),
            // Botó per buscar
            Column(
              children: [
                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.search),
                    label: Text(_searchButtonText),
                    onPressed: _validName
                        ? () => _searchResults(context, _name)
                        : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
