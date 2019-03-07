import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:learning_flutter/LoginEffects/backend/exports.dart';
import 'package:learning_flutter/LoginEffects/backend/enums/exports.dart';
import 'package:learning_flutter/LoginEffects/bloc/module_home/exports.dart';
import 'package:learning_flutter/LoginEffects/backend/GlobalData.dart';

//todo cambiar los botones backward y forward por swipe
class DataLapseWidget extends StatefulWidget {
  final HomeWidgetsBloc homeWidgetsBloc;

  DataLapseWidget({
    Key key,
    @required this.homeWidgetsBloc,
  }) : super(key: key);

  @override
  _DataLapseWidgetState createState() => _DataLapseWidgetState();
}

class _DataLapseWidgetState extends State<DataLapseWidget> {
  HomeWidgetsBloc get homeWidgetsBloc => widget.homeWidgetsBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeWidgetsEvent, HomeWidgetsState>(
      bloc: homeWidgetsBloc,
      builder: (
          BuildContext context,
          HomeWidgetsState state,
          ) {

        return Container(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    child: Center(
                        child: RaisedButton(
                          child: Text('Día'),
                          onPressed: _enableLapseButton(Lapse.day)
                              ? _onChangeToDayLapseButtonPressed
                              : null,
                        )),
                  ),
                  Container(
                    child: Center(
                        child: RaisedButton(
                          child: Text('Semana'),
                          onPressed: _enableLapseButton(Lapse.week)
                              ? _onChangeToWeekLapseButtonPressed
                              : null,
                        )),
                  ),
                  Container(
                    child: Center(
                        child: RaisedButton(
                          child: Text('Mes'),
                          onPressed: _enableLapseButton(Lapse.month)
                              ? _onChangeToMonthLapseButtonPressed
                              : null,
                        )),
                  ),
                  Container(
                    child: Center(
                        child: RaisedButton(
                          child: Text('Año'),
                          onPressed: _enableLapseButton(Lapse.year)
                              ? _onChangeToYearLapseButtonPressed
                              : null,
                        )),
                  ),
                ],
              ),
              Row(children: <Widget>[
                Container(
                  child: Center(
                      child: RaisedButton(
                        child: Text('<<', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),),
                        onPressed: _enableMovementButton(false) ? _onBackwardButtonPressed : null,
                      )),
                ),

                _getCard(),

                Container(
                  child: Center(
                      child: RaisedButton(
                        child: Text('>>', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),),
                        onPressed: _enableMovementButton(true) ? _onForwardButtonPressed : null,
                      )),
                ),
                ]
              ),
            ],
          ),
        );
      },
    );
  }

  Card _getCard(){
    String text;
    String supraText;

    if(appInstance.dateLapse.lapse == Lapse.day){
      supraText = null;
      text = dateTimeToLongString(appInstance.dateLapse.day);
    } else if(appInstance.dateLapse.lapse == Lapse.week){
      supraText = 'Week ${appInstance.dateLapse.weekNumber}';
      text = lapseToLongString(appInstance.dateLapse.initialDay, appInstance.dateLapse.finalDay);
    } else if(appInstance.dateLapse.lapse == Lapse.month){
      supraText = null;
      text = monthToLongString(appInstance.dateLapse.day);
    } else {
      supraText = null;
      text = '${appInstance.dateLapse.day.year}';
    }

    Text textWidget = Text(text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0));
    Text supraTextWidget;
    if(supraText == null){
      supraTextWidget = null;
    } else {
      supraTextWidget = Text(supraText, style: TextStyle(fontSize: 16.0));
    }

    if(supraTextWidget == null){
      return Card(child: Column(children: <Widget>[textWidget]));
    } else {
      return Card(child: Column(children: <Widget>[supraTextWidget, textWidget]));
    }
  }

  bool _enableLapseButton(Lapse buttonLapse){
    if(appInstance.dateLapse == null){
      return false;
    } else {
      return buttonLapse != appInstance.dateLapse.lapse;
    }
  }

  bool _enableMovementButton(bool buttonIsForward){
    if(buttonIsForward){
      return !appInstance.dateLapse.isLastLapseInYear;
    } else {
      return !appInstance.dateLapse.isFirstLapseInYear;
    }
  }

  _onForwardButtonPressed() {
    if((appInstance.dateLapse.lapse == Lapse.year && appInstance.dateLapse.canChangeYear) ||
        (appInstance.dateLapse.lapse != Lapse.year &&
            (!appInstance.dateLapse.isLastLapseInYear || appInstance.dateLapse.canChangeYear))){
      homeWidgetsBloc.dispatch(ForwardButtonPressed());
    }
  }

  _onBackwardButtonPressed() {
    if((appInstance.dateLapse.lapse == Lapse.year && appInstance.dateLapse.canChangeYear) ||
        (appInstance.dateLapse.lapse != Lapse.year &&
            (!appInstance.dateLapse.isFirstLapseInYear || appInstance.dateLapse.canChangeYear))){
    }
    homeWidgetsBloc.dispatch(BackwardButtonPressed());
  }

  _onChangeToDayLapseButtonPressed() {
    if(appInstance.dateLapse.lapse != Lapse.day){
      homeWidgetsBloc.dispatch(ChangeLapseButtonPressed(lapse: Lapse.day));
    }
  }

  _onChangeToWeekLapseButtonPressed() {
    if(appInstance.dateLapse.lapse != Lapse.week){
      homeWidgetsBloc.dispatch(ChangeLapseButtonPressed(lapse: Lapse.week));
    }
  }

  _onChangeToMonthLapseButtonPressed() {
    if(appInstance.dateLapse.lapse != Lapse.month){
      homeWidgetsBloc.dispatch(ChangeLapseButtonPressed(lapse: Lapse.month));
    }
  }

  _onChangeToYearLapseButtonPressed() {
    if(appInstance.dateLapse.lapse != Lapse.year){
      homeWidgetsBloc.dispatch(ChangeLapseButtonPressed(lapse: Lapse.year));
    }
  }
}
