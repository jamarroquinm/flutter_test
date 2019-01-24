import 'package:flutter/material.dart';

/*
  Aplicación con una estructura de pantallas presentadas en un "árbol" de secciones
  y subsecciones con la que se ilustra la forma de navegar por secciones hacia
  adelante y hacia atrás pero sin poder retroceder o brincar a secciones previas
  o diferentes, ni siquiera a la pantalla de inicio.

  El funcionamiento se basa en tres acciones:
  - Al entrar a una sección se borra el stack de pantallas previas por lo que no
    hay back posible
  - Con Navigator.push solo se agregan pantallas de una misma sección por lo que
    hay back solo hacia pantallas previas de la misma sección

  Una utilidad de lo anterior es la posibilidad de entrar desde una pantalla de
  logueo y una vez dentro eliminar el retroceso directamente a dicha pantalla (a
  menos que se implemente un logout)

  Otra utilidad es controlar el flujo de navegación para que ocurre en tramos
  "cortos" y de manera predecible

  Notas:
   - En main() se utilizan tags para las routes, mapeándolas con la clase correspondiente
     '/' representa la primera pantalla que se abre
     solo se han definido tags para las clases inicial de cada sección
   - La clase Login es la principal, invocada desde main(), solo tiene el botón "Entrar"
   - La clase HomePage, con route '/homepage', juega el papel de menú principal
     . al estar en esta route el stack siempre la tiene como único elemento
     . al elegir entrar a una sección se cambia en sl stack el homepage por la
       nueva ruta usando pushReplacementNamed(), de modo que siga habiendo solo un
       elemento
     . con esta mecánica se garantiza que no haya back en el homepage o en las
       secciones
   - Se utiliza pushNamedAndRemoveUntil para borrar el stack de routes y dejar solo
     el nuevo destino
   - Las clases Section1, Section2 y Section3 representan la pantalla inicial de
     cada sección
   - Las clases Seccion1a, Secion1b, etc. representan las subsecciones
   - Dado que todas las clases Sectionx y Sectionxx tienen la misma estructura se
     dejó agregó el método getSectionScaffold() para crear el layout de cada una y
     getScaffoldEnd() para el layout de la última pantalla de cada sección
 */

Widget getSectionScaffold(BuildContext context, String title, String buttonMessage, Widget target){
  return Scaffold(
    appBar: AppBar(
      title: Text('$title'),
    ),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: RaisedButton(
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => target),
              );
            },
            child: Text('$buttonMessage'),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 32.0),
          child: IconButton(
            icon: Icon(Icons.home),
            color: Colors.blue,
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/homepage', (_) => false);
            },
          ),
        ),
      ],
    ),
  );
}

Widget getScaffoldEnd(BuildContext context, String title, String endMessage){
  return Scaffold(
    appBar: AppBar(
      title: Text('$title'),
    ),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('$endMessage'),
        Container(
          padding: EdgeInsets.only(top: 32.0),
          child: IconButton(
            icon: Icon(Icons.home),
            color: Colors.blue,
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/homepage', (_) => false);
            },
          ),
        ),
      ],
    ),
  );
}


class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Éste es el login'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Entrar'),
          onPressed: () {
            //hace push y borra el stack de routes
            Navigator.pushNamedAndRemoveUntil(context, '/homepage', (_) => false);
            //otra forma: push a HomePage y eliminar Login para no poder hacer back
            //Navigator.popAndPushNamed(context, '/homepage');

          },
        ),
      ),
    );
  }
}


class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home page"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 32.0),
            child: Text(
              'No hay pantalla previa',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20.0),
            ),
          ),
          Center(
            child: RaisedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/section1');
              },
              child: Text('Sección 1'),
            ),
          ),
          Center(
            child: RaisedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/section2');
              },
              child: Text('Sección 2'),
            ),
          ),
          Center(
            child: RaisedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/section3');
              },
              child: Text('Sección 3'),
            ),
          ),
        ],
      ),
    );
  }
}


class Section1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return getSectionScaffold(context, 'Sección 1', 'Continuar a Pantalla 1A', Section1a());
  }
}


class Section1a extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return getSectionScaffold(context, 'Sección 1. Pantalla 1A', 'Continuar a Pantalla 1B', Section1b());
  }
}


class Section1b extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return getScaffoldEnd(context, 'Sección 1. Pantalla 1B', 'Fin de sección 1');
  }
}


class Section2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return getSectionScaffold(context, 'Sección 2', 'Continuar a Pantalla 2A', Section2a());
  }
}


class Section2a extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return getSectionScaffold(context, 'Sección 2. Pantalla 2A', 'Continuar a Pantalla 2B', Section2b());
  }
}


class Section2b extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return getSectionScaffold(context, 'Sección 2. Pantalla 2B', 'Continuar a Pantalla 2C', Section2c());
  }
}


class Section2c extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return getScaffoldEnd(context, 'Sección 2. Pantalla 2C', 'Fin de sección 2');
  }
}


class Section3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return getSectionScaffold(context, 'Sección 3', 'Continuar a Pantalla 3A', Section3a());
  }
}


class Section3a extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return getScaffoldEnd(context, 'Sección 3. Pantalla 3A', 'Fin de sección 3');
  }
}
