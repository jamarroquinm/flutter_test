import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:learning_flutter/LoginEffects/bloc/exports.dart';
import 'package:learning_flutter/LoginEffects/bloc/module_services/exports.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final MainBloc mainBloc;

  ServiceBloc({@required this.mainBloc}) :
    assert(mainBloc != null);

  @override
  ServiceState get initialState => ServiceUninitialized();

  @override
  Stream<ServiceState> mapEventToState(
      ServiceState currentState,
      ServiceEvent event,
      ) async* {

      if(event is ServiceInitiating){
        yield ServiceLoading();
        yield ServiceInitial();
      }
  }
}