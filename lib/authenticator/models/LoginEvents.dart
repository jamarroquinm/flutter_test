import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

//Define los eventos que se pasarán a bloc
abstract class LoginEvent extends Equatable {
  LoginEvent([List props = const []]) : super(props);
}


//el único evento es el clic del botón, que notifica a bloc que deben validarse
//las credenciales introducidas por el usuario
class LoginButtonPressed extends LoginEvent {
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