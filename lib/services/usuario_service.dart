import 'dart:convert';

import 'package:fetachiappmovil/helpers/constants.dart' as Constants;
import 'package:fetachiappmovil/helpers/preferencias_usuario/preferenciasUsuario.dart';
import 'package:fetachiappmovil/models/instructorMaestro_model.dart';
import 'package:http/http.dart' as http;

class UsuarioServices {

  final String urlBase    = Constants.API_URL;
  final _prefs            = new PreferenciasUsuario();

  Future<List<InstructorMaestroModel>>  getUsuariosInstructores()  async {  

      final url = '$urlBase/Usuario/GetUsuariosInstructores';

      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${_prefs.token}',
      });

      if (response.statusCode == 200) {
        final items = json.decode(response.body).cast<Map<String, dynamic>>();

        List<InstructorMaestroModel> listOfUsers = items.map<InstructorMaestroModel>((json) {
          return InstructorMaestroModel.fromJson(json);
        }).toList();

        return listOfUsers;
      } else {
        throw Exception('Failed to load internet');
      }
  }

  Future<List<InstructorMaestroModel>>  getUsuariosMaestros()  async {  

      final url = '$urlBase/Usuario/GetUsuariosMaestros';

      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${_prefs.token}',
      });

      if (response.statusCode == 200) {
        final items = json.decode(response.body).cast<Map<String, dynamic>>();

        List<InstructorMaestroModel> listOfUsers = items.map<InstructorMaestroModel>((json) {
          return InstructorMaestroModel.fromJson(json);
        }).toList();

        return listOfUsers;
      } else {
        throw Exception('Failed to load internet');
      }
  }


  Future<List<InstructorMaestroModel>>  getTipoUsuarioPorIdUsuario()  async {  

      final url = '$urlBase/Usuario/GetTipoUsuarioPorIdUsuario/${_prefs.uid}';

      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${_prefs.token}',
      });

      if (response.statusCode == 200) {
        final items = json.decode(response.body).cast<Map<String, dynamic>>();

        List<InstructorMaestroModel> listOfUsers = items.map<InstructorMaestroModel>((json) {
          return InstructorMaestroModel.fromJson(json);
        }).toList();

        return listOfUsers;
      } else {
        throw Exception('Failed to load internet');
      }
  }


}