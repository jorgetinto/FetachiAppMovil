import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:fetachiappmovil/helpers/preferencias_usuario/preferenciasUsuario.dart';
import 'package:fetachiappmovil/helpers/constants.dart' as Constants;

class AuthServices {

  final String urlBase    = Constants.API_URL;
  final _prefs            = new PreferenciasUsuario();

  Future<Map<String, dynamic>> login(String userName, String password) async {
    try {

        final authData = {
          'Username'   : userName,
          'Password'   : password
        };

        final resp = await http.post (
                                  urlBase + "/Auth/",
                                  headers: {"Content-Type": "application/json"},
                                  body: json.encode(authData)
                                ).timeout(const Duration(seconds: 10),onTimeout : () {
                                  throw TimeoutException('The connection has timed out, Please try again!');
                                });

        Map<String, dynamic> decodedResp = json.decode(resp.body);

        if (resp.statusCode == 200) {
          if (decodedResp.containsKey('token')) {
            Map<String, dynamic> decodedToken = JwtDecoder.decode(decodedResp['token']);
            _prefs.token                      =  decodedResp['token'];
            _prefs.uid                        =  decodedToken["nameid"];
            _prefs.perfil                     =  decodedToken["role"];
            
            return {'ok': true,'mensaje': 'ok'};
          }
        }         
        return {'ok': false, 'mensaje': decodedResp['message']};

    } on SocketException {
      return {'ok': false, 'mensaje': 'Problemas con la conexión a internet'};
    }    
  } 
  
  Future<Map<String, dynamic>> signOut() async {

    _prefs.token = null;
    _prefs.uid   = null;
    _prefs.perfil = null;
    return {'ok': true};
  }
}