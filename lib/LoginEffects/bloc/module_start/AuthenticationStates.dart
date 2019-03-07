import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  AuthenticationState([List props = const []]) : super(props);
}


//Transitions state
class LoginInitial extends AuthenticationState {
  @override
  String toString() => 'LoginInitial';
}


//processing authentication
class LoginLoading extends AuthenticationState {
  @override
  String toString() => 'LoginLoading';
}


//authentication was not success
class LoginFailure extends AuthenticationState {
  final String error;

  LoginFailure({@required this.error}) : super([error]);

  @override
  String toString() => 'LoginFailure { error: $error }';
}


//login form initial state
class RegisterInitial extends AuthenticationState {
  @override
  String toString() => 'RegisterInitial';
}


//processing authentication
class RegisterLoading extends AuthenticationState {
  @override
  String toString() => 'RegisterLoading';
}


//authentication was not success
class RegisterFailure extends AuthenticationState {
  final String error;

  RegisterFailure({@required this.error}) : super([error]);

  @override
  String toString() => 'RegisterFailure { error: $error }';
}


//todo implementar
class RegisterFieldValidated extends AuthenticationState {
  final String message;
  final bool isValid;

  RegisterFieldValidated({@required this.message, @required this.isValid})
      : super([message, isValid]);

  @override
  String toString() => 'RegisterFieldValidated { mensaje: $message; ¿válido? ${isValid ? "sí" : "no"} }';
}