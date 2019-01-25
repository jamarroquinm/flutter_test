import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

//Define los eventos que se pasarán a bloc
abstract class LoginEvent extends Equatable {
  LoginEvent([List props = const []]) : super(props);
}


//el único evento es el clic del botón, que notifica a bloc que deben validarse
//las credenciales introducidas por el usuario
class LoginButtonPressed extends LoginEvent {
  final String username;
  final String password;

  LoginButtonPressed({
    @required this.username,
    @required this.password,
  }) : super([username, password]);

  @override
  String toString() =>
      'LoginButtonPressed { username: $username, password: $password }';
}