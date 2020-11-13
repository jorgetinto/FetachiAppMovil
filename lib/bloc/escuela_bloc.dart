import 'dart:io';

import 'package:fetachiappmovil/models/escuela_model.dart';
import 'package:fetachiappmovil/services/escuela_service.dart';
import 'package:rxdart/rxdart.dart';

class EscuelaBloc {

  final _escuelaController   = new BehaviorSubject<EscuelaModel>();
  final _escuelaService      = new EscuelaServices();

  Stream<EscuelaModel> get userPerfilStream => _escuelaController.stream;

  void getEscuelaById(int id) async {
    final user = await _escuelaService.getEscuelaById(id);
    _escuelaController.add(user);    
  }

  void getAllEscuelas() async {
    final user = await _escuelaService.getAllEscuelas();
    _escuelaController.add(user);    
  }

  void createEscuela(EscuelaModel escuelaModel) async {
    final user = await _escuelaService.createEscuela(escuelaModel);
    _escuelaController.add(user);    
  }

  void updateEscuela(EscuelaModel escuelaModel) async {
    final user = await _escuelaService.updateEscuela(escuelaModel);
    _escuelaController.add(user);    
  }

  void deleteEscuela(int id) async {
    final user = await _escuelaService.deleteEscuela(id);
    _escuelaController.add(user);    
  }
    
  Future<String> subirFoto(File foto, String logoOriginal) async {
    final fotoUrl = await _escuelaService.subirImagen(foto, logoOriginal);
    return fotoUrl;
  }

}