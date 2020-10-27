import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:fetachiappmovil/helpers/preferencias_usuario/preferenciasUsuario.dart';
import 'package:fetachiappmovil/helpers/constants.dart' as Constants;

class UsuarioServices {

  final String urlBase    = Constants.API_URL;
  final _prefs            = new PreferenciasUsuario();

  Future<Map<String, dynamic>> login(String userName, String password) async {
    
    final authData = {
      'Username'   : userName,
      'Password'   : password
    };

    final resp = await http.post (
      urlBase + "/Auth/",
      headers: {"Content-Type": "application/json"},
      body: json.encode(authData)
    );  

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('token')) {

        Map<String, dynamic> decodedToken = JwtDecoder.decode(decodedResp['token']);
        _prefs.token                      =  decodedResp['token'];
        _prefs.uid                        =  decodedToken["nameid"];
        
        return {'ok': true};
    } else {
       return {'ok': false, 'mensaje': decodedResp['message']};
    }
  } 
  
  Future<Map<String, dynamic>> signOut() async {

    _prefs.token = '';
    _prefs.uid   = '';
    
    return {'ok': true};
  }
}