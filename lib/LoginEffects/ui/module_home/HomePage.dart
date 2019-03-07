import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:learning_flutter/LoginEffects/bloc/module_home/exports.dart';
import 'CategoryWidget.dart';
import 'DateLapseWidget.dart';
import 'MessageWidget.dart';
import 'PersonsWidget.dart';
import 'ServiceWidget.dart';

class HomePage extends StatefulWidget {
  final HomeBloc homeBloc;
  final bool displaySharingAlert;

  HomePage({@required this.homeBloc,
    this.displaySharingAlert = false}) : assert(homeBloc != null);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeBloc _homeBloc;
  HomeWidgetsBloc _homeWidgetsBloc;

  @override
  void initState() {
    _homeBloc = widget.homeBloc;
    _homeWidgetsBloc = HomeWidgetsBloc(homeBloc: _homeBloc);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeEvent, HomeState>(
      bloc: _homeBloc,
      builder: (BuildContext context, HomeState state,) {

        if (state is HomeFailure) {
          _onWidgetDidBuild(() {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          });
        } else  if(widget.displaySharingAlert){
          _onWidgetDidBuild(() {
            _showDialog('Share', 'Oopciones de redes sociales...');
          });
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('HomePage'),
          ),
          body: Column(
            children: <Widget>[
              PersonsWidget(homeWidgetsBloc: HomeWidgetsBloc(homeBloc: _homeBloc)),
              DataLapseWidget(homeWidgetsBloc: HomeWidgetsBloc(homeBloc: _homeBloc)),
              ServiceWidget(homeWidgetsBloc: HomeWidgetsBloc(homeBloc: _homeBloc)),
              MessageWidget(homeWidgetsBloc: HomeWidgetsBloc(homeBloc: _homeBloc)),
              CategoryWidget(homeWidgetsBloc: HomeWidgetsBloc(homeBloc: _homeBloc))
            ],
          ),
          drawer: _getMenu(),
        );

      },
    );
  }

  @override
  void dispose() {
    _homeWidgetsBloc.dispose();
    super.dispose();
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  Drawer _getMenu(){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Configuración'),
            onTap: _goSettings,
          ),
          ListTile(
            title: Text('Contactos y grupos'),
            onTap: _goPartners,
          ),
        ],
      ),
    );
  }

  _goSettings(){
    _showDialog('Configuración', 'Prueba para ir a la página de configuraciones');
  }

  _goPartners(){
    _showDialog('Contactos y grupos', 'Prueba para ir a la página de contactos y grupos');
  }

  void _showDialog(String title, String text) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Alert Dialog title"),
          content: Text("Alert Dialog body"),
          actions: <Widget>[
            FlatButton(
              child: Text("Cerrar"),
              onPressed: () {Navigator.of(context).pop();},
            ),
          ],
        );
      },
    );
  }
}