import 'package:flutter/material.dart'; //*1*
import 'package:learning_flutter/RadialMenu/RadialMenu.dart';

/*

  Esta aplicación ilustra la forma de implementar un menú radial a partir del
  package RadialMenu de este mismo proyecto. Véanse los comentarios en
  RadialMenu/RadialMenu.dart.
  Además se pone a prueba dicho menú aplicándolo a la navegación entre 4 pantallas,
  de las cuales solo la principal tiene visible el menú.

  Notas:
  -----
  *1* WillPopScope se usa para cachar el intento del usuario de cerrar el
  ModalRoute haciendo back; aquí se usa para determinar si el usuario está volviendo
  a la pantalla principal para volver a desplegar el menú radial
*/

//se define aquí un arreglo de ítemes del menú para que pueda ser variable
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
]);

//para controlar que se muestra el menú solo en MyHomePage y no en otras pantallas
bool homePageIsCurrent = true;

class RadialMenuTestStarter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prueba del menú radial',
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

  void onSelected(String menuItemId){
    homePageIsCurrent = false;

    Widget target;
    if(menuItemId == '1'){
      target = FirstPage();
    } else if(menuItemId == '2'){
      target = SecondPage();
    } else if(menuItemId == '3'){
      target = ThirdPage();
    } else {
      return;
    }

    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => target),
    );
  }

  /*
    Construye como widget la instancia del controlador del menú a partir de
      - el menú propiamente, como conjunto de MenuItem
      - la función que se ejecutará al seleccionar cada íte,
      - y un IconButton que sirve como marcador de posición, a partir de cuyas
        coordenadas se establece el centro del menú

  */
  Widget _buildMenu(bool showOverlay) {
    return AnchoredRadialMenu(
      menu: demoMenu,
      onSelected: onSelected,
      //todo Aquí se agrega la funcionalidad que sigue a la selección de un ítem
      /*onSelected: (String menuItemId) {
        print('Done selecting item $menuItemId');
      },*/
      child: IconButton(
        icon: Icon(
          Icons.cancel,
        ),
        onPressed: () {},
      ),
      showOverlay: showOverlay,
    ) ;
  }

  /*
    La ubicación de _buildMenu() determina la posición del menú; algunas opciones
    son:
     - superior izquierda
        appBar: AppBar(leading: _buildMenu(),),
     - superior derecha
        appBar: AppBar(actions: [_buildMenu(),],),
     - centro
        body: Stack(children: [Align( alignment: Alignment.center, child: _buildMenu(),),],),
     - centro izquierda
        body: Stack(children: [Align( alignment: Alignment.centerLeft, child: _buildMenu(),),],),
     - centro derecha
        body: Stack(children: [Align( alignment: Alignment.centerRight, child: _buildMenu(),),],),
     - inferior izquierda
        body: Stack(children: [Align( alignment: Alignment.bottomLeft, child: _buildMenu(),),],),
     - inferior derecha
        body: Stack(children: [Align( alignment: Alignment.bottomRight, child: _buildMenu(),),],),

  */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pantalla inicial'),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: _buildMenu(homePageIsCurrent),  //inferior izquierda
          ),
        ],
      ),
    );
  }
}

class FirstPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return WillPopScope(  //*1*
        onWillPop: () async {
          print('haciendo back');
          homePageIsCurrent = true;

          _showDialog(context, 'Alerta de cierre', 'Hiciste back; se cerrará este diálogo y luego la pantalla actual');
          return true;
        },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Primera pantalla'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Loren ipsum...'),
          ],
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print('haciendo back');
        homePageIsCurrent = true;
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Segunda pantalla'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Loren ipsum...'),
          ],
        ),
      ),
    );
  }
}

class ThirdPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print('haciendo back');
        homePageIsCurrent = true;
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tercera pantalla'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Loren ipsum...'),
          ],
        ),
      ),
    );
  }
}

void _showDialog(BuildContext context, String title, String body){
  showDialog(
    context: context,
    builder: (BuildContext context){
      return AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: <Widget>[
          FlatButton(
            child: Text('Cerrar'),
            onPressed: () {
              Navigator.of(context).pop();  //cierra el Alert
              //Navigator.of(context).pop();  //cierra la Route
            },
          ),
        ],
      );
    },
  );

}
