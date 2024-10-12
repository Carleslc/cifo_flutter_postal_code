import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/iso_country.dart';
import '../providers/country_provider.dart';
import '../styles/app_styles.dart';
import '../widgets/selectors/country_selector.dart';
import '../widgets/text_fields/post_code_text_field.dart';
import 'place_by_code_results.dart';

/// Pantalla per buscar llocs d'un país a partir d'un codi postal
class PlaceByCodePage extends StatefulWidget {
  static const String title = 'Buscar per codi postal';

  const PlaceByCodePage({super.key});

  @override
  State<PlaceByCodePage> createState() => _PlaceByCodePageState();
}

class _PlaceByCodePageState extends State<PlaceByCodePage> {
  /// Codi postal
  String _postCode = '';
  bool _validPostCode = false;

  /// Referència a l'estat del text field
  final GlobalKey<PostCodeTextFieldState> postCodeTextField =
      GlobalKey<PostCodeTextFieldState>();

  /// Amplada del selector
  late double _selectorWidth;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Expandeix horitzontalment ajustat per padding
    _selectorWidth = MediaQuery.of(context).size.width - 48;
  }

  /// Navega a la pàgina de búsqueda i resultats
  void _searchResults(BuildContext context, String postCode) {
    // Obté el país del provider
    final Country country = context.read<CountryProvider>().country;

    // Busca localitats per codi postal
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlaceByCodeResults(
          postCode: postCode,
          country: country,
        ),
      ),
    );
  }

  /// Text del botó per buscar una localitat a partir del codi postal
  String get _searchButtonText {
    const String searchText = 'Buscar codi postal';
    return _validPostCode ? '$searchText ($_postCode)' : searchText;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(PlaceByCodePage.title, style: AppStyles.text.title),
            AppStyles.space,
            // Codi postal
            const Text(
              'Introdueix un codi postal a continuació i busca informació '
              'sobre la localitat a la que pertany.',
              textAlign: TextAlign.justify,
            ),
            AppStyles.space,
            // Selecció del país
            Consumer<CountryProvider>(
              builder: (context, provider, child) {
                return CountrySelector(
                  label: 'Selecciona el país del codi postal',
                  initialCountry: provider.country,
                  availableCountries: provider.supportedCountries,
                  onSelected: (Country country) {
                    provider.setCountry(country);
                    // Esborra el text del codi postal ja que la validació canvia
                    postCodeTextField.currentState?.clear();
                  },
                  menuHeight: 400,
                  width: _selectorWidth,
                );
              },
            ),
            AppStyles.space,
            Consumer<CountryProvider>(
              builder: (context, provider, child) {
                // Entrada del codi postal
                return PostCodeTextField(
                  key: postCodeTextField,
                  country: provider.country,
                  onChanged: (postCode, valid) {
                    setState(() {
                      _postCode = postCode;
                      _validPostCode = valid;
                    });
                  },
                  onSubmit: _searchResults,
                );
              },
            ),
            AppStyles.space,
            // Botó per buscar
            Center(
              child: Column(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.search),
                    label: Text(_searchButtonText),
                    onPressed: _validPostCode
                        ? () => _searchResults(context, _postCode)
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
