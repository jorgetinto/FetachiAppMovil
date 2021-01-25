import 'dart:convert';
import 'dart:io';

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

  Future<UserPerfilModel>  getUsuarioById(int idUsuario)  async {    
    final url = '$urlBase/Usuario/$idUsuario';

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_prefs.token}',
    });

    final respModel = userPerfilModelFromJson(response.body.toString());
    return respModel;
  }

  Future<Map<String, dynamic>> changePassword(String password) async {
    
    final authData = {
      'Id': _prefs.uid,
      'Password': password,
    };

    final url = '$urlBase/Usuario/ChangePassword/';

    final response = 
      await http.put(url, 
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_prefs.token}',      
        },
        body: json.encode(authData)
      );    

    Map<String, dynamic> decodedResp = json.decode(response.body);

    if (response.statusCode == 200) {
      return {'ok': true, 'message': decodedResp['message']};
    } else {  
      return {'ok': false, 'message': decodedResp['message']};
    }
  }

  Future<Map<String, dynamic>> editarPerfilUsuario(UserPerfilModel userPerfil) async {    

    final url = '$urlBase/Usuario/${userPerfil.id}';

    final response = await http.put(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_prefs.token}',
    },
    body: userPerfilModelToJson(userPerfil)); 

    if (response.statusCode == 200) {
        return {'ok': true, 'message': 'Perfil editado con exito'};
      } else {  
        Map<String, dynamic> decodedResp = json.decode(response.body);  
        return {'ok': false, 'message': decodedResp['message']};
      } 
  }

  Future<String> upload(File imageFile, bool esUsuario, int idUsuario) async {   

      final url = '$urlBase/Upload/$esUsuario/$idUsuario';
      Map<String, String> headers = { "Authorization": "Bearer ${_prefs.token}"};

      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(headers);
      request.files.add(await http.MultipartFile.fromPath('imagen', imageFile.path));
      var streamResponse = await request.send();
     
      final resp = await http.Response.fromStream(streamResponse);

      if ( resp.statusCode != 200 && resp.statusCode != 201 ) {
        print('Algo salio mal');
        return null;
      }

      final respData = json.decode(resp.body);

      return respData['fileName'];
    }
}