import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_flutter/authenticator/blocs/Exports.dart';
import 'package:learning_flutter/authenticator/models/Exports.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Person _person;

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _person = authenticationBloc.person;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 8.0, right: 8.0, bottom: 8.0, left: 8.0),
            child: Text(
              'Usuario: ${_person.names} ${_person.lastName1} ${_person.lastName1} ${_person.lastName2}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 8.0, right: 8.0, bottom: 20.0, left: 8.0),
            child: Text(
              'Token: ${_person.token} (actualizado: ${_person.tokenUpdate})',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            child: Center(
                child: RaisedButton(
                  child: Text('Logout'),
                  onPressed: () {
                    authenticationBloc.dispatch(LoggedOut());
                  },
                )),
          ),
        ],
      ),
    );
  }
}