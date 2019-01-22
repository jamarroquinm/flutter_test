import 'package:flutter/material.dart'; //*1*
import 'package:fluttery/layout.dart'; //*1*
import 'package:learning_flutter/RadialMenu/geometry.dart';
import 'package:learning_flutter/RadialMenu/Components.dart';
import 'package:learning_flutter/RadialMenu/RegularRadialMenu.dart';
import 'package:learning_flutter/RadialMenu/CollidingRadialMenu.dart';
import 'dart:math';
import 'dart:ui';

/*
  Basado en Flutter Challenge: Radial Menu
  https://www.youtube.com/watch?v=HjVaMxONcFw

  El código crea menús radiales en 7 ubicaciones de la pantalla: dos en la AppBar,
  a la izquierda y derecha, y cinco en el Body mediante un Stack, centro, centro
  izquierda, centro derecha, inferior  izquierda e inferior derecha.
  Cada menú consiste en un botón central que, al hacer tap sobre él, hace aparecer
  a su alrededor una serie de botones que son los ítemes del menú. Al elegir un
  ítem desaparecen todos los demás bajo un anillo animado que abarca el menú y
  luego se disuelve.

  Los menús ubicados junto a alguno de los bordes o en las esquinas se autoajustan
  para no rebasar los bordes de la pantalla.

  Clases:
  -------
  - RadioMenuStarter, la clase principal invocada desde main()
  - MyHomePage es la route inicial (en este caso la única) que expone el espacio
    para mostrar el resto de elementos
  - _MyHomePageState guarda el estado de MyHomePage y es donde (1) se define la
    ubicación del menú, (2) se recibe el arreglo de ítemes que formarán el menú y
    (3) define la acción que se realizará al elegir cada ítem particular.
    Actualmente la acción se limita a imprimir en consola el id del ítem
    seleccionado

  Notas:
  *1* Para prototipar en el video se usa fluttery; como el paquete original en su
  versión actual (0.0.7) no es compatible con Dart 2.0, el código fuente se
  copió a una carpeta local y luego se cambió su yaml para que admita Dart 2.0

*/

//se define aquí un arreglo de ítems del menú para que pueda ser variable
final Menu demoMenu = Menu(items: [
  MenuItem(
      id: '1',
      icon: Icons.home,
      bubbleColor: Colors.blue,
      iconColor: Colors.white),
  MenuItem(
      id: '2',
      icon: Icons.search,
      bubbleColor: Colors.green,
      iconColor: Colors.white),
  MenuItem(
      id: '3',
      icon: Icons.alarm,
      bubbleColor: Colors.red,
      iconColor: Colors.white),
  MenuItem(
      id: '4',
      icon: Icons.settings,
      bubbleColor: Colors.purple,
      iconColor: Colors.white),
  MenuItem(
      id: '5',
      icon: Icons.location_on,
      bubbleColor: Colors.orange,
      iconColor: Colors.white),
]);

class RadioMenuStarter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget{
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{

  //devuelve el icono que sirve como marcador de la posición del menú
  Widget _buildMenu() {
    return AnchoredRadialMenu(
      menu: demoMenu,
      onSelected: (String menuItemId) {
        //todo Aquí se agrega la funcionalidad que sigue a la selección de un ítem
        print('Done selecting item $menuItemId');
      },
      child: IconButton(
        icon: Icon(
          Icons.cancel,
        ),
        onPressed: () {},
      ),
    ) ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _buildMenu(),    //superior izquierda
        title: Text(''),
        actions: [
          _buildMenu(),           //superior derecha
        ],
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: _buildMenu(),  //centro
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: _buildMenu(),  //centro izquierda
          ),
          Align(
            alignment: Alignment.centerRight,
            child: _buildMenu(),  //centro derecha
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: _buildMenu(),  //inferior izquierda
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: _buildMenu(),  //inferior derecha
          ),
        ],
      ),
    );
  }
}


/*
  Esta clase ubica el menú en su posición y en una capa sobre lo demás en
  pantalla; recibe un widget (child) que usará como referencia para determinar
  la posición
*/
class AnchoredRadialMenu extends StatefulWidget{
  final Menu menu;
  final double radius;
  final double startAngle;
  final double endAngle;
  final Widget child;
  final Function(String menuItemId) onSelected;

  AnchoredRadialMenu({
    this.menu,
    this.radius = 75.0,
    this.startAngle = -pi / 2,
    this.endAngle = 3 * pi / 2,
    this.child,
    this.onSelected});

  @override
  State createState() => _AnchoredRadialMenuState();
}

/*
  A partir del child de AnchoredRadialMenu el método AnchoredOverlay() determina
  la posición de dicho widget y justo sobre su centro, en el overlayen, imprime
  una instancia de RadialMenu
*/
class _AnchoredRadialMenuState extends State<AnchoredRadialMenu>{

  @override
  Widget build(BuildContext context) {
    return AnchoredOverlay(   //parte de fluttery que ubica el widget overlay
      showOverlay: true,
      child: widget.child,
      overlayBuilder: (BuildContext context, Rect rect, Offset anchor) {
        //todo aquí puede usarse RadialMenu
        return CollidingRadialMenu(
          menu: widget.menu,
          radius: widget.radius,
          arc: Arc(
            from: Angle.fromRadians(widget.startAngle),
            to: Angle.fromRadians(widget.endAngle),
            direction: RadialDirection.clockwise,
          ),
          anchor: anchor,
          onSelected: widget.onSelected,
        );
      }
    );
  }
}
