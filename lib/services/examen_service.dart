import 'dart:convert';

import 'package:fetachiappmovil/helpers/constants.dart' as Constants;
import 'package:fetachiappmovil/helpers/preferencias_usuario/preferenciasUsuario.dart';
import 'package:fetachiappmovil/models/examen_model.dart';
import 'package:http/http.dart' as http;

class ExamenServices {
  final String urlBase    = Constants.API_URL;
  final _prefs            = new PreferenciasUsuario();

  Future<List<ExamenModel>>  getAllExamenByIdMaestroAsync()  async { 

    final url = '$urlBase/Examen/GetAllExamenByIdMaestroAsync/${_prefs.uid}';

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_prefs.token}',
    });    

    if (response.statusCode == 200) {
        final items = json.decode(response.body).cast<Map<String, dynamic>>();
        List<ExamenModel>  listOfUsers = items.map<ExamenModel>((json) {
          return ExamenModel.fromJson(json);
        }).toList();
        return listOfUsers.where((i) => i.idExamen != 0).toList();
      }
    return List<ExamenModel>();
  }


  Future<ExamenModel>  getExamenById(int id)  async {    
    final url = '$urlBase/Examen/GetExamenByIdAsync/$id';

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_prefs.token}',
    });

    final respModel = examenModelFromJson(response.body.toString());
    return respModel;
  }

  Future<bool> deleteExamen(int idExamen) async { 
    final url       = '$urlBase/Examen/$idExamen';
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

  Future<bool> createExamen(ExamenModel examen) async { 
    bool respuesta  = false;
    final url       = '$urlBase/Examen/';
    final response  = await http.post(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_prefs.token}',
    },
    body: examenModelToJson(examen));  

    if (response.statusCode == 200) {
       respuesta = true;
     }

    return respuesta;
  }

  Future<bool> updateExamen(ExamenModel examen) async { 

    bool respuesta  = false;
    final url       = '$urlBase/Examen/${examen.idExamen}';

    final response  = await http.put(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_prefs.token}',
    },
    body: examenModelToJson(examen));  


   if (response.statusCode == 204) {
       respuesta = true;
     }

    return respuesta;
  }
}