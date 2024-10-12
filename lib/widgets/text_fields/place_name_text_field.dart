import 'package:flutter/material.dart';

// Input del nom a cercar
class PlaceNameTextField extends StatefulWidget {
  final void Function(String value, bool valid)? onChanged;
  final void Function(BuildContext, String value)? onSubmit;

  const PlaceNameTextField({super.key, this.onChanged, this.onSubmit});

  @override
  State<PlaceNameTextField> createState() => PlaceNameTextFieldState();
}

class PlaceNameTextFieldState extends State<PlaceNameTextField> {
  /// Controlador del TextField
  late final TextEditingController _nameController;

  /// Nom del TextField
  String _name = '';

  @override
  void initState() {
    super.initState();
    // Inicialitza el controlador de text
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    // Desactiva el controlador de text
    _nameController.dispose();
    super.dispose();
  }

  /// Actualitza l'estat del nom
  void setName(String name) {
    setState(() {
      // Elimina espais en blanc
      _name = name.trim();
      // Notifica al widget pare
      widget.onChanged?.call(_name, _isValidName);
    });
  }

  /// Reinicia l'estat sense texte
  void clear() {
    _nameController.clear();
    setName('');
  }

  /// Comprova si el nom és vàlid per cercar
  bool get _isValidName => _name.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _nameController,
      keyboardType: TextInputType.text,
      // Estil del text field
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.location_city),
        hintText: 'Nom',
        helperText: 'Introdueix el nom a buscar',
        border: const OutlineInputBorder(),
        // Botó per eliminar fàcilment el text
        suffixIcon: _name.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _nameController.clear();
                  setName('');
                },
              )
            : null,
      ),
      // Mida màxima del input
      maxLength: 100,
      // Canvia el nom
      onChanged: setName,
      // Envia el nom
      onSubmitted: _isValidName && widget.onSubmit != null
          ? (value) => widget.onSubmit!(context, value)
          : null,
      // Tanca el teclat si es fa click a un altre lloc
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
    );
  }
}
