import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:learning_flutter/LoginEffects/backend/enums/exports.dart';
import 'package:learning_flutter/LoginEffects/backend/exports.dart';
import 'package:learning_flutter/LoginEffects/backend/GlobalData.dart';

import 'package:learning_flutter/LoginEffects/bloc/module_home/HomeBloc.dart';
import 'package:learning_flutter/LoginEffects/bloc/module_home/HomeEvents.dart';
import 'package:learning_flutter/LoginEffects/bloc/module_home/HomeWidgetsEvents.dart';
import 'package:learning_flutter/LoginEffects/bloc/module_home/HomeWidgetsStates.dart';

class HomeWidgetsBloc extends Bloc<HomeWidgetsEvent, HomeWidgetsState> {
  final HomeBloc homeBloc;

  HomeWidgetsBloc({
    @required this.homeBloc,
  })  : assert(homeBloc != null);

  @override
  HomeWidgetsState get initialState => HomeWidgetInitial();

  @override
  Stream<HomeWidgetsState> mapEventToState(
      HomeWidgetsState currentState,
      HomeWidgetsEvent event,
      ) async* {

    if (event is ChangeCategoryButtonPressed) {
      yield HomeWidgetLoading();
      appInstance.updateCategory(event.category);
      homeBloc.dispatch(HomeUpdate());
      yield HomeWidgetInitial();


    } else if (event is AddPartnerButtonPressed) {
      yield HomeWidgetLoading();
      homeBloc.dispatch(AddPartner());
      yield HomeWidgetInitial();


    } else if (event is RemovePartnerButtonPressed) {
      yield HomeWidgetLoading();
      appInstance.updatePartner(null);
      homeBloc.dispatch(HomeUpdate());
      yield HomeWidgetInitial();

      
    } else  if (event is ForwardButtonPressed) {
      yield HomeWidgetLoading();

      DateLapse newDateLapse = DateLapse.calculateNextDateLapse(appInstance.dateLapse);

      if(newDateLapse == null){
        String error = "Can't go forward";
        homeBloc.dispatch(HomeFailing(error: error));
        yield HomeWidgetFailure(error: error);
      } else {
        appInstance.updateDataLapse(newDateLapse);
        homeBloc.dispatch(HomeUpdate());
        yield HomeWidgetInitial();
      }


    } else if (event is BackwardButtonPressed) {
      yield HomeWidgetLoading();

      DateLapse newDateLapse = DateLapse.calculatePreviousDateLapse(appInstance.dateLapse);

      if(newDateLapse == null){
        String error = "Can't go backward";
        homeBloc.dispatch(HomeFailing(error: error));
        yield HomeWidgetFailure(error: error);
      } else {
        appInstance.updateDataLapse(newDateLapse);
        homeBloc.dispatch(HomeUpdate());
        yield HomeWidgetInitial();
      }


    } else if (event is ChangeLapseButtonPressed) {
      yield HomeWidgetLoading();

      Lapse newLapse = event.lapse;
      DateTime originDate = appInstance.dateLapse.day;
      bool canChangeYear = appInstance.dateLapse.canChangeYear;
      DateLapse newDateLapse = DateLapse.fromDate(originDate, newLapse, canChangeYear);

      if(newDateLapse == null){
        String error = "Couldn't change lapse";
        homeBloc.dispatch(HomeFailing(error: error));
        yield HomeWidgetFailure(error: error);
      } else {
        appInstance.updateDataLapse(newDateLapse);
        homeBloc.dispatch(HomeUpdate());
        yield HomeWidgetInitial();
      }


    } else if (event is ChangeServiceButtonPressed) {
      yield HomeWidgetLoading();

      DateLapse newDataLapse = DateLapse.fromDate(appInstance.dateLapse.day,
          appInstance.dateLapse.lapse,
          !event.isEnergy);

      appInstance.updateIsEnergy(event.isEnergy);
      appInstance.updateDataLapse(newDataLapse);
      homeBloc.dispatch(HomeUpdate());
      yield HomeWidgetInitial();


    } else if (event is ShareButtonPressed) {
      yield HomeWidgetLoading();
      homeBloc.dispatch(Share());
      yield HomeWidgetInitial();

    }
  }
}