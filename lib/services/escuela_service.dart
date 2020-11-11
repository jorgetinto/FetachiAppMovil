import 'dart:io';

import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:fetachiappmovil/helpers/constants.dart' as Constants;
import 'package:fetachiappmovil/helpers/preferencias_usuario/preferenciasUsuario.dart';
import 'package:fetachiappmovil/models/escuela_model.dart';

import 'package:http/http.dart' as http;

class EscuelaServices {

  final String urlBase    = Constants.API_URL;
  final _prefs            = new PreferenciasUsuario();

  Future<EscuelaModel>  getEscuelaById(int id)  async {    
    final url = '$urlBase/Escuela/$id';

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_prefs.token}',
    });

    final respModel = escuelaModelFromJson(response.body.toString());
    return respModel;
  }

  Future<EscuelaModel>  getAllEscuelas()  async {    
    final url = '$urlBase/Escuela/';

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_prefs.token}',
    });

    final respModel = escuelaModelFromJson(response.body.toString());
    return respModel;
  }

  Future<EscuelaModel> createEscuela(EscuelaModel escuelaModel) async { 
    final url       = '$urlBase/Escuela/';
    final response  = await http.post(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_prefs.token}',
    },
    body: escuelaModelToJson(escuelaModel));  

    final respModel = escuelaModelFromJson(response.body.toString());
    return respModel;
  }

  Future<EscuelaModel> updateEscuela(EscuelaModel escuelaModel) async { 
    final url       = '$urlBase/Escuela/${escuelaModel.idEscuela}';
    final response  = await http.put(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_prefs.token}',
    },
    body: escuelaModelToJson(escuelaModel));  

    final respModel = escuelaModelFromJson(response.body.toString());
    return respModel;
  }

  Future<EscuelaModel> deleteEscuela(int id) async { 
    final url       = '$urlBase/Escuela/$id';

    final response  = await http.delete(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_prefs.token}',
    });

    final respModel = escuelaModelFromJson(response.body.toString());
    return respModel;
  }

  Future<String> subirImagen(File imagen, String logoOriginal ) async {

    final cloudinary = Cloudinary(
     '989953882978531',
     'taUtLylZzk5I-SK69mPGM7f74T8',
     'jpino'
    );

    final String cloudinaryCustomFolder = "Fetachi/Escuelas";

    if (logoOriginal != null) {
        await cloudinary.deleteFile(
                  url: logoOriginal,
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