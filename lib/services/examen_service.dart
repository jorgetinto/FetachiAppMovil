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

}