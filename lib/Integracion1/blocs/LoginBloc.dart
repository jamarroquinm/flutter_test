import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:learning_flutter/Integracion1/models/authentication.dart';
import 'package:learning_flutter/Integracion1/models/login_model.dart';
import 'package:learning_flutter/Integracion1/blocs/AuthenticationBloc.dart';


//la clase tiene una dependencia de UserRepository, para llevar a cabo la
//autenticación del usuario, y de AuthenticationBloc, para que se actualice el
//AuthenticationState cuando el usuario introduzca credenciales válidas
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.userRepository,
    @required this.authenticationBloc,
  })  : assert(userRepository != null),
        assert(authenticationBloc != null);

  @override
  LoginState get initialState => LoginInitial();

  //aquí es donde bloc convierte los eventos entrantes en estados que consumirá
  //la UI
  @override
  Stream<LoginState> mapEventToState(
      LoginState currentState,
      LoginEvent event,
      ) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        final token = await userRepository.authenticate(
          username: event.username,
          password: event.password,
        );

        authenticationBloc.dispatch(LoggedIn(token: token));
        yield LoginInitial();
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
}