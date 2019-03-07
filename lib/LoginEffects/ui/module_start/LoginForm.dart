import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:learning_flutter/LoginEffects/bloc/module_start/exports.dart';

class LoginForm extends StatefulWidget {
  final AuthenticationBloc authenticationBloc;

  LoginForm({
    Key key,
    @required this.authenticationBloc,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  AuthenticationBloc get _authenticationBloc => widget.authenticationBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationEvent, AuthenticationState>(
      bloc: _authenticationBloc,
      builder: (
          BuildContext context,
          AuthenticationState state,
          ) {
        if (state is LoginFailure) {
          _onWidgetDidBuild(() {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          });
        }

        return Form(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'username'),
                  controller: _usernameController,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'password'),
                  controller: _passwordController,
                  obscureText: true,
                ),
                RaisedButton(
                  onPressed:
                  state is! LoginLoading ? _onLoginButtonPressed : null,
                  child: Text('Login'),
                ),
                Container(
                  child:
                  state is LoginLoading ? CircularProgressIndicator() : null,
                ),
                GestureDetector(
                  onTap: _onGoRegisterButtonPressed,
                  child: Text(
                    'Registrarme',
                    style: TextStyle(fontSize: 18.0, color: Colors.indigo, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  _onLoginButtonPressed() {
    String userName = _usernameController.text;
    String password = _passwordController.text;

    if(userName == null || userName == ''){
      _showDialog('Escribe tu nombre de usuario');
    } else if(password == null || password == ''){
      _showDialog('Escribe tu contraseña');
    } else {
      _authenticationBloc.dispatch(LoginButtonPressed(
        userName: _usernameController.text,
        password: _passwordController.text,
      ));
    }
  }

  void _onGoRegisterButtonPressed(){
    _authenticationBloc.dispatch(GoRegisterButtonPressed());

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