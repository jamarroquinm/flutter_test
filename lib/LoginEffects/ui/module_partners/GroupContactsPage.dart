import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import 'package:learning_flutter/LoginEffects/bloc/module_partners/exports.dart';
import 'package:learning_flutter/LoginEffects/backend/enums/exports.dart';
import 'package:learning_flutter/LoginEffects/model/exports.dart';

class GroupContactsPage extends StatefulWidget {
  final PartnerBloc partnerBloc;
  final SubjectBase partner;
  final PartnerType newMatchType;

  GroupContactsPage({@required this.partnerBloc, @required this.partner,
    @required this.newMatchType}) : assert(partnerBloc != null);

  @override
  _GroupContactsPage createState() => _GroupContactsPage();
}

class _GroupContactsPage extends State<GroupContactsPage> {
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

        if (state is MatcherEditingFailure) {
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
          Text('Datos del grupo...'),
          Text('Lista de contactos; con checkbox=checked para indicar que ya pertenece...'),
          RaisedButton(
            child: Text('Agrego contacto a grupo'),
            onPressed: () { _partnerBloc.dispatch(
                MatchButtonPressed(groupContact: _getNewItem('1'), editingType: PartnerType.group));
            },
          ),
          RaisedButton(
            child: Text('Quito contacto de grupo'),
            onPressed: () { _partnerBloc.dispatch(
                RemoveMatchButtonPressed(groupContact: _getNewItem('1'), editingType: PartnerType.group));
            },
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
    _partnerBloc.dispatch(ExitMatcherButtonPressed(partnerId: partner.serverId, type: PartnerType.group));
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  void _onExitPartnerEditionButtonPressed(){
    _partnerBloc.dispatch(ExitMatcherButtonPressed(partnerId: _partner.serverId, type: PartnerType.group));
  }

  GroupContact _getNewItem(String selectedItemId){
    //todo construir objeto a partir de selección
    return GroupContact(idGroup: _partner.serverId, idContact: selectedItemId);
  }

  SubjectBase get partner => _partner;
}
