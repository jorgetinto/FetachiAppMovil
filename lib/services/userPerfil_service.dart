import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_sdk/cloudinary_sdk.dart';
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

  Future<UserPerfilModel> editarPerfilUsuario(UserPerfilModel userPerfil) async {    

    final url = '$urlBase/Usuario/${_prefs.uid}';

    final response = await http.put(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_prefs.token}',
    },
    body: userPerfilModelToJson(userPerfil));  

    final respModel = userPerfilModelFromJson(response.body.toString());
    return respModel;
  }

  Future<String> subirImagen(File imagen, String imagenOriginal ) async {

    final cloudinary = Cloudinary(
     '989953882978531',
     'taUtLylZzk5I-SK69mPGM7f74T8',
     'jpino'
    );

    final String cloudinaryCustomFolder = "Fetachi/Usuarios";

    if (imagenOriginal != null) {
        await cloudinary.deleteFile(
                  url: imagenOriginal,
                  resourceType: CloudinaryResourceType.image,
                  invalidate: false,
            );
    }

    final response = await cloudinary.uploadFile(
      imagen.path,
      resourceType: CloudinaryResourceType.image,
      folder: cloudinaryCustomFolder,
    );

    return response.secureUrl;
  }

}