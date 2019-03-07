import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:learning_flutter/LoginEffects/bloc/exports.dart';
import 'package:learning_flutter/LoginEffects/ui/ProgressDisplay.dart';
import 'HomeController.dart';
import 'PartnersController.dart';
import 'ServicesController.dart';
import 'StartController.dart';

class MainController extends StatefulWidget {
  @override
  State<MainController> createState() => _MainControllerState();
}

class _MainControllerState extends State<MainController> {
  MainBloc _mainBloc;

  @override
  void initState() {
    _mainBloc = MainBloc();
    _mainBloc.dispatch(StartingApp());
    super.initState();
  }

  @override
  void dispose() {
    _mainBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MainBloc>(
      bloc: _mainBloc,
      child: MaterialApp(
        home: BlocBuilder<MainEvent, MainState>(
          bloc: _mainBloc,
          builder: (BuildContext context, MainState state) {
            print('MainController: ${state.toString()}');

            if (state is NoModuleActivated) {
              return Container(child: Text('${state.toString()}'));
            }
            if (state is StartModuleActivated) {
              return StartController(mainBloc: _mainBloc);
            } else if (state is HomeModuleActivated) {
              return HomeController(mainBloc: _mainBloc);
            } else if (state is PartnerModuleActivated) {
              return PartnersController(mainBloc: _mainBloc, isEdition: true,);
            }else if (state is ServicesModuleActivated) {
              return ServicesController(mainBloc: _mainBloc);
            } else {
              return ProgressDisplay();
            }
          },
        ),
      ),
    );
  }
}