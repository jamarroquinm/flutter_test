import 'package:bloc/bloc.dart';

import 'package:learning_flutter/LoginEffects/backend/exports.dart';
import 'package:learning_flutter/LoginEffects/bloc/MainEvents.dart';
import 'package:learning_flutter/LoginEffects/bloc/MainStates.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  @override
  MainState get initialState => NoModuleActivated();

  @override
  Stream<MainState> mapEventToState(
      MainState currentState,
      MainEvent event,
      ) async* {

    if (event is StartingApp || event is ActivatingStartModule) {
      await PersonHelper().logout();
      yield StartModuleActivated();
    } else if (event is ActivatingHomeModule) {
      yield HomeModuleActivated ();
    } else if (event is ActivatingPartnerModule) {
      yield PartnerModuleActivated(isEdition: event.isEdition);
    } else if(event is ActivatingServicesModule){
      yield ServicesModuleActivated();
    }
  }
}