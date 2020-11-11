import 'dart:convert';

import 'package:fetachiappmovil/helpers/constants.dart' as Constants;
import 'package:fetachiappmovil/models/comuna_model.dart';
import 'package:fetachiappmovil/models/region_model.dart';
import 'package:http/http.dart' as http;
import 'package:fetachiappmovil/helpers/preferencias_usuario/preferenciasUsuario.dart';

class ComunaRegionServices {

  final String urlBase    = Constants.API_URL;
  final _prefs            = new PreferenciasUsuario();

  Future<List<RegionModel>>  getAllRegiones()  async {  

      final url = '$urlBase/ComunaRegion/';

      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${_prefs.token}',
      });

      if (response.statusCode == 200) {
        final items = json.decode(response.body).cast<Map<String, dynamic>>();

        List<RegionModel> listOfUsers = items.map<RegionModel>((json) {
          return RegionModel.fromJson(json);
        }).toList();

        return listOfUsers;
      } else {
        throw Exception('Failed to load internet');
      }
  }

   Future<List<ComunaModel>>  getAllComunaByIdRegion(String idRegion)  async {    
    final url = '$urlBase/ComunaRegion/$idRegion';

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_prefs.token}',
    });

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();

      List<ComunaModel> listOfUsers = items.map<ComunaModel>((json) {
        return ComunaModel.fromJson(json);
      }).toList();

      return listOfUsers;
    } else {
      throw Exception('Failed to load internet');
    }
  }
}