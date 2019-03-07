import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:learning_flutter/LoginEffects/bloc/module_partners/exports.dart';
import 'package:learning_flutter/LoginEffects/backend/enums/exports.dart';

class GroupsPage extends StatefulWidget {
  final PartnerBloc partnerBloc;

  GroupsPage({@required this.partnerBloc}) : assert(partnerBloc != null);

  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  PartnerBloc _partnerBloc;

  @override
  void initState() {
    _partnerBloc = widget.partnerBloc;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PartnerEvent, PartnerState>(
      bloc: _partnerBloc,
      builder: (BuildContext context, PartnerState state,) {
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
          //todo construir lista y menú de esta página
          Text('Lista de grupos aqui...'),
          RaisedButton(
            child: Text('Elijo un gruṕo'),
            onPressed: () { _partnerBloc.dispatch(
                PartnerListItemSelected(partnerId: '1', type: PartnerType.group));
            },
          ),
          RaisedButton(
            child: Text('Agrego un grupo'),
            onPressed: () { _partnerBloc.dispatch(
                PartnerListItemSelected(partnerId: '', type: PartnerType.group));
            },
          ),
          RaisedButton(
              child: Text('Salgo de esta pantalla'),
              onPressed: () {
                _partnerBloc.dispatch(
                    ExitPartnersListButtonPressed(currentType: PartnerType.group));
              }
          ),
          RaisedButton(
              child: Text('Voy a lista de grupos'),
              onPressed: () {
                _partnerBloc.dispatch(
                    ChangePartnerPageButtonPressed(currentType: PartnerType.group, newType: PartnerType.contact));
              }
          ),
        ],
      ),
    );
  }

  void _onWillPop(){
    _partnerBloc.dispatch(ExitPartnersListButtonPressed(currentType: PartnerType.group));
  }
}
