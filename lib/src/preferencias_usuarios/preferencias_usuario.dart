import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia = PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  SharedPreferences? _prefs;

  initPref() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // GET y SET del token
  String get token {
    return _prefs!.getString('token') ?? '';
  }

  set token(String value) {
    _prefs!.setString('token', value);
  }

  // GET y SET de la última página
  String get ultimaPagina {
    return _prefs!.getString('ultimaPagina') ?? 'login';
  }

  set ultimaPagina(String value) {
    _prefs!.setString('ultimaPagina', value);
  }
}
