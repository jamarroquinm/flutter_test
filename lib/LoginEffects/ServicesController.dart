import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:learning_flutter/LoginEffects/bloc/exports.dart';
import 'package:learning_flutter/LoginEffects/bloc/module_services/exports.dart';
import 'package:learning_flutter/LoginEffects/ui/ProgressDisplay.dart';
import 'package:learning_flutter/LoginEffects/ui/module_services/ServicePage.dart';

class ServicesController extends StatefulWidget {
  final MainBloc mainBloc;

  ServicesController({@required this.mainBloc}) :assert(mainBloc != null);

  @override
  State<ServicesController> createState() => _ServicesControllerState();
}

class _ServicesControllerState extends State<ServicesController> {
  MainBloc _mainBloc;
  ServiceBloc _serviceBloc;

  @override
  void initState() {
    _mainBloc = widget.mainBloc;
    _serviceBloc = ServiceBloc(mainBloc: _mainBloc);
    _serviceBloc.dispatch(ServiceInitiating());
    super.initState();
  }

  @override
  void dispose() {
    _serviceBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceEvent, ServiceState>(
      bloc: _serviceBloc,
      builder: (BuildContext context, ServiceState state) {
        print('ServicesController: ${state.toString()}');

        if (state is ServiceInitial) {
          return ServicePage(serviceBloc: _serviceBloc,);
        } else if (state is ServiceLoading) {
          return ProgressDisplay();
        } else {
          return ProgressDisplay();
        }
      },
    );
  }
}