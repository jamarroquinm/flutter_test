import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:learning_flutter/LoginEffects/bloc/module_partners/exports.dart';
import 'package:learning_flutter/LoginEffects/backend/enums/exports.dart';

class ContactsPage extends StatefulWidget {
  final PartnerBloc partnerBloc;

  ContactsPage({@required this.partnerBloc}) : assert(partnerBloc != null);

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
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
          Text('Lista de contactos aqui...'),
          RaisedButton(
            child: Text('Elijo un contacto'),
            onPressed: () { _partnerBloc.dispatch(
                PartnerListItemSelected(partnerId: '1', type: PartnerType.contact));
            },
          ),
          RaisedButton(
            child: Text('Agrego un contacto'),
            onPressed: () { _partnerBloc.dispatch(
                PartnerListItemSelected(partnerId: '', type: PartnerType.contact));
            },
          ),
          RaisedButton(
              child: Text('Salgo de esta pantalla'),
              onPressed: () {
                _partnerBloc.dispatch(
                    ExitPartnersListButtonPressed(currentType: PartnerType.contact));
              }
          ),
          RaisedButton(
              child: Text('Voy a lista de grupos'),
              onPressed: () {
                _partnerBloc.dispatch(
                    ChangePartnerPageButtonPressed(currentType: PartnerType.contact, newType: PartnerType.group));
              }
          ),
        ],
      ),
    );
  }

  void _onWillPop(){
    _partnerBloc.dispatch(ExitPartnersListButtonPressed(currentType: PartnerType.contact));
  }
}
