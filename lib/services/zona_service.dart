import 'dart:convert';

import 'package:fetachiappmovil/helpers/constants.dart' as Constants;
import 'package:fetachiappmovil/helpers/preferencias_usuario/preferenciasUsuario.dart';
import 'package:fetachiappmovil/models/zona_model.dart';
import 'package:http/http.dart' as http;

class ZonaServices {

  final String urlBase    = Constants.API_URL;
  final _prefs            = new PreferenciasUsuario();

  Future<List<ZonaModel>>  getAllZonases()  async {  

      final url = '$urlBase/Zona/';

      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${_prefs.token}',
      });

      if (response.statusCode == 200) {
        final items = json.decode(response.body).cast<Map<String, dynamic>>();

        List<ZonaModel> listOfUsers = items.map<ZonaModel>((json) {
          return ZonaModel.fromJson(json);
        }).toList();

        return listOfUsers;
      } else {
        throw Exception('Failed to load internet');
      }
  }

}