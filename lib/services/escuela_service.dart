import 'dart:convert';

import 'package:fetachiappmovil/helpers/constants.dart' as Constants;
import 'package:fetachiappmovil/helpers/preferencias_usuario/preferenciasUsuario.dart';
import 'package:fetachiappmovil/models/dropdown_model.dart';
import 'package:fetachiappmovil/models/escuelaPorIdInstructor_model.dart';
import 'package:fetachiappmovil/models/escuela_model.dart';
import 'package:fetachiappmovil/models/usuarioPorIdEscuela_model.dart';

import 'package:http/http.dart' as http;

class EscuelaServices {

  final String urlBase    = Constants.API_URL;
  final _prefs            = new PreferenciasUsuario();

  Future<EscuelaModel>  getEscuelaById(int id)  async {    
    final url = '$urlBase/Escuela/GetEscuelaById/$id';

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_prefs.token}',
    });

    final respModel = escuelaModelFromJson(response.body.toString());
    return respModel;
  }

  Future<List<EscuelaPorIdInstructorModel>>  getEscuelaByIdInstructor()  async {   
    final url = '$urlBase/Escuela/GetEscuelaByIdInstructor/${_prefs.uid}';

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_prefs.token}',
    });    

    if (response.statusCode == 200) {
        final items = json.decode(response.body).cast<Map<String, dynamic>>();
        List<EscuelaPorIdInstructorModel>  listOfUsers = items.map<EscuelaPorIdInstructorModel>((json) {
          return EscuelaPorIdInstructorModel.fromJson(json);
        }).toList();
        return listOfUsers.where((i) => i.idEscuela != 0).toList();
      }
    return List<EscuelaPorIdInstructorModel>();
  }

  Future<EscuelaModel>  getAllEscuelas()  async {    
    final url = '$urlBase/Escuela/';

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_prefs.token}',
    });

    final respModel = escuelaModelFromJson(response.body.toString());
    return respModel;
  }

  Future<bool> createEscuela(EscuelaModel escuelaModel) async { 
    bool respuesta  = false;
    final url       = '$urlBase/Escuela/';
    final response  = await http.post(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_prefs.token}',
    },
    body: escuelaModelToJson(escuelaModel));  

    if (response.statusCode == 204) {
       respuesta = true;
     }

    return respuesta;
  }

  Future<bool> updateEscuela(EscuelaModel escuelaModel) async { 
    bool respuesta  = false;
    final url       = '$urlBase/Escuela/${escuelaModel.idEscuela}';
    final response  = await http.put(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_prefs.token}',
    },
    body: escuelaModelToJson(escuelaModel));  

   if (response.statusCode == 204) {
       respuesta = true;
     }

    return respuesta;
  }

  Future<bool> deleteEscuela(int id) async { 
    final url       = '$urlBase/Escuela/$id';
    bool respuesta  = false;

    final response  = await http.delete(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_prefs.token}',
    });

     if (response.statusCode == 204) {
       respuesta = true;
     }

    return respuesta;
  }

  Future<List<DropDownModel>>  getEscuelaPorIdUsuario()  async {    

    final url = '$urlBase/Escuela/GetEscuelaPorIdUsuario/${_prefs.uid}';

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_prefs.token}',
    });    

    if (response.statusCode == 200) {
        final items = json.decode(response.body).cast<Map<String, dynamic>>();
        List<DropDownModel> listOfUsers = items.map<DropDownModel>((json) {
          return DropDownModel.fromJson(json);
        }).toList();

        return listOfUsers;
      } else {
        throw Exception('Failed to load internet');
      }
  }

    Future<List<UsuarioPorIdEscuelaModel>>  getEscuelaPorIdUsuarioGrind()  async {    

    final url = '$urlBase/Escuela/GetEscuelaPorIdUsuario/${_prefs.uid}';

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_prefs.token}',
    });    

    if (response.statusCode == 200) {
        final items = json.decode(response.body).cast<Map<String, dynamic>>();
        List<UsuarioPorIdEscuelaModel> listOfUsers = items.map<UsuarioPorIdEscuelaModel>((json) {
          return UsuarioPorIdEscuelaModel.fromJson(json);
        }).toList();

        return listOfUsers;
      } else {
        throw Exception('Failed to load internet');
      }
  }

}