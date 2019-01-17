import 'package:flutter/material.dart';

/*
  Ejercicio basado en https://flutter.io/docs/cookbook/navigation/navigation-basics

  Es una aplicación de dos pantallas con un botón cada una para ir de una a otra.
  Como no hay estado que guardar se usan dos clases que heredan de StatelessWidget
  de las que FirstRoute es la invocada desde main()

  Notas:
   - Las pantallas o páginas (Activity en Android) se llaman route en Flutter
   - Aquí se ilustra el uso de push y pop del Navigator.
   - Como se trata de un stack de routes, abrir una nueva se hace con push y
     volver a la anterior se logra haciendo pop a la actual para entonces mostrar
     la que queda arriba en el stack
   - Cuando se usa Navigator.push y el stack tiene más de una route en la AppBar
     se agrega automáticamente la flecha para hacer back; para eliminarla se
     pone automaticallyImplyLeading en false:
        appBar: AppBar(
          title: Text("App Bar without Back Button"),
          automaticallyImplyLeading: false,
        ),
 */

class FirstRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Route'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Open route'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecondRoute()),
            );
          },
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}