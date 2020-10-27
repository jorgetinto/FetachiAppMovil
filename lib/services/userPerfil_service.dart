import 'package:http/http.dart' as http;

import 'package:fetachiappmovil/helpers/constants.dart' as Constants;
import 'package:fetachiappmovil/helpers/preferencias_usuario/preferenciasUsuario.dart';
import 'package:fetachiappmovil/models/userPerfil_model.dart';

class UserPerfilServices {

  final String urlBase    = Constants.API_URL;
  final _prefs            = new PreferenciasUsuario();

  Future<UserPerfilModel>  getPerfilById()  async {    
    final url = '$urlBase/Usuario/${_prefs.uid}';

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_prefs.token}',
    });

    final respModel = userPerfilModelFromJson(response.body.toString());
    return respModel;
  }

}