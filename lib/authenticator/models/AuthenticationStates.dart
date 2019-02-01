import 'package:equatable/equatable.dart';

//aquí se definen los diferentes estados del proceso de autenticación
abstract class AuthenticationState extends Equatable {}

class AuthenticationUninitialized extends AuthenticationState {
  //busca si el usuario está autenticado o no al inicio de la app
  //podría presentarse un splash al usuario
  @override
  String toString() => 'AuthenticationUninitialized';
}

class AuthenticationAuthenticated extends AuthenticationState {
  //autenticado exitosamente
  //el usuario entraría al resto de las pantallas
  @override
  String toString() => 'AuthenticationAuthenticated';
}

class AuthenticationUnauthenticated extends AuthenticationState {
  //no autenticado
  //el usuario volvería a la pantalla del login
  @override
  String toString() => 'AuthenticationUnauthenticated';
}

class AuthenticationLoading extends AuthenticationState {
  //espera para conservar o eliminar el token
  //podría mostrarse un indicador de avance
  @override
  String toString() => 'AuthenticationLoading';
}