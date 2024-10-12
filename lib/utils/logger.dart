import 'package:flutter/foundation.dart';

/// Mostra un missatge de debug a la consola només en el mode debug\
/// El mètode [debugPrint] mostra els missatges també en release
void log(Object? message) {
  if (kDebugMode) {
    debugPrint(message?.toString());
  }
}
