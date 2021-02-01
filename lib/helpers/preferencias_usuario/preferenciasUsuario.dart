import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {

  static final PreferenciasUsuario _instancia = new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // GET y SET del nombre
  get token {
    return _prefs.getString('token') ?? '';
  }

  set token( String value ) {
    _prefs.setString('token', value);
  }

  // GET y SET del uid
  get uid {
    return _prefs.getString('Id') ?? '';
  }

  set uid( String value ) {
    _prefs.setString('Id', value);
  } 

  get perfil {
    return _prefs.getString('role') ?? '';
  }

  set perfil( String value ) {
    _prefs.setString('role', value);
  } 

   get idExamen {
    return _prefs.getInt('idExamen') ?? '';
  }

  set idExamen( int value ) {
    _prefs.setInt('idExamen', value);
  } 
}