

import 'dart:convert';

import 'package:fetachiappmovil/helpers/preferencias_usuario/preferenciasUsuario.dart';
import 'package:fetachiappmovil/helpers/constants.dart' as Constants;
import 'package:http/http.dart' as http;
import 'package:fetachiappmovil/models/detalle_examen_model.dart';

class DetalleExamenService {
  final String urlBase    = Constants.API_URL;
  final _prefs            = new PreferenciasUsuario();

  Future<bool> createDetalleExamen(DetalleExamenModel examen) async { 

    bool respuesta  = false;
    final url       = '$urlBase/DetalleExamen/';

    final response  = await http.post(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_prefs.token}',
    },
    body: detalleExamenModelToJson(examen));  

    if (response.statusCode == 204) {
       respuesta = true;
     }

    return respuesta;
  }
  
  Future<DetalleExamenModel>  getDetalleExamenByIdExamenYIdEstudianteAsync(int idExamen, int idEstudiante) async {    
      final url = '$urlBase/DetalleExamen/GetDetalleExamenByIdExamenYIdEstudianteAsync/$idExamen/$idEstudiante';

      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${_prefs.token}',
      });

      try {
          if (response.statusCode == 200) {
             final respModel = detalleExamenModelFromJson(response.body.toString());
             return respModel;
          }else {
             return new DetalleExamenModel();
          }
         
     } catch (error) {
       return new DetalleExamenModel();
    }
  }

  Future<List<DetalleExamenModel>>  getDetalleExamenByFolio(int folio) async {    
   
     final url = '$urlBase/DetalleExamen/GetDetalleExamenesUsuario/$folio';
     List<DetalleExamenModel> listOfUsers;

      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${_prefs.token}',
      });

      if (response.statusCode == 200) {
        final items = json.decode(response.body).cast<Map<String, dynamic>>();

        listOfUsers = items.map<DetalleExamenModel>((json) {
          return DetalleExamenModel.fromJson(json);
        }).toList();
      }
      return listOfUsers;
  }

  Future<bool> updateDetalleExamen(DetalleExamenModel examen) async { 

    bool respuesta  = false;
    final url       = '$urlBase/DetalleExamen';

    final response  = await http.put(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_prefs.token}',
    },
    body: detalleExamenModelToJson(examen));  


   if (response.statusCode == 204) {
       respuesta = true;
     }

    return respuesta;
  }
}