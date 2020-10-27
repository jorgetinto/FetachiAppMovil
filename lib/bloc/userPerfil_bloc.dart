
import 'package:rxdart/rxdart.dart';

import 'package:fetachiappmovil/models/userPerfil_model.dart';
import 'package:fetachiappmovil/services/userPerfil_service.dart';

class UserPerfilBloc {

  final _userPerfilController   = new BehaviorSubject<UserPerfilModel>();
  final _userPefilService     = new UserPerfilServices();

  Stream<UserPerfilModel> get userPerfilStream => _userPerfilController.stream;

  void buscarUserPerfil() async {
    final user = await _userPefilService.getPerfilById();
    _userPerfilController.add(user);    
  }

}