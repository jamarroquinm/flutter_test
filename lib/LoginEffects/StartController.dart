import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:learning_flutter/LoginEffects/bloc/exports.dart';
import 'package:learning_flutter/LoginEffects/bloc/module_start/exports.dart';
import 'package:learning_flutter/LoginEffects/ui/module_start/exports.dart';

class StartController extends StatefulWidget {
  final MainBloc mainBloc;

  StartController({@required this.mainBloc}) :assert(mainBloc != null);

  @override
  State<StartController> createState() => _StartControllerState();
}

class _StartControllerState extends State<StartController> {
  MainBloc _mainBloc;
  StartBloc _startBloc;

  @override
  void initState() {
    _mainBloc = widget.mainBloc;
    _startBloc = StartBloc(mainBloc: _mainBloc);
    _startBloc.dispatch(AppStarted());
    super.initState();
  }

  @override
  void dispose() {
    _startBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StartEvent, StartState>(
      bloc: _startBloc,
      builder: (BuildContext context, StartState state) {
        print('StartController: ${state.toString()}');

        if (state is StartInitial) {
          return SplashPage();
        } else if (state is NoAuthenticated) {
          return LoginPage(startBloc: _startBloc);
        } else if (state is NoUser) {
          return RegisterPage(startBloc: _startBloc);
        } else if (state is AuthenticationLoading) {
          return ProgressDisplay();
        } else {
          return ProgressDisplay();
        }
      },
    );
  }
}