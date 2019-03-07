import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:learning_flutter/LoginEffects/bloc/module_start/exports.dart';
import 'package:learning_flutter/LoginEffects/model/exports.dart';
import 'package:learning_flutter/LoginEffects/backend/exports.dart';

//todo username debe ser su email; incluir él teléfono
//todo aviso al usuario del proceso de cambiar su fecha de nacimiento
class RegisterForm extends StatefulWidget {
  final AuthenticationBloc authenticationBloc;

  RegisterForm({
    Key key,
    @required this.authenticationBloc,
  }) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _firstName1Controller = TextEditingController();
  final _firstName2Controller = TextEditingController();
  final _lastName1Controller = TextEditingController();
  final _lastName2Controller = TextEditingController();
  final _dateOfBirthController = TextEditingController();

  AuthenticationBloc get _authenticationBloc => widget.authenticationBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationEvent, AuthenticationState>(
      bloc: _authenticationBloc,
      builder: (
          BuildContext context,
          AuthenticationState state,
          ) {
        if (state is RegisterFailure) {
          _onWidgetDidBuild(() {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          });
        }

        return WillPopScope(
          child: _getMainContentWidget(state),
          onWillPop: _onWillPop,
        );
        //return _getForm(state);
      },
    );
  }

  Widget _getMainContentWidget(AuthenticationState state){
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _getField(_usernameController, 'Correo electrónico'),
            _getField(_passwordController, 'Contraseña'),
            _getField(_passwordConfirmController, 'Repite tu contraseña'),
            _getField(_firstName1Controller, 'Primer nombre'),
            _getField(_firstName2Controller, 'Segundo nombre (opcional)'),
            _getField(_lastName1Controller, 'Apellido paterno'),
            _getField(_lastName2Controller, 'Apellido materno'),
            _getField(_dateOfBirthController, 'Fecha de nacimiento'),

            RaisedButton(
              onPressed:
              state is! RegisterLoading ? _onRegisterButtonPressed : null,
              child: Text('Registrarme'),
            ),
            Container(
              child:
              state is RegisterLoading ? CircularProgressIndicator() : null,
            ),
            GestureDetector(
              onTap: _onGoLoginButtonPressed,
              child: Text(
                'Ya tengo cuenta',
                style: TextStyle(fontSize: 18.0, color: Colors.indigo, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onWillPop(){
    _authenticationBloc.dispatch(GoLoginButtonPressed());
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  //todo selector de fecha para día de nacimiento
  TextFormField _getField(TextEditingController controller, String hint){
    return TextFormField(
      decoration: InputDecoration(labelText: hint),
      controller: controller,
      obscureText: true,
      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
    );
  }

  _onRegisterButtonPressed() {

    if(_usernameController.text == null || _usernameController.text == ''){
      //todo validar email
      _showDialog('Escribe tu correo electrónico');
    } else if(_passwordController.text == null || _passwordController.text == ''){
      //todo establecer un formato
      _showDialog('Escribe tu contraseña');
    } else if(_passwordConfirmController.text != _passwordController.text){
      _showDialog('La contraseña y su confirmación no coinciden');
    } else if((_firstName1Controller.text == null || _firstName1Controller.text == '') &&
        (_firstName2Controller.text == null || _firstName2Controller.text == '')){
      _showDialog('Escribe tu nombre');
    } else if((_lastName1Controller.text == null || _lastName1Controller.text == '') &&
        (_lastName2Controller.text == null || _lastName2Controller.text == '')){
      _showDialog('Escribe al menos un apellido');
    } else if(_dateOfBirthController.text == null || _dateOfBirthController.text == ''){
      _showDialog('Escribe tu fecha de nacimiento');

    } else {
      String firstName1;
      String firstName2;
      String lastName1;
      String lastName2;

      if((_firstName1Controller.text != null || _firstName1Controller.text != '')){
        firstName1 = _firstName1Controller.text;
        if((_firstName2Controller.text != null || _firstName2Controller.text != '')){
          firstName2 = _firstName2Controller.text;
        } else {
          firstName2 = '';
        }
      } else {
        firstName1 = _firstName2Controller.text;
        firstName2 = '';
      }

      if((_lastName1Controller.text != null || _lastName1Controller.text != '')){
        lastName1 = _lastName2Controller.text;
        if((_lastName2Controller.text != null || _lastName2Controller.text != '')){
          lastName2 = _lastName2Controller.text;
        } else {
          lastName2 = '';
        }
      } else {
        lastName1 = _lastName2Controller.text;
        lastName2 = '';
      }

      Person person = Person(
          idCountry: 1,
          idLanguage: 1,
          firstName1: firstName1,
          firstName2: firstName2,
          lastName1: lastName1,
          lastName2: lastName2,
          birthDate: iso8601ToDateTime(_dateOfBirthController.text),
          genre: 'M',
          status: 0,
          email: _usernameController.text,
          password: _passwordController.text,
      );

      _authenticationBloc.dispatch(RegisterButtonPressed(
        person: person,
      ));
    }

  }

  void _onGoLoginButtonPressed(){
    _authenticationBloc.dispatch(GoLoginButtonPressed());

  }

  void _showDialog(String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //title: new Text("Alert Dialog title"),
          content: Text(text),
          actions: <Widget>[
            FlatButton(
              child: Text("Cerrar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}