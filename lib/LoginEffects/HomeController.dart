import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:learning_flutter/LoginEffects/bloc/exports.dart';
import 'package:learning_flutter/LoginEffects/bloc/module_home/exports.dart';
import 'ui/module_home/HomePage.dart';
import 'package:learning_flutter/LoginEffects/ui/ProgressDisplay.dart';

class HomeController extends StatefulWidget {
  final MainBloc mainBloc;

  HomeController({@required this.mainBloc}) :assert(mainBloc != null);

  @override
  _HomeControllerState createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  MainBloc _mainBloc;
  HomeBloc _homeBloc;

  @override
  void initState() {
    _mainBloc = widget.mainBloc;
    _homeBloc = HomeBloc(mainBloc: _mainBloc);
    _homeBloc.dispatch(HomeInitiate());
    super.initState();
  }

  @override
  void dispose() {
    _homeBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      bloc: _homeBloc,
      child: Container(
        child: BlocBuilder<HomeEvent, HomeState>(
          bloc: _homeBloc,
          builder: (BuildContext context, HomeState state) {
            print('homeController: ${state.toString()}');

            if (state is HomeUpdated) {
              return HomePage(homeBloc: _homeBloc, displaySharingAlert: false);

            } else if (state is Sharing) {
              return HomePage(homeBloc: _homeBloc, displaySharingAlert: true);

            } else if (state is HomeLoading) {
              return ProgressDisplay();

            } else {
              return ProgressDisplay();
            }

          },
        ),
      ),
    );
  }
}
