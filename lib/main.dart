import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/country_provider.dart';
import 'screens/place_screen.dart';
import 'services/zippopotam_service.dart';
import 'styles/app_styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Carrega els països suportats
  // S'ha de cridar aquest mètode abans d'utilitzar el servei
  await ZippopotamService().loadSupportedCountries();

  // Carrega l'aplicació
  runApp(const PostalCodeApp());
}

class PostalCodeApp extends StatelessWidget {
  static const String title = 'Postal Code Info';

  const PostalCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CountryProvider>(
      create: (context) => CountryProvider(),
      child: MaterialApp(
        title: title,
        home: const PlaceScreen(),
        theme: AppStyles.theme(context), // inicialitza el tema
        debugShowCheckedModeBanner: true, // debug banner
      ),
    );
  }
}
