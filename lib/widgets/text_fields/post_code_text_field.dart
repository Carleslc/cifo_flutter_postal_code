import 'package:flutter/material.dart';

import '../../models/iso_country.dart';
import '../../screens/place_screen.dart';
import '../../services/zippopotam_service.dart';

// Input del codi postal a cercar
class PostCodeTextField extends StatefulWidget {
  /// País del codi postal a cercar
  final Country country;

  final void Function(String value, bool valid)? onChanged;
  final void Function(BuildContext, String value)? onSubmit;

  const PostCodeTextField({
    super.key,
    required this.country,
    this.onChanged,
    this.onSubmit,
  });

  @override
  State<PostCodeTextField> createState() => PostCodeTextFieldState();
}

class PostCodeTextFieldState extends State<PostCodeTextField> {
  static final _postalCodeService = ZippopotamService();

  /// Controlador dels TextField
  late final TextEditingController _postCodeController;

  /// Codi postal del TextField
  String _postCode = '';

  @override
  void initState() {
    super.initState();
    // Inicialitza el controlador de text
    _postCodeController = TextEditingController();
  }

  @override
  void dispose() {
    // Desactiva el controlador de text
    _postCodeController.dispose();
    super.dispose();
  }

  /// Validació del codi postal
  String? _validationError;
  bool _showValidationError = false;

  /// Actualitza l'estat del codi postal
  void setPostCode(String postCode) {
    setState(() {
      // Elimina espais en blanc
      _postCode = postCode.trim();
      // Valida el codi postal
      _validatePostCode();
      // Notifica al widget pare
      widget.onChanged?.call(_postCode, _isValidPostCode);
    });
  }

  /// Reinicia l'estat sense texte
  void clear() {
    _showValidationError = false;
    _postCodeController.clear();
    setPostCode('');
  }

  /// Comprova si els codis postals del país son numèrics
  bool get _isNumericPostalCodeCountry =>
      _postalCodeService.isNumericPostalCodeCountry(widget.country.code);

  /// Valida el codi postal
  /// Si el codi postal es numèric, valida que els caràcters siguin digits
  void _validatePostCode() {
    if (_postCode.isNotEmpty) {
      bool spain = widget.country.code == 'ES';
      // Mostra els missatges d'error
      // (per Espanya només quan s'introdueixen 5 dígits la primera vegada)
      if (!_showValidationError && (!spain || _postCode.length == 5)) {
        _showValidationError = true;
      }
      if (_isNumericPostalCodeCountry) {
        // País amb codi postal numèric
        int? numericCode = int.tryParse(_postCode);
        if (numericCode == null) {
          _validationError = 'El codi postal ha de ser numèric';
          return;
        }
        if (spain) {
          // Espanya
          if (_postCode.length != 5) {
            _validationError = 'El codi postal ha de tenir 5 dígits';
            return;
          }
          if (numericCode < 01001 || numericCode > 52080) {
            _validationError =
                'Rang invàlid. ${widget.country.code}: 01001 - 52080';
            return;
          }
        }
      }
    }
    _validationError = null;
  }

  /// Comprova si el codi postal és vàlid per cercar
  bool get _isValidPostCode => _postCode.isNotEmpty && _validationError == null;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _postCodeController,
      // Tipus de teclat segons si el codi postal del país és numèric o no
      keyboardType: _isNumericPostalCodeCountry
          ? TextInputType.numberWithOptions(decimal: false)
          : TextInputType.streetAddress,
      // Estil del text field
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.numbers),
        hintText: PageScreen.placeByCode.label,
        helperText: 'Introdueix el codi postal',
        border: const OutlineInputBorder(),
        errorText: _showValidationError ? _validationError : null,
      ),
      // Mida màxima del codi postal
      maxLength: widget.country.code == 'ES' ? 5 : 10,
      // Canvia el codi postal
      onChanged: setPostCode,
      // Envia el codi postal
      onSubmitted: _isValidPostCode && widget.onSubmit != null
          ? (value) => widget.onSubmit!(context, value)
          : null,
      // Tanca el teclat si es fa click a un altre lloc
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
    );
  }
}
