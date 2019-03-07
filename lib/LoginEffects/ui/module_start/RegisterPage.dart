import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:learning_flutter/LoginEffects/bloc/module_start/exports.dart';
import 'RegisterForm.dart';

class RegisterPage extends StatefulWidget {
  final StartBloc startBloc;

  RegisterPage({@required this.startBloc}) : assert(startBloc != null);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
        title: Text('Registro'),
      ),
      body: RegisterForm(
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