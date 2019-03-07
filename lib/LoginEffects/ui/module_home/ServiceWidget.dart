import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:learning_flutter/LoginEffects/bloc/module_home/exports.dart';
import 'package:learning_flutter/LoginEffects/backend/GlobalData.dart';

class ServiceWidget extends StatefulWidget {
  final HomeWidgetsBloc homeWidgetsBloc;

  ServiceWidget({
    Key key,
    @required this.homeWidgetsBloc,
  }) : super(key: key);

  @override
  _ServiceWidgetState createState() => _ServiceWidgetState();
}

class _ServiceWidgetState extends State<ServiceWidget> {
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
          child: Row(
            children: <Widget>[
              Container(
                child: Center(
                    child: RaisedButton(
                      child: Text('Energía'),
                      onPressed: !appInstance.isEnergy ? _onToggleServiceButtonPressed : null,
                    )
                ),
              ),
              Container(
                child: Center(
                    child: RaisedButton(
                      child: Text('Pronósticos'),
                      onPressed: appInstance.isEnergy ? _onToggleServiceButtonPressed : null,
                    )
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _onToggleServiceButtonPressed() {
    homeWidgetsBloc.dispatch(ChangeServiceButtonPressed(isEnergy: !appInstance.isEnergy));
  }
}
