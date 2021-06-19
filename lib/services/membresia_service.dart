import 'dart:convert';

import 'package:fetachiappmovil/helpers/constants.dart' as Constants;
import 'package:fetachiappmovil/helpers/preferencias_usuario/preferenciasUsuario.dart';
import 'package:fetachiappmovil/models/membresia_model.dart';
import 'package:http/http.dart' as http;

class MembresiaServices {

  final String urlBase    = Constants.API_URL;
  final _prefs            = new PreferenciasUsuario();

   Future<List<MembresiaModel>>  getAllMembresia()  async { 

    final url = '$urlBase/Membresia';

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_prefs.token}',
    });    

    if (response.statusCode == 200) {
        final items = json.decode(response.body).cast<Map<String, dynamic>>();
        List<MembresiaModel>  listOfUsers = items.map<MembresiaModel>((json) {
          return MembresiaModel.fromJson(json);
        }).toList();
        
        return listOfUsers.where((i) => i.id != 0).toList();
      }
    return List<MembresiaModel>();
  }

  Future<MembresiaModel>  getMembresiaById(int id)  async {    
    final url = '$urlBase/Membresia/GetMembresiaByIdAsync/$id';

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_prefs.token}',
    });

    final respModel = membresiaModelFromJson(response.body.toString());
    return respModel;
  }

  Future<bool> deleteMembresia(int id) async { 
    final url       = '$urlBase/Membresia/$id';
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

   Future<bool> createMembresia(MembresiaModel model) async { 
    bool respuesta  = false;
    final url       = '$urlBase/Membresia/';
    final response  = await http.post(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_prefs.token}',
    },
    body: membresiaModelToJson(model));  

    if (response.statusCode == 200) {
       respuesta = true;
     }

    return respuesta;
  }

  Future<bool> updateMembresia(MembresiaModel model) async { 

    bool respuesta  = false;
    final url       = '$urlBase/Membresia/${model.id}';

    final response  = await http.put(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_prefs.token}',
    },
    body: membresiaModelToJson(model));  


   if (response.statusCode == 204) {  
       respuesta = true;
     }

    return respuesta;
  }
}