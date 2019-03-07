import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import 'package:learning_flutter/LoginEffects/bloc/module_partners/exports.dart';
import 'package:learning_flutter/LoginEffects/backend/enums/exports.dart';
import 'package:learning_flutter/LoginEffects/model/exports.dart';

class GroupPage extends StatefulWidget {
  final PartnerBloc partnerBloc;
  final SubjectBase partner;

  GroupPage({@required this.partnerBloc, @required this.partner})
  : assert(partnerBloc != null);

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  PartnerBloc _partnerBloc;
  SubjectBase _partner;

  @override
  void initState() {
    _partnerBloc = widget.partnerBloc;
    _partner = widget.partner;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<PartnerEvent, PartnerState>(
      bloc: _partnerBloc,
      builder: (BuildContext context, PartnerState state,) {

        if (state is PartnerEditingFailure) {
          _onWidgetDidBuild(() {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.partner.message}'),
                backgroundColor: Colors.red,
              ),
            );
          });
        }

        return WillPopScope(
          child: _getMainContentWidget(),
          onWillPop: _onWillPop,
        );

      },
    );
  }

  Widget _getMainContentWidget(){
    return Container(
      child: Column(
        children: <Widget>[
          //todo construir formulario
          Text('Formulario de datos del grupo aquí...'),
          RaisedButton(
            child: Text('Grabar datos'),
            onPressed: _onPartnerSaveButtonPressed,
          ),
          RaisedButton(
            child: Text('Borrar grupo'),
            onPressed: _onPartnerDeleteButtonPressed,
          ),
          RaisedButton(
            child: Text('Voy a los contactos de este grupo'),
            onPressed: _onOpenMatcherButtonPressed,
          ),
          RaisedButton(
            child: Text('Salgo de esta pantalla'),
            onPressed: _onExitPartnerEditionButtonPressed,
          ),
        ],
      ),
    );
  }

  void _onWillPop(){
    _partnerBloc.dispatch(ExitPartnerEditionButtonPressed(currentType: PartnerType.group));
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  void _onPartnerSaveButtonPressed(){
    _partnerBloc.dispatch(PartnerSaveButtonPressed(partner: _getEditedItem(), currentType: PartnerType.group));
  }

  void _onPartnerDeleteButtonPressed(){
    _partnerBloc.dispatch(PartnerDeleteButtonPressed(partner: _partner, currentType: PartnerType.group));
  }

  void _onOpenMatcherButtonPressed(){
    _partnerBloc.dispatch(OpenMatcherButtonPressed(
      partnerId: _partner.serverId,
      partnerType: PartnerType.group,
      newMatchType: PartnerType.contact,
    ));
  }

  void _onExitPartnerEditionButtonPressed(){
    _partnerBloc.dispatch(ExitPartnerEditionButtonPressed(currentType: PartnerType.group));
  }

  SubjectBase _getEditedItem(){
    //todo construir objeto a partir de formulario
    return _partner;
  }
}
