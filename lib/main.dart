import 'package:flutter/material.dart';
import 'StartupNamer.dart';
import 'LayoutsBuilder.dart';
import 'BasicNavigation.dart';
import 'NavigationTree.dart';
import 'SimpleWebServiceInvoker.dart';

//Primer ejercicio de aprendizaje: lista infinita de nombres seleccionables
//void main() => runApp(StartupNamerApp());


//Construcción de un layout básico
//void main() => runApp(LayoutsBuilderApp());


//Navegación básica entre dos pantallas
/*
void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: FirstRoute(),
  ));
}
*/


//Navegación en un árbol de pantallas
/*
void main() {
  runApp(MaterialApp(
    title: 'Navigation experiments',
    //home: FirstRoute(),  //no incluir home cuando hay named routes
    routes: {
      '/': (context) => Login(),
      '/homepage': (context) => HomePage(),
      '/section1': (context) => Section1(),
      '/section2': (context) => Section2(),
      '/section3': (context) => Section3(),
    },
  ));
}
*/

//Consumo de un webservice y display directo del json recuperado
void main() => runApp(InvokerStarter());

