import 'package:equatable/equatable.dart';

abstract class StartState extends Equatable {
  StartState([List props = const []]) : super(props);
}

//state when lunch app; display splash
class StartInitial extends StartState {
  @override
  String toString() => 'StartInitial';
}

//state when user was authenticated; go to homepage
class UserAuthenticated extends StartState {
  @override
  String toString() => 'UserAuthenticated';
}

//state when user is not authenticated; remain in login page
class NoAuthenticated extends StartState {
  @override
  String toString() => 'NoAuthenticated';
}

//state when bloc is processing authentication; display progress indicator
class AuthenticationLoading extends StartState {
  @override
  String toString() => 'AuthenticationLoading';
}

//state when user is about to register; remain in register page
class NoUser extends StartState {
  @override
  String toString() => 'NoUser';
}