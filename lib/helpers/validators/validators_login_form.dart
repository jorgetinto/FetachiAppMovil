import 'dart:async';

class ValidatorsLoginForm {

  final validarUserName = StreamTransformer<String, String>.fromHandlers(
    handleData: (userName, sink) {
      Pattern pattern = r'^([A-Za-z0-9.-]{3,25}).$';
      RegExp regExp = new RegExp(pattern);

      if (regExp.hasMatch(userName)) {
        sink.add(userName);
      } else {
        sink.addError('Nombre de usuario no es correcto');
      }
    }
  );

  final validarPassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      if (password.length >= 6) {
        sink.add(password);
      } else {
        sink.addError('Más de 6 caracteres por favor');
      }
    }
  );
}