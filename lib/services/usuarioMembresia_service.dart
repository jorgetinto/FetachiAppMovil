
import 'dart:convert';

import 'package:fetachiappmovil/helpers/constants.dart' as Constants;
import 'package:fetachiappmovil/helpers/preferencias_usuario/preferenciasUsuario.dart';
import 'package:fetachiappmovil/models/UserLessMembresia_model.dart';
import 'package:fetachiappmovil/models/UsuarioMembresia_model.dart';
import 'package:http/http.dart' as http;

class UsuarioMembresiaServices{

  final String urlBase    = Constants.API_URL;
  final _prefs            = new PreferenciasUsuario();

  Future<List<UserLessMembresiaModel>>  getUMQueNoTieneMembresiaByIdMestro()  async {    
    final url = '$urlBase/Membresia/GetUMQueNoTieneMembresiaByIdMestro/${_prefs.uid}';

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_prefs.token}',
    });

    if (response.statusCode == 200) {
        final items = json.decode(response.body).cast<Map<String, dynamic>>();
        List<UserLessMembresiaModel>  listOfUsers = items.map<UserLessMembresiaModel>((json) {
          return UserLessMembresiaModel.fromJson(json);
        }).toList();
        
        return listOfUsers.where((i) => i.idUser != 0).toList();
      }
    return List<UserLessMembresiaModel>();
  }

  Future<List<UserLessMembresiaModel>>  getUsuarioTieneMembresiaByIdMestro()  async {    
    final url = '$urlBase/Membresia/GetUsuarioTieneMembresiaByIdMestro/${_prefs.uid}';

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_prefs.token}',
    });

    if (response.statusCode == 200) {
        final items = json.decode(response.body).cast<Map<String, dynamic>>();
        List<UserLessMembresiaModel>  listOfUsers = items.map<UserLessMembresiaModel>((json) {
          return UserLessMembresiaModel.fromJson(json);
        }).toList();
        
        return listOfUsers.where((i) => i.idUser != 0).toList();
      }
    return List<UserLessMembresiaModel>();
  }

  Future<bool> deleteUsuarioMembresia(int id) async { 
    final url       = '$urlBase/UsuarioMembresia/$id';
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

  Future<bool> createUsuarioMembresia(UsuarioMembresiaModel model) async { 

    bool respuesta  = false;
    final url       = '$urlBase/UsuarioMembresia/';
    final response  = await http.post(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_prefs.token}',
    },
    body: usuarioMembresiaModelToJson(model));  

    if (response.statusCode == 200) {
       respuesta = true;
     }

    return respuesta;
  }

  Future<bool> updateUsuarioMembresia(UsuarioMembresiaModel model) async { 

    bool respuesta  = false;
    final url       = '$urlBase/UsuarioMembresia/${model.id}';

    final response  = await http.put(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_prefs.token}',
    },
    body: usuarioMembresiaModelToJson(model));  


   if (response.statusCode == 204) {  
       respuesta = true;
     }

    return respuesta;
  }

  Future<UsuarioMembresiaModel>  getUsuarioMembresiaByIdAsync(int id)  async {    
    final url = '$urlBase/UsuarioMembresia/GetUsuarioMembresiaByIdAsync/$id';

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_prefs.token}',
    });

    try {
      final respModel = usuarioMembresiaModelFromJson(response.body.toString());
      return respModel;
    } catch (e) {
      print(e);
      return null;
    }
  }
}