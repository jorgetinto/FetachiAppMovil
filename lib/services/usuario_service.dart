import 'dart:convert';

import 'package:fetachiappmovil/helpers/constants.dart' as Constants;
import 'package:fetachiappmovil/helpers/preferencias_usuario/preferenciasUsuario.dart';
import 'package:fetachiappmovil/models/dropdown_model.dart';
import 'package:fetachiappmovil/models/userForRegister_model.dart';
import 'package:fetachiappmovil/models/usuarioPorIdEscuela_model.dart';
import 'package:http/http.dart' as http;

class UsuarioServices {

  final String urlBase    = Constants.API_URL;
  final _prefs            = new PreferenciasUsuario();

  Future<List<DropDownModel>>  getUsuariosInstructores()  async {  

      final url = '$urlBase/Usuario/GetUsuariosInstructores';

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

  Future<List<DropDownModel>>  getUsuariosMaestros()  async {  

      final url = '$urlBase/Usuario/GetUsuariosMaestros';

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

  Future<List<DropDownModel>>  getTipoUsuarioPorIdUsuario()  async {  

      final url = '$urlBase/Usuario/GetTipoUsuarioPorIdUsuario/${_prefs.uid}';

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

  Future<List<DropDownModel>>  getApoderadosByIdEscuela(int idEscuela)  async {  

      final url = '$urlBase/Usuario/GetApoderadosByIdEscuela/$idEscuela';

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

  Future<List<UsuarioPorIdEscuelaModel>>  getUsuariosByIdEscuela(int idEscuela)  async {  

      final url = '$urlBase/Usuario/GetUsuariosByIdEscuela/$idEscuela';

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
      } 
      return new List<UsuarioPorIdEscuelaModel>();
  }

  Future<List<UsuarioPorIdEscuelaModel>>  getUsuarioSabunim()  async {  

      final url = '$urlBase/Usuario/GetUsuarioSabunim/';

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
      } 
      return new List<UsuarioPorIdEscuelaModel>();
  }
 

  Future<Map<String, dynamic>> crearUsuario(UserForRegisterModel user) async {    

    final url = '$urlBase/Auth/register/';

    final response = await http.post(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_prefs.token}',
    },
    body: userForRegisterModelToJson(user));    

    if (response.statusCode == 200) {
        return {'ok': true, 'message': 'Usuario Creado con exito'};
      } else {  
        Map<String, dynamic> decodedResp = json.decode(response.body);  
        return {'ok': false, 'message': decodedResp['message']};
      }
  }

  Future<bool> deleteUsuario(int id) async { 
    final url       = '$urlBase/Usuario/$id';
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

  Future<UserForRegisterModel>  getUsuarioByIdUsuario(int id)  async {    
    final url = '$urlBase/Usuario/GetUsuarioByIdUsuario/$id';

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_prefs.token}',
    });

    try {
      final respModel = userForRegisterModelFromJson(response.body.toString());
      return respModel;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Map<String, dynamic>> updateUsuario(UserForRegisterModel user) async {    

    final url = '$urlBase/Usuario/UpdateUsuario/${user.id}';

    final response = await http.put(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_prefs.token}',
    },
    body: userForRegisterModelToJson(user));    

    if (response.statusCode == 200) {
        return {'ok': true, 'message': 'Usuario Creado con exito'};
      } else {  
        Map<String, dynamic> decodedResp = json.decode(response.body);  
        return {'ok': false, 'message': decodedResp['message']};
      }
  }
}