import 'package:flutter/material.dart';
import 'package:form_validation/src/blocks/provider.dart';
import 'package:form_validation/src/providers/usuario_provider.dart';
import 'package:form_validation/src/utils/utils.dart';

class LoginPage extends StatelessWidget {
  final usuarioProvider = UsuarioProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _crearFondo(context),
          _loginForm(context),
        ],
      ),
    );
  }

  Widget _loginForm(BuildContext context) {
    final bloc = Provider.of(context);

    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
              child: Container(
            height: 180.0,
          )),
          Container(
            width: size.width * 0.80,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 3.0,
                )
              ],
            ),
            child: Column(
              children: [
                Text('Ingreso', style: TextStyle(fontSize: 20.0)),
                SizedBox(height: 10.0),
                _crearEmail(bloc),
                _crearPassword(bloc),
                const SizedBox(height: 20.0),
                _crearBoton(bloc)
              ],
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, 'registro'),
            child: Text('Crear cuenta'),
          ),
          SizedBox(height: 100.0)
        ],
      ),
    );
  }

  Widget _crearEmail(LoginBlock bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snap) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(
                Icons.email_outlined,
                color: Color.fromARGB(255, 255, 207, 51),
              ),
              hintText: 'Ejemplo@correo.com',
              labelText: 'Correo Electronico',
              counterText: snap.data,
              errorText: snap.error as String?,
            ),
            onChanged: bloc.changeEmail,
          ),
        );
      },
    );
  }

  Widget _crearPassword(LoginBlock bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snap) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: const Icon(
                Icons.lock,
                color: Color.fromARGB(255, 255, 207, 51),
              ),
              labelText: 'Contaseña',
              counterText: snap.data,
              errorText: snap.error as String?,
            ),
            onChanged: bloc.changePassword,
          ),
        );
      },
    );
  }

  Widget _crearBoton(LoginBlock bloc) {
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return ElevatedButton(
          onPressed: snapshot.hasData ? () => _login(bloc, context) : null,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            child: Text(
              'Ingresar',
              style: TextStyle(color: Colors.black),
            ),
          ),
          style: ElevatedButton.styleFrom(
            elevation: 0.0,
            primary: Color.fromARGB(253, 255, 207, 51),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
          ),
        );
      },
    );
  }

  _login(LoginBlock bloc, BuildContext context) async {
    Map info = await usuarioProvider.login(bloc.email, bloc.password);
    if (info['ok']) {
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      mostrarAlerta(context, 'Contraseña y/o correos incorrectos');
    }
  }

  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final fondo = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(253, 255, 207, 51),
            Color.fromARGB(255, 255, 207, 51),
          ],
        ),
      ),
    );

    final cirulo = Container(
      height: 100.0,
      width: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Color.fromARGB(133, 255, 255, 255)),
    );

    return Stack(
      children: [
        fondo,
        Positioned(top: 60.0, left: 260.0, child: cirulo),
        //Positioned(top: -40.0, left: -30.0, child: cirulo),
        Positioned(top: -50.0, left: -10.0, child: cirulo),
        Positioned(top: 120.0, left: 20.0, child: cirulo),
        //Positioned(top: -50.0, left: 2300.0, child: cirulo),
        Container(
          padding: EdgeInsets.only(top: 70.0),
          child: Column(
            children: [
              Container(
                //width: double.infinity * 0.5,
                height: 120,
                child: Image.asset('assets/LogoTES.jpg'),
              ),
              //Image.asset('assets/LogoTES.jpg'),
              //Icon(Icons.person_pin_circle_outlined,
              //color: Colors.white, size: 80),
              SizedBox(height: 10.0, width: double.infinity),
              Text(
                'Inicio de sesion',
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0), fontSize: 20.0),
              )
            ],
          ),
        ),
      ],
    );
  }
}
