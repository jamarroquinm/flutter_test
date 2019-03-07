import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:learning_flutter/LoginEffects/model/exports.dart';

abstract class AuthenticationEvent extends Equatable {
  AuthenticationEvent([List props = const []]) : super(props);
}


class LoginButtonPressed extends AuthenticationEvent {
  final String userName;
  final String password;

  LoginButtonPressed({
    @required this.userName,
    @required this.password,
  }) : super([userName, password]);

  @override
  String toString() =>
      'LoginButtonPressed { username: $userName, password: $password }';
}


class GoRegisterButtonPressed extends AuthenticationEvent{
  @override
  String toString() => 'GoRegisterButtonPressed';
}


class RegisterButtonPressed extends AuthenticationEvent {
  final Person person;

  RegisterButtonPressed({
    @required this.person,
  }) : super([person]);

  @override
  String toString() =>
      'RegisterButtonPressed { ${person.toString()} }';
}


class GoLoginButtonPressed extends AuthenticationEvent{
  @override
  String toString() => 'LoginButtonPressed';
}


class BackButtonPressed extends AuthenticationEvent{
  @override
  String toString() => 'BackButtonPressed';
}