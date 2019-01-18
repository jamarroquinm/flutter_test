import 'package:flutter/material.dart';
import 'StartupNamer.dart';
import 'LayoutsBuilder.dart';
import 'BasicNavigation.dart';
import 'NavigationTree.dart';
import 'SimpleWebServiceInvoker.dart';
import 'BackgroundJson.dart';


/*
********************************************************************************
El proyecto actual incluye varias pequeñas aplicaciones de aprendizaje
Cada aplicación se encuentra completa en un archivo dart en la carpeta lib;
para probar alguna debe descomentarse la línea void main()... correspondiente
en este mismo archivo.
NOTA: solo puede haber un main() activo a la vez

El proyecto puede verse actualizado en
https://github.com/jamarroquinm/flutter_test
********************************************************************************
*/


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
//void main() => runApp(InvokerStarter());


//Consumo de un webservice en segundo plano
void main() => runApp(GetPostWSStarter());

