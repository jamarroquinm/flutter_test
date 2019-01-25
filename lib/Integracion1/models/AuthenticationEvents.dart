import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  AuthenticationEvent([List props = const []]) : super(props);
}

//Se dispara al iniciarse la app para notificar a bloc que debe verificarse
// si hay un usuario autenticado
class AppStarted extends AuthenticationEvent {
  @override
  String toString() => 'AppStarted';
}


//Se dispara cuando la autenticación ha sido exitosa para notificar a bloc que
// el usuario está autenticado
class LoggedIn extends AuthenticationEvent {
  final String token;

  LoggedIn({@required this.token}) : super([token]);

  @override
  String toString() => 'LoggedIn { token: $token }';
}


//Se dispara cuando el logout ha sido exitoso para notificar a bloc que
// el usuario ya no está autenticado
class LoggedOut extends AuthenticationEvent {
  @override
  String toString() => 'LoggedOut';
}