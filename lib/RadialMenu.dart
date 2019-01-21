import 'package:flutter/material.dart';
import 'package:fluttery/layout.dart';
import 'package:fluttery/animations.dart';
import 'dart:math';
import 'dart:async';

/*
  Basado en Flutter Challenge: Radial Menu
  https://www.youtube.com/watch?v=HjVaMxONcFw

  Para prototipar en el video se usa fluttery; como el paquete original en su
  versión actual (0.0.7) no es compatible con Dart 2.0, el código fuente se
  copió a una carpeta local y luego se cambió su yaml para que admita Dart 2.0

  Como parte del ejercicio no solo se creará el menú radial en el centro sino
  también en diferentes ubicaciones para probar cómo se ajusta cuando está cerca
  del límite de la pantalla. Para esto se agregan 7 iconos como marcadores de
  posición (dos en la AppBar, a la izquierda y derecha) y cinco en el Body
  mediante un Stack (centro, centro izquierda, centro derecha, inferior
  izquierda e inferior derecha)
*/

final Menu demoMenu = Menu(items: [
  MenuItem(
      id: '1',
      icon: Icons.home,
      bubbleColor: Colors.blue,
      iconColor: Colors.white),
  MenuItem(
      id: '1',
      icon: Icons.search,
      bubbleColor: Colors.green,
      iconColor: Colors.white),
  MenuItem(
      id: '1',
      icon: Icons.alarm,
      bubbleColor: Colors.red,
      iconColor: Colors.white),
  MenuItem(
      id: '1',
      icon: Icons.settings,
      bubbleColor: Colors.purple,
      iconColor: Colors.white),
  MenuItem(
      id: '1',
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
    return IconButton(
      icon: Icon(
        Icons.cancel,
      ),
      onPressed: () {},
    );
  }

  /*
    similar a _buildMenu() solo que el ícono se usa como child de la clase
    ubicadora, AnchoredRadialMenu
  */
  Widget _buildCenterMenu(){
    return AnchoredRadialMenu(
      menu: demoMenu,
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
            child: _buildCenterMenu(),  //centro
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
  final Widget child;

  AnchoredRadialMenu({this.menu, this.child});

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
        return RadialMenu(
          menu: widget.menu,
          anchor: anchor,
        );
      }
    );
  }
}


//Estas clase trazar el menú en sí
class RadialMenu extends StatefulWidget{
  final Menu menu;
  final Offset anchor;
  final double radius;

  RadialMenu({this.menu, this.anchor, this.radius = 75.0});

  @override
  State createState() => _RadialMenuState();
}

class _RadialMenuState extends State<RadialMenu> with SingleTickerProviderStateMixin{
  RadialMenuController _menuController;
  static const Color openBubbleColor = const Color(0xFFAAAAAA);
  static const Color expandedBubbleColor = const Color(0xFF666666);

  @override
  void initState() {
    super.initState();

    _menuController = RadialMenuController(
        vsync: this,)
          ..addListener(() => setState(() {}));

    //como todavía no hay forma de cambiar de estado, con un timer lo hacemos manualmente
    Timer(
        Duration(seconds: 2), () {_menuController.open();}
    );
  }

  @override
  void dispose() {
    _menuController.dispose();
    super.dispose();
  }

  Widget buildCenter(){
    IconData icon;
    Color bubbleColor;
    double scale = 1.0;
    VoidCallback onPressed;

    switch(_menuController.state){
      case RadialMenuState.closed:
        icon = Icons.menu;
        bubbleColor = openBubbleColor;
        scale = 0.0;
        break;
      case RadialMenuState.closing:
        icon = Icons.menu;
        bubbleColor = openBubbleColor;
        scale = 1.0 - _menuController.progress;
        break;
      case RadialMenuState.opening:
        icon = Icons.menu;
        bubbleColor = openBubbleColor;
        scale = _menuController.progress;
        break;
      case RadialMenuState.open:
        icon = Icons.menu;
        bubbleColor = openBubbleColor;
        scale = 1.0;
        onPressed = () {
          _menuController.expand();
        };
        break;
      case RadialMenuState.expanded:
        icon = Icons.clear;
        bubbleColor = expandedBubbleColor;
        scale = 1.0;
        onPressed = () {
          _menuController.collapse();
        };
        break;
      default:
        icon = Icons.clear;
        bubbleColor = expandedBubbleColor;
        scale = 1.0;
        break;
    }

    return CenterAbout(   //parte de fluttery
        position: widget.anchor,
        child: Transform(   //se aplica aquí para el icono completo se afecte
          transform: Matrix4.identity()..scale(scale, scale),
          alignment: Alignment.center,
          child: IconBubble(
            icon: icon,
            diameter: 50.0,
            bubbleColor: bubbleColor,
            iconColor: Colors.black,
            onPressed: onPressed,
          ),
        ),
    );
  }

