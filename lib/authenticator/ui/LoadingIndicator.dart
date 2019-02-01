import 'package:flutter/material.dart';

//Muestra el avance del proceso
class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
    child: CircularProgressIndicator(),
  );
}