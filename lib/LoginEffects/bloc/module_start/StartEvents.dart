import 'package:equatable/equatable.dart';
import 'package:learning_flutter/LoginEffects/backend/GlobalData.dart';

abstract class StartEvent extends Equatable {
  StartEvent([List props = const []]) : super(props);
}

//command bloc to verify if there is an authenticated user on opening app
class AppStarted extends StartEvent {
  @override
  String toString() => 'AppStarted';
}


//When authentication was a success command the bloc to notify authentication
class LoggedIn extends StartEvent {
  @override
  String toString() => 'LoggedIn { ${appInstance.user.toString()} }';
}


//When logout was a success command the bloc to notify user is no longer authenticated
class LoggedOut extends StartEvent {
  @override
  String toString() => 'LoggedOut';
}


//User choose to register then the bloc notify that register page must be opened
class RegisterInitiated extends StartEvent {
  @override
  String toString() => 'RegisterInitiated';
}


//User choose to back to login then the bloc notify that login page must be opened
class LoginInitiated extends StartEvent {
  @override
  String toString() => 'LoginInitiated';
}