import 'package:flutter/material.dart';

import '../main.dart';
import 'place_by_code_page.dart';
import 'places_by_name_page.dart';

/// Pantalla principal per obtenir informació postal
class PlaceScreen extends StatefulWidget {
  static const String title = PostalCodeApp.title;

  const PlaceScreen({super.key});

  @override
  State<PlaceScreen> createState() => _PlaceScreenState();
}

class _PlaceScreenState extends State<PlaceScreen> {
  static const int _initialPageIndex = 0;

  /// Pàgines de la pantalla principal
  static const _pages = <PageScreen>[
    PageScreen.placeByCode,
    PageScreen.placeByName,
  ];

  /// Controlador per canviar de pàgina amb [PageView] i [BottomNavigationBar]
  final PageController _pageController =
      PageController(initialPage: _initialPageIndex, keepPage: true);

  /// Pàgina actual
  int _currentPageIndex = _initialPageIndex;

  void _navigateToPage(int pageIndex) {
    // Canvia a la pàgina seleccionada
    _pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 250),
      curve: Curves.ease,
    );
    _pageChanged(pageIndex);
  }

  void _pageChanged(int pageIndex) {
    setState(() {
      _currentPageIndex = pageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(PlaceScreen.title),
        centerTitle: true,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _pageChanged,
        children: const [
          // Pàgina principal (Codi postal)
          PlaceByCodePage(),
          // Altres pàgines (Buscar ciutat)
          PlacesByNamePage(),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: BottomNavigationBar(
          items: [
            for (PageScreen page in _pages)
              BottomNavigationBarItem(
                icon: Icon(page.icon),
                label: page.label,
              ),
          ],
          currentIndex: _currentPageIndex,
          onTap: _navigateToPage,
        ),
      ),
    );
  }
}

/// Pàgina per al PageView
final class PageScreen {
  static const placeByCode = PageScreen(
    label: 'Codi postal',
    icon: Icons.pin,
  );
  static const placeByName = PageScreen(
    label: 'Buscar per nom',
    icon: Icons.travel_explore,
  );

  final String label;

  final IconData icon;

  const PageScreen({required this.label, required this.icon});
}
