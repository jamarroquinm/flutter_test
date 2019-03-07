import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:learning_flutter/LoginEffects/backend/GlobalData.dart';
import 'package:learning_flutter/LoginEffects/bloc/exports.dart';
import 'package:learning_flutter/LoginEffects/bloc/module_home/HomeEvents.dart';
import 'package:learning_flutter/LoginEffects/bloc/module_home/HomeStates.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final MainBloc mainBloc;

  HomeBloc({
    @required this.mainBloc,
  })  : assert(mainBloc != null);

  @override
  HomeState get initialState => HomeUninitialized();

  @override
  Stream<HomeState> mapEventToState(
      HomeState currentState,
      HomeEvent event,
      ) async* {

    if (event is HomeInitiate) {
      yield HomeLoading();
      if(!appInstance.dataInitialized){
        appInstance.initializeData();
      }
      yield HomeUpdated();

    } else if (event is HomeUpdate) {
      yield HomeLoading();
      yield HomeUpdated();

    } else if (event is AddPartner) {
      yield HomeLoading();
      mainBloc.dispatch(ActivatingPartnerModule(isEdition: true));
      yield AddingPartner();

    } else if(event is Share){
      yield HomeLoading();
      yield Sharing();

    } else if(event is HomeExit){
      yield HomeLoading();
      //todo parámetro para saber a dónde ir de aquí
      mainBloc.dispatch(ActivatingStartModule());
      yield HomeExiting(route: event.route);

    } else if(event is HomeFailing){
      yield HomeLoading();
      yield HomeFailure(error: event.error);

    } else if(event is HomeLoggingOut){
      yield HomeLoading();
      mainBloc.dispatch(ActivatingStartModule());
      yield HomeLogout();

    }
  }
}