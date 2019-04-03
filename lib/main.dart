import 'package:flutter/material.dart';
/*
import 'StartupNamer.dart';                           // *1*
import 'LayoutsBuilder.dart';                         // *2*
import 'BasicNavigation.dart';                        // *3*
import 'NavigationTree.dart';                         // *4*
import 'SimpleWebServiceInvoker.dart';                // *5*
import 'BackgroundJson.dart';                         // *6*
import 'RadialMenuTest.dart';                         // *7*
import 'package:learning_flutter/Integracion1/Login.dart' as int1;              // *8*
import 'package:bloc/bloc.dart';                                                // *9*
import 'package:learning_flutter/Integracion1/App.dart';                        // *9*
import 'package:learning_flutter/Integracion1/backend/SimpleBlocDelegate.dart'; // *9*
import 'package:learning_flutter/Integracion1/models/UserRepository.dart';      // *9*
import 'package:learning_flutter/DBBasics/main.dart'; // *10*
import 'package:learning_flutter/DBBasics/mainBloc.dart'; // *11*
import 'package:learning_flutter/authenticator/start.dart'; // *12*
import 'package:learning_flutter/Calendar/Home.dart'; // *13*
import 'package:learning_flutter/Webservices/WebserviceUI.dart'; // *14*
import 'package:learning_flutter/Operaciones/Pantalla.dart';  // *15*
*/

import 'tutti/PlayingWithImages.dart';  // *16*

/*
********************************************************************************
El proyecto actual incluye varias pequeñas aplicaciones de aprendizaje, las
primeras de las cuales se encuentran completa en un solo archivo dart en la
carpeta lib mientras que las más complejas comprenden varios archivos en su
propio package o directorio, todos subfolders de lib. Para probar cualquiera de
ellas basta con descomentar el import y el main() correspondiente en este mismo
archivo.
NOTA: solo puede haber un main() activo a la vez

El proyecto puede verse actualizado en
https://github.com/jamarroquinm/flutter_test
********************************************************************************
*/

/*
//Lista infinita de nombres seleccionables. Su import es *1*
void main() => runApp(StartupNamerApp());


//Construcción de un layout básico. Su import es *2*
void main() => runApp(LayoutsBuilderApp());


//Navegación básica entre dos pantallas. Su import es *3*
void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: FirstRoute(),
  ));
}


//Navegación en un árbol de pantallas. Su import es *4*
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


//Consumo de un webservice y display del json recuperado. Su import es *5*
void main() => runApp(InvokerStarter());


//Consumo de un webservice en segundo plano. Su import es *6*
void main() => runApp(GetPostWSStarter());


//Implementación de un RadialMenu. Su import es *7*
void main() {
  runApp(MaterialApp(
    title: 'RadialMenu Test',
    //home: FirstRoute(),  //no incluir home cuando hay named routes
    routes: {
      '/': (context) => RadialMenuTestStarter(),
      '/homepage': (context) => MyHomePage(),
      '/section1': (context) => FirstPage(),
      '/section2': (context) => SecondPage(),
      '/section3': (context) => ThirdPage(),
    },

  ));
}


//Primer intento de un autenticador con patrón BLoC. Su import es *8*
void main() {
  runApp(MaterialApp(
    title: 'Integración versión 1',
    theme: ThemeData(
      primarySwatch: Colors.deepOrange,
      primaryColor: const Color(0xFFff5722),
      accentColor: const Color(0xFFff5722),
      canvasColor: const Color(0xFFffffff),
    ),
    home: int1.LoginRoute(),
  ));
}

//Segundo intento del autenticador con BLoC. Sus import son *9*
void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(App(userRepository: UserRepository()));
}


//Implementación de una DB con SQLite. Su import es *10* para la forma
//convencional y *11* para la forma con el patrón BLoC
void main() => runApp(MaterialApp(home: MyApp()));

*/

/*
//Tercer intento del autenticador con un modelo de datos (para SQLite) que
// incluye Person, Number y PersonNumber; se sigue el patrón BLoC. Su import es
// *12*
void main() => runApp(MaterialApp(home: Start()));
*/

/*
//prueba del calendario custom; su import es *13*
void main() => runApp(MyApp());
*/


/*
//prueba de serialización/deserialización de webservices; su import es *14*
void main() => runApp(WebserviceUI());
*/

/*
//prueba de serialización/deserialización de webservices; su import es *15*
void main() => runApp(Pantalla());
*/

//prueba de displey de imagen a partir de base64; su import es *16*
void main() => runApp(PlayingWithImages());