  Widget buildRadialBubble({double angle, IconData icon, Color bubbleColor,
    Color iconColor}){

    if(_menuController.state == RadialMenuState.closed ||
        _menuController.state == RadialMenuState.closing ||
        _menuController.state == RadialMenuState.opening ||
        _menuController.state == RadialMenuState.open ||
        _menuController.state == RadialMenuState.dissipating){
        return Container();
    }

    double radius = widget.radius;
    double scale = 1.0;

    if(_menuController.state == RadialMenuState.expanding){
      radius = widget.radius * _menuController.progress;
      scale = _menuController.progress;
    } else if(_menuController.state == RadialMenuState.collapsing){
      radius = widget.radius * (1.0 - _menuController.progress);
      scale = 1.0 - _menuController.progress;
    }

    return PolarPosition(
        origin: widget.anchor,
        coord: PolarCoord(angle, radius),
        child: Transform(
            transform: Matrix4.identity()..scale(scale, scale),
            alignment: Alignment.center,
            child: IconBubble(
              icon: icon,
              diameter: 50.0,
              bubbleColor: bubbleColor,
              iconColor: iconColor,
              onPressed: () {
                _menuController.activate("todo");
              },
            ),
        ),
    );
  }

  Widget buildActivation(){
    if(_menuController.state != RadialMenuState.activating &&
        _menuController.state != RadialMenuState.dissipating){
      return Container();
    }

    double startAngle;
    double endAngle;
    double radius = widget.radius;
    double opacity = 1.0;

    if(_menuController.state == RadialMenuState.activating){
      startAngle = -pi /2;
      endAngle = (2 * pi) * _menuController.progress + startAngle;
    } else if(_menuController.state != RadialMenuState.dissipating){
      startAngle = -pi /2;
      endAngle = 2 * pi;

      //al difuminar el anillo animado comenzamos en 100% y crece hasta un 25% más
      radius = widget.radius * (1.0 + (0.25 * _menuController.progress));

      //y a la vez vamos haciéndolo más transparente
      opacity = 1.0 - _menuController.progress;
    }

    return CenterAbout(
      position: widget.anchor,
      child: Opacity(
        opacity: opacity,
        child: CustomPaint(
          painter: ActivationPainter(
            radius: radius,
            thickness: 50.0,
            color: Colors.blue,
            startAngle: startAngle,
            endAngle: endAngle,

          ),
        ),
      ),

    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //botón central
        buildCenter(),
        //botones periféricos
        buildRadialBubble(
            angle: -pi/2,
            icon: Icons.home,
            bubbleColor: Colors.blue,
            iconColor: Colors.white),
        buildRadialBubble(
            angle: -pi/2 + (1 * 2 * pi / 5),
            icon: Icons.search,
            bubbleColor: Colors.green,
            iconColor: Colors.white),
        buildRadialBubble(
            angle: -pi/2 + (2 * 2 * pi / 5),
            icon: Icons.alarm,
            bubbleColor: Colors.red,
            iconColor: Colors.white),
        buildRadialBubble(
            angle: -pi/2 + (3 * 2 * pi / 5),
            icon: Icons.settings,
            bubbleColor: Colors.purple,
            iconColor: Colors.white),
        buildRadialBubble(
            angle: -pi/2 + (4 * 2 * pi / 5),
            icon: Icons.location_on,
            bubbleColor: Colors.orange,
            iconColor: Colors.white),
        //las burbujas alrededor
        buildActivation(),
      ],
    );

  }
}

//Traza cada uno de los submenúes radiales con coordenadas polares
class PolarPosition extends StatelessWidget {
  final Offset origin;
  final PolarCoord coord;
  final Widget child;

  PolarPosition({this.origin = const Offset(0.0, 0.0), this.coord, this.child});

  @override
  Widget build(BuildContext context) {
    /*

    final radialPosition = Offset(
        100.0,
        100.0,
    );
     */

    final radialPosition = Offset(
        origin.dx + (cos(coord.angle) * coord.radius),
        origin.dy + (sin(coord.angle) * coord.radius)
    );

    return CenterAbout(
      position: radialPosition,
      child: child,
    );
  }
}


//Compone el ícono circular de cada ítem del menú
class IconBubble extends StatelessWidget {
  final IconData icon;
  final double diameter;
  final Color iconColor;
  final Color bubbleColor;
  final VoidCallback onPressed;

  IconBubble({this.icon, this.diameter, this.iconColor,
    this.bubbleColor, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bubbleColor,
        ),
        child: Icon(
          icon,
          color: iconColor,
        ),
      ),
    );
  }
}


