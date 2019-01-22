import 'package:flutter/material.dart';
import 'package:fluttery/layout.dart';
import 'package:fluttery/animations.dart'; //*1*
import 'dart:math';
import 'dart:ui';

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

//controla los estados del menú
class RadialMenuController extends ChangeNotifier {
  final AnimationController _progress;          //mantiene el paso entre estados
  RadialMenuState _state = RadialMenuState.closed;  //estado actual
  String _activationId;   //el ítem particular sobre el que el usuario hace tap

  /*
    se crea un arreglo de listeners para cachar cuando ha terminado la
    activación de cada uno de los ítemes al elegirlo, con el cual, se puede
    determinar el ítem seleccionado y realizar la tarea relacionada con él
  */
  Set<Function(String menuItemId)> _onSelectedLiesteners;

  RadialMenuController({@required TickerProvider vsync})
      : _progress = AnimationController(vsync: vsync),
        _onSelectedLiesteners = Set()
  {
    _progress
      ..addListener(_onProgressUpdate)
      ..addStatusListener((AnimationStatus status) {
        if(status == AnimationStatus.completed){
          _onTransitionComplete();
        }
      });
  }

  //para registrar los listeners
  void addSelectionListener(Function(String menuItemId) onSelected){
    if(onSelected != null){
      _onSelectedLiesteners.add(onSelected);
    }
  }

  //para eliminar listeners
  void removeSelectionListener(Function(String menuItemId) onSelected){
    _onSelectedLiesteners.remove(onSelected);
  }

  //para notificar a los listeners
  void _notifySelectionListeners(){
    _onSelectedLiesteners.forEach((listener) {
      listener(_activationId);
    });
  }

  //para prevenir memory leaks
  @override
  void dispose() {
    _onSelectedLiesteners.clear();
    super.dispose();
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
        _progress.duration = Duration(milliseconds: 500);
        _progress.forward(from: 0.0);
        break;
      case RadialMenuState.collapsing:
        _state = RadialMenuState.open;
        break;
      case RadialMenuState.activating:
        _state = RadialMenuState.dissipating;
        _progress.duration = Duration(milliseconds: 500);
        _progress.forward(from: 0.0);
        break;
      case RadialMenuState.dissipating:
        _notifySelectionListeners();
        _activationId = null;
        _state = RadialMenuState.open;
        break;
      case RadialMenuState.closed:
      case RadialMenuState.open:
      case RadialMenuState.expanded:
      //throw Exception('Invalid state during the transition: $_state');
        break;
    }

    notifyListeners();
  }

  RadialMenuState get state => _state;
  double get progress => _progress.value;
  String get activationId => _activationId;

  //pasar open solo tiene sentido si el estado actual es closed
  void open(){
    if(_state == RadialMenuState.closed){
      _state = RadialMenuState.opening;
      _progress.duration = Duration(milliseconds: 500);
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
      _activationId = menuItemId;
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
