import 'package:flutter/material.dart';

import 'package:learning_flutter/LoginEffects/bloc/module_start/exports.dart';
import 'LoginForm.dart';

class LoginPage extends StatefulWidget {
  final StartBloc startBloc;

  LoginPage({@required this.startBloc}) : assert(startBloc != null);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthenticationBloc _authenticationBloc;
  StartBloc _startBloc;

  @override
  void initState() {
    _startBloc = widget.startBloc;
    _authenticationBloc = AuthenticationBloc(
      startBloc: _startBloc,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: LoginForm(
        authenticationBloc: _authenticationBloc,
      ),
    );
  }

  @override
  void dispose() {
    _authenticationBloc.dispose();
    super.dispose();
  }
}