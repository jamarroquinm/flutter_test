import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:learning_flutter/LoginEffects/bloc/module_home/exports.dart';
import 'package:learning_flutter/LoginEffects/backend/GlobalData.dart';

class MessageWidget extends StatefulWidget {
  final HomeWidgetsBloc homeWidgetsBloc;

  MessageWidget({
    Key key,
    @required this.homeWidgetsBloc,
  }) : super(key: key);

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
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
              Container(
                child: Text(_getMessage()),
              ),
              Container(
                child: Center(
                    child: RaisedButton(
                      child: Text('Compartir'),
                      onPressed: _onShareButtonPressed,
                    )
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getMessage(){
    //todo tomarlo de appInstance

    return 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n'
        'In id dolor eget nibh tempor tristique id quis lorem.\n'
        'Pellentesque sit amet enim sagittis, tempor orci vitae,\n'
        'pellentesque leo.\n'
        'Donec auctor non lectus sit amet pharetra.\n'
        'Fusce rhoncus diam ut neque rutrum pellentesque.\n'
        'Aliquam auctor molestie erat in gravida.';
  }

  _onShareButtonPressed() {
    homeWidgetsBloc.dispatch(ShareButtonPressed());
  }
}