//Define el arco animado al elegir un ítem del menú
class ActivationPainter extends CustomPainter{
  final double radius;
  final double thickness;
  final Color color;
  final double startAngle;
  final double endAngle;
  final Paint activationPaint;

  ActivationPainter({this.radius, this.thickness, this.color,
      this.startAngle, this.endAngle}) : activationPaint = Paint()
        ..color = color
        ..strokeWidth = thickness
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;


  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawArc(
      Rect.fromLTWH(-radius, -radius, radius * 2, radius * 2),
      startAngle,
      endAngle - startAngle,
      false,
      activationPaint
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}


//controladora de los estados del menú
class RadialMenuController extends ChangeNotifier {
  final AnimationController _progress;          //mantiene el paso entre estados
  RadialMenuState _state = RadialMenuState.closed;  //estado actual

  RadialMenuController({@required TickerProvider vsync})
  : _progress = AnimationController(vsync: vsync){
    _progress
      ..addListener(_onProgressUpdate)
      ..addStatusListener((AnimationStatus status) {
      if(status == AnimationStatus.completed){
        _onTransitionComplete();
      }
    });
  }

  //este método se ejecuta en cada frame de la animación
  void _onProgressUpdate(){
    notifyListeners();
  }

  //el método solo se ejecuta cuando una animación se ha completado
  void _onTransitionComplete(){
    switch(_state){
      case RadialMenuState.closing:
        _state = RadialMenuState.closed;
        break;
      case RadialMenuState.opening:
        _state = RadialMenuState.open;
        break;
      case RadialMenuState.expanding:
        _state = RadialMenuState.expanded;
        break;
      case RadialMenuState.collapsing:
        _state = RadialMenuState.open;
        break;
      case RadialMenuState.activating:
        _state = RadialMenuState.dissipating;
        _progress.duration = Duration(milliseconds: 250);
        _progress.forward(from: 0.0);
        break;
      case RadialMenuState.dissipating:
        _state = RadialMenuState.open;
        break;
      case RadialMenuState.closed:
      case RadialMenuState.open:
      case RadialMenuState.expanded:
        throw Exception('Invalid state during the transition: $_state');
        break;
    }

    notifyListeners();
  }

  RadialMenuState get state => _state;
  double get progress => _progress.value;

  //pasar open solo tiene sentido si el estado actual es closed
  void open(){
    if(_state == RadialMenuState.closed){
      _state = RadialMenuState.opening;
      _progress.duration = Duration(milliseconds: 250);
      _progress.forward(from: 0.0);
      notifyListeners();
    }
  }

  //pasar closed solo tiene sentido si el estado actual es open
  void close(){
    if(_state == RadialMenuState.open){
      _state = RadialMenuState.closing;
      _progress.duration = Duration(milliseconds: 250);
      _progress.forward(from: 0.0);
      notifyListeners();
    }
  }

  //solo se pasa a expand si actualmente se está en open
  void expand(){
    if(_state == RadialMenuState.open){
      _state = RadialMenuState.expanding;
      _progress.duration = Duration(milliseconds: 150);
      _progress.forward(from: 0.0);
      notifyListeners();
    }
  }

  //pasar collapse solo tiene sentido si el estado actual es expanded
  void collapse(){
    if(_state == RadialMenuState.expanded){
      _state = RadialMenuState.collapsing;
      _progress.duration = Duration(milliseconds: 150);
      _progress.forward(from: 0.0);
      notifyListeners();
    }
  }

  //solo se pasa a activating si actualmente se está en expanded
  void activate(String menuItemId){
    if(_state == RadialMenuState.expanded){
      _state = RadialMenuState.activating;
      _progress.duration = Duration(milliseconds: 500);
      _progress.forward(from: 0.0);
      notifyListeners();
    }
  }
}


//listado de los estados posibles del menú
enum RadialMenuState{
  closed,       //nada que mostrar
  closing,      //para ir de open a closed
  opening,      //para de closed a open
  open,         //el botón central es visible
  expanding,    //inicia expansión
  expanded,     //todos los ítemes son visibles
  collapsing,   //inicia colapso para terminar en open
  activating,   //se ejecuta la animación
  dissipating,  //el arco se cierra y hace fade out terminando en open
}


//Un holder de las propiedades de cada ítem del menú
class MenuItem {
  final String id;
  final IconData icon;
  final Color bubbleColor;
  final Color iconColor;

  MenuItem({this.id, this.icon, this.bubbleColor, this.iconColor});
}

//El agrupador de ítemes del menú
class Menu{
  final List<MenuItem> items;

  Menu({this.items});
}