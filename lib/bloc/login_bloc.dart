import 'package:rxdart/rxdart.dart';

import 'package:fetachiappmovil/helpers/validators/validators_login_form.dart';
import 'package:fetachiappmovil/services/usuario_service.dart';

class LoginBloc with ValidatorsLoginForm {

  final _userNameController       = BehaviorSubject<String>();
  final _passController           = BehaviorSubject<String>();
  final _usuarioProvider          = UsuarioServices();

  // Recuperar los datos del stream
  Stream<String> get userNameStream          => _userNameController.stream.transform(validarUserName);
  Stream<String> get passwordStream          => _passController.stream.transform(validarPassword);
  Stream<bool>   get formValidStream         => Rx.combineLatest2(userNameStream, passwordStream, (e, p) => true);

  // Insertar valores al Stream
  Function(String) get changeUserName         => _userNameController.sink.add;
  Function(String) get changePassword         => _passController.sink.add;

  // Obtener el ultimo valor ingresado a los streams
  String get userName        => _userNameController.value;
  String get password        => _passController.value;

  Future<Map<String, dynamic>> login(String email, String password) async {
    final resultado = await _usuarioProvider.login(email, password);
    return resultado;
  }
  
  Future<Map<String, dynamic>> signOut() async {
    final resultado = await _usuarioProvider.signOut();
    changeUserName('');
    changePassword('');
    return resultado;
  }

  dispose() {
    _userNameController?.close();
    _passController?.close();
  }
}