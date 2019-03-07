import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:learning_flutter/LoginEffects/backend/exports.dart';
import 'package:learning_flutter/LoginEffects/model/exports.dart';
import 'package:learning_flutter/LoginEffects/backend/GlobalData.dart';

import 'package:learning_flutter/LoginEffects/bloc/module_start/StartBloc.dart';
import 'package:learning_flutter/LoginEffects/bloc/module_start/StartEvents.dart';
import 'package:learning_flutter/LoginEffects/bloc/module_start/AuthenticationEvents.dart';
import 'package:learning_flutter/LoginEffects/bloc/module_start/AuthenticationStates.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final StartBloc startBloc;

  AuthenticationBloc({
    @required this.startBloc,
  })  : assert(startBloc != null);

  @override
  AuthenticationState get initialState => LoginInitial();

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationState currentState,
      AuthenticationEvent event) async* {

    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        final Person varPerson = await PersonHelper().getItem(
            userName: event.userName,
            password: event.password
        );

        if(existRegister(varPerson)){
          appInstance.updateUser(varPerson);
          startBloc.dispatch(LoggedIn());
          yield LoginInitial();
        } else {
          yield LoginFailure(error: varPerson.message);
        }

      } catch (error) {
        yield LoginFailure(error: error.toString());
        print(error.toString());
      }


    } else if(event is GoRegisterButtonPressed){
      yield LoginLoading();
      startBloc.dispatch(RegisterInitiated());
      yield RegisterInitial();


    } else  if (event is RegisterButtonPressed) {
      yield RegisterLoading();

      try {
        final Person varPerson = await PersonHelper().addUpload(event.person);

        if(existRegister(varPerson)){
          appInstance.updateUser(varPerson);
          startBloc.dispatch(LoggedIn());
          yield RegisterInitial();
        } else {
          yield RegisterFailure(error: varPerson.message);
        }

      } catch (error) {
        yield RegisterFailure(error: error.toString());
        print(error.toString());
      }


    } else if(event is GoLoginButtonPressed || event is BackButtonPressed){
      yield RegisterLoading();
      startBloc.dispatch(LoginInitiated());
      yield LoginInitial();
    }

  }
}