import 'package:flutter/material.dart';
import 'package:form_validation/src/blocks/provider.dart';
import 'package:form_validation/src/pages/home_pages.dart';
import 'package:form_validation/src/pages/login_pages.dart';
import 'package:form_validation/src/pages/productor_pages.dart';
import 'package:form_validation/src/pages/registro_pages.dart';
import 'package:form_validation/src/preferencias_usuarios/preferencias_usuario.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = PreferenciasUsuario();
  await prefs.initPref();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _prefs = PreferenciasUsuario();
    print(_prefs.token);
    return Provider(
      child: MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        initialRoute: 'login',
        routes: {
          'login': (context) => LoginPage(),
          'registro': (context) => RegistroPage(),
          'home': (context) => HomePage(),
          'producto': (context) => ProductoPage(),
        },
        theme: ThemeData(
            colorScheme: ThemeData()
                .colorScheme
                .copyWith(primary: Color.fromARGB(250, 255, 207, 51))),
      ),
    );
  }
}
