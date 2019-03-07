import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:learning_flutter/LoginEffects/backend/exports.dart';
import 'package:learning_flutter/LoginEffects/model/exports.dart';
import 'package:learning_flutter/LoginEffects/backend/GlobalData.dart';

import 'package:learning_flutter/LoginEffects/bloc/exports.dart';
import 'package:learning_flutter/LoginEffects/bloc/module_start/StartEvents.dart';
import 'package:learning_flutter/LoginEffects/bloc/module_start/StartStates.dart';

class StartBloc extends Bloc<StartEvent, StartState> {
  final MainBloc mainBloc;

  StartBloc({
    @required this.mainBloc,
  })  : assert(mainBloc != null);


  @override
  StartState get initialState => StartInitial();

  @override
  Stream<StartState> mapEventToState(
      StartState currentState,
      StartEvent event,
      ) async* {

    if (event is AppStarted) {
      if(appInstance.appStarted){
        yield AuthenticationLoading();
      } else {
        yield StartInitial();
        appInstance.startApp();
        await Future.delayed(Duration(seconds: 2));
      }

      final Person varPerson = await PersonHelper().getItemFromRepository();
      appInstance.updateUser(varPerson);

      if (existRegister(varPerson)) {
        mainBloc.dispatch(ActivatingHomeModule());
        yield UserAuthenticated();
      } else {
        yield NoAuthenticated();
      }

    } else if (event is LoggedIn) {
      yield AuthenticationLoading();
      mainBloc.dispatch(ActivatingHomeModule());
      yield UserAuthenticated();

    } else if (event is LoggedOut || event is LoginInitiated) {
      yield AuthenticationLoading();
      appInstance.updateUser(Person(), true);
      yield NoAuthenticated();

    } else if(event is RegisterInitiated){
      yield AuthenticationLoading();
      appInstance.updateUser(Person());
      yield NoUser();

    }
  }
}