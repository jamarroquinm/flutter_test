import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:learning_flutter/authenticator/backend/Exports.dart';
import 'package:learning_flutter/authenticator/models/Exports.dart';
import 'AuthenticationBloc.dart';


//la clase tiene una dependencia de AuthenticationBloc para que se actualice el
//AuthenticationState cuando el usuario introduzca credenciales válidas
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationBloc authenticationBloc;

  Person _person;

  LoginBloc({
    @required this.authenticationBloc,
  })  : assert(authenticationBloc != null);

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginState currentState,
                                     LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        final Person varPerson = await PersonHelper().getItem(
            login: event.login,
            password: event.password
        );

        _person = varPerson;

        if(varPerson != null && varPerson.id > 0){
          authenticationBloc.dispatch(LoggedIn(person: varPerson));
          yield LoginInitial();
        } else {
          yield LoginFailure(error: 'Credentials not valid');
        }

      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }

  Person get person => _person;
}