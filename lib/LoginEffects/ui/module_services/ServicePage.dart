import 'package:flutter/material.dart';

import 'package:learning_flutter/LoginEffects/bloc/module_services/exports.dart';

class ServicePage extends StatefulWidget {
  final ServiceBloc serviceBloc;

  ServicePage({@required this.serviceBloc}) : assert(serviceBloc != null);

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Servicios'),
      ),
      body: Text('Una página con servicios...'),
    );
  }
}