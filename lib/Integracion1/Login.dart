/*
TODO push homepage pasando nombre de usuario y eliminando Login del Navigator
TODO revisar SafeArea
  SafeArea is a widget that insets its child by sufficient padding to avoid
  intrusions by the operating system. For example, this will indent the child
  by enough to avoid the status bar at the top of the screen.
  body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          HeaderLayout(),
        ],
      )
  ),
 */

/*
  Ideas generales tomadas de https://medium.com/flutter-community/flutter-login-tutorial-with-flutter-bloc-ea606ef701ad

  Para implementar el patrón BLoC se agregan estas dependencias en pubspec.yaml
    bloc: Asiste en la implementación del patrón BLoC
    flutter_bloc: Asiste en la implementación del patrón BLoC junto con bloc
    meta: Define anotaciones
    equatable: Ayuda a comparar objetos sustituyendo a == y hashCode
*/

import 'package:flutter/material.dart';
import 'package:learning_flutter/Integracion1/backend/User.dart';

class LoginRoute extends StatefulWidget {
  LoginRoute({Key key}) : super(key: key);
  @override
  _LoginRouteState createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  TextEditingController loginController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: formUI(),
          ),
        ),
      ),

    );
  }

  String _login;
  String _password;

  Widget formUI() {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: loginController,
          decoration: const InputDecoration(labelText: 'Usuario'),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value.isEmpty) {
              return 'Escribe tu nombre de usuario';
            }
          },
          onSaved: (String val) {
            _login = val;
          },
        ),
        TextFormField(
          controller: passController,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Contraseña'),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value.isEmpty) {
              return 'Escribe tu contraseña';
            }
          },
          onSaved: (String val) {
            _password = val;
          },
        ),
        SizedBox(
          height: 10.0,
        ),
        RaisedButton(
          key:null,
          color: const Color(0xFFd04421),
          child: Text(
            "Entrar",
            style: TextStyle(fontSize:14.0,
                color: const Color(0xFFffffff),
                fontWeight: FontWeight.w500,
                fontFamily: "Roboto"),
          ),
          onPressed:_fieldValidation,
        ),
      ],
    );
  }

  void _fieldValidation(){
    if (_formKey.currentState.validate()) {
      //todos los campos se llenaron, así que se guardan los datos
      _formKey.currentState.save();

      String login = loginController.text;
      String password = passController.text;

      User myUser = User.validateUser(login, password);
      if(myUser == null){
        print('Los datos no coiciden, prueba de nuevo');
      } else {
        print('Usuario logueado: ${myUser.name}');
      }
    } else {
      //uno o ambos campos son inválidos, inicia autovalidación
      setState(() {
        _autoValidate = true;
      });
    }

  }
}