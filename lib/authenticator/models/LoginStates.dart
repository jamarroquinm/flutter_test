import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

//para manejar los estados del formulario de autenticación
abstract class LoginState extends Equatable {
  LoginState([List props = const []]) : super(props);
}


//estado inicial del formulario
class LoginInitial extends LoginState {
  @override
  String toString() => 'LoginInitial';
}


//validación en curso de las credenciales del usuario
class LoginLoading extends LoginState {
  @override
  String toString() => 'LoginLoading';
}


//validación fallida
class LoginFailure extends LoginState {
  final String error;

  LoginFailure({@required this.error}) : super([error]);

  @override
  String toString() => 'LoginFailure { error: $error }';
}