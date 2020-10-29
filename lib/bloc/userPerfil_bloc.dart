
import 'dart:io';

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

  void editarPerfilUsuario(UserPerfilModel userPerfil) async {
    final des = await _userPefilService.editarPerfilUsuario(userPerfil);
    _userPerfilController.add(des);    
  }
  
  Future<String> subirFoto(File foto, String imagenOriginal) async {
    final fotoUrl = await _userPefilService.subirImagen(foto, imagenOriginal);
    return fotoUrl;
  }
}