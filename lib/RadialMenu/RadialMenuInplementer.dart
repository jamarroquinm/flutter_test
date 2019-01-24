import 'package:flutter/material.dart';
import 'package:fluttery/layout.dart';
import 'package:fluttery/animations.dart';
import 'package:learning_flutter/RadialMenu/geometry.dart';
import 'dart:math';
import 'dart:ui';
import 'dart:async';
import 'RadialMenu.dart';


/*
  **************************************************************************************
  Basado en "Flutter Challenge: Radial Menu" https://www.youtube.com/watch?v=HjVaMxONcFw
  **************************************************************************************

  Este archivo incluye las clases complementarias del menú radial; ver comentarios
  en el archivo RadialMenu.dart


  Clases:
  -------
  - RadialMenu y _RadialMenuState trazan finalmente el menú en pantalla y definen
    las animaciones de cada elemento según su estado
  - RadialMenuController: Es la encargada de controlar los estados del menú y
    donde se registran los listeners que permitirán notificar si un ítem ha sido
    seleccionado; con esa notificación se determinará el id del ítem y se podrá
    ejecutar la función asociada
  - IconBubble: Compone el icono circular de cada ítem del menú
  - PolarPosition: Traza cada uno de los ítemes con coordenadas polares
  - ActivationPainter: Traza el anillo o ribbon animado que se muestra cuando se
    ha seleccionado un ítem
  - RadialMenuState: Es la enumeración de los estados posibles del menú:
      closed:     nada que mostrar
      closing:    para ir de open a closed
      opening:    para de closed a open
      open        el botón central es visible
      expanding   inicia expansión
      expanded    todos los ítemes son visibles
      collapsing  inicia colapso para terminar en open
      activating  se ejecuta la animación
      dissipating el arco se cierra y hace fade out terminando en open


  Notas:
  *1* Cambiando la variable que recibe el Timer en el initState de _RadialMenuState
  se acelera o retrasa la aparición inicial del menú; esto es necesario porque
  al principio no hay cambios de estado, asi que se simula su apertura
  *2* El menú consta de estos elementos:
    - un botón central que hace fade out, fade in y gira cuando cambia de estado
    - Los ítemes (bubbles o iconos) que rodean el botón central; aparecen cuando
      el botón central se ha seleccionado y desaparecen cuando un ítem de ellos
      se ha seleccionado
    - El anillo o ribbon que aparece al seleccionar un ítem, se expande y luego
      hace fade out
    - La animación del ítem seleccionado, que sigue el path del anillo y luego
      desaparece con él
  *3* Es posible cambiar la duración de las animaciones y cambios de estados
  haciendo las modificaciones correspondientes en la clase RadialMenuController,
  en los siguientes métodos:
    - _onTransitionComplete()
    - open()
    - close()
    - expand()
    - collapse()
    - activate()
*/

class RadialMenu extends StatefulWidget{
  final Menu menu;
  final Offset anchor;
  final double radius;
  final Arc arc;
  final Function(String menuItemId) onSelected; //el listener

  RadialMenu({
    this.menu,
    this.anchor,
    this.radius = 75.0,
    this.arc = const Arc(
        from: Angle.fromRadians(-pi / 2),
        to: Angle.fromRadians(3 * pi / 2)
    ),
    this.onSelected,
  });

  @override
  State createState() => _RadialMenuState();
}

class _RadialMenuState extends State<RadialMenu> with SingleTickerProviderStateMixin{
  RadialMenuController _menuController;
  static const Color openBubbleColor = const Color(0xFFAAAAAA);
  static const Color expandedBubbleColor = const Color(0xFF666666);

  //tiempo en milisegundos para presentar el menú la primera vez
  final int _initialOpenTime = 500;

  @override
  void initState() {
    super.initState();

    _menuController = RadialMenuController(
      vsync: this,)
      ..addListener(() => setState(() {}))
      ..addSelectionListener(widget.onSelected);

    Timer(
        Duration(milliseconds: _initialOpenTime), () {_menuController.open();} //*1*
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
    double rotation = 0.0;
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
      //se agrega un efecto más al botón central cuando se abre
        icon = Icons.menu;
        bubbleColor = openBubbleColor;
        //se cambia la escala lineal scale=_menuController.progress por una curva
        scale = Curves.elasticOut.transform(_menuController.progress);

        /*
          Se aplica una rotación al icono central; primero clockwise entre 0 y
          50% del tiempo de la animación y el resto del tiempo counterclockwise
        */
        if(_menuController.progress > 0.0 && _menuController.progress < 0.5){
          //se hace una interpolación en un intervalo de 0 a 0.5
          rotation = lerpDouble(
            0.0,
            pi / 4,
            Interval(0.0, 0.5).transform(_menuController.progress),
          );
        } else {
          rotation = lerpDouble(
            pi / 4,
            0.0,
            Interval(0.5, 1.0).transform(_menuController.progress),
          );
        }
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
      case RadialMenuState.expanding:
        icon = Icons.clear;
        bubbleColor = expandedBubbleColor;
        scale = 1.0;
        rotation = Interval(0.0, 0.5, curve: Curves.easeOut).transform(_menuController.progress) * (pi / 2);
        break;
      case RadialMenuState.activating:
        icon = Icons.clear;
        bubbleColor = expandedBubbleColor;
        //se hace un fade out
        scale = lerpDouble(
          1.0,
          0.0,
          Interval(0.0, 0.9, curve: Curves.easeOut).transform(_menuController.progress),
        );
        break;
      case RadialMenuState.dissipating:
      //se recupera el botón central con un fade in
        icon = Icons.menu;
        bubbleColor = openBubbleColor;
        scale = lerpDouble(
          0.0,
          1.0,
          Curves.elasticOut.transform(_menuController.progress),
        );
        if(_menuController.progress > 0.0 && _menuController.progress < 0.5){
          //se hace una interpolación en un intervalo de 0 a 0.5
          rotation = lerpDouble(
            0.0,
            pi / 4,
            Interval(0.0, 0.5).transform(_menuController.progress),
          );
        } else {
          rotation = lerpDouble(
            pi / 4,
            0.0,
            Interval(0.5, 1.0).transform(_menuController.progress),
          );
        }
        break;
      case RadialMenuState.collapsing:
        icon = Icons.clear;
        bubbleColor = expandedBubbleColor;
        scale = 1.0;
        break;
    }

    return CenterAbout(   //parte de fluttery
      position: widget.anchor,
      child: Transform(   //se aplica aquí para el icono completo se afecte
        transform: Matrix4.identity()
          ..scale(scale, scale)
          ..rotateZ(rotation),
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

  //se controla el display de la totalidad del conjunto de ítemes del menú
  List<Widget> buildRadialBubbles() {
    final Angle startAngle = widget.arc.from;
    final Angle sweepAngle = widget.arc.to - startAngle;
    int index = 0;
    int itemCount = widget.menu.items.length;

    return widget.menu.items.map((MenuItem item) {
      //si el ítem se está activando, no se traza aquí sino sobre el anillo
      if(_menuController.state == RadialMenuState.activating ||
          _menuController.state == RadialMenuState.dissipating &&
              _menuController.activationId == item.id){
        return Container();
      }

      /*
      el ángulo de las coordenadas polares es proporcional al total de ítemes:
      en un círculo completo no hay espacios y donde inicia y termina está un
      ítem y el circulo se divide entre el número de ítemes para obtener el ángulo
      de cada uno; pero si es un arco tendremos un espacio y en un extremo del arco
      habrá un ítem y en el otro otro ítem, por tanto, el ángulo de cada uno se
      obtiene dividiendo el arco entre el total de ítemes menos uno
      */
      final int indexDivisor = sweepAngle == Angle.fullCircle ? itemCount : itemCount -1;
      final Angle myAngle = sweepAngle * (index / indexDivisor) + startAngle;
      ++index;

      //
      return buildRadialBubble(
        id: item.id,
        angle: myAngle.toRadians(),
        icon: item.icon,
        bubbleColor: item.bubbleColor,
        iconColor: item.iconColor,
      );
    }).toList(growable: true);
  }

  //arma el widget que representa un ítem particular
  Widget buildRadialBubble({String id, double angle, IconData icon,
    Color bubbleColor, Color iconColor}){

    //si el menú no está en expansión, contracción o activación el ítem no se muestra
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
      //en expansión el ítem crece y se aleja en razón de progress
      radius = widget.radius * _menuController.progress;
      //para no iniciar con scale=0 se hace una interpolación lineal entre 30% y 100%
      scale = lerpDouble(0.3, 0.1, _menuController.progress);
    } else if(_menuController.state == RadialMenuState.collapsing){
      //en contracción el ítem decrece y se acerca al centro en razón de progress
      radius = widget.radius * (1.0 - _menuController.progress);
      scale = lerpDouble(0.3, 0.1, (1.0 - _menuController.progress));
    }


    //se traza y escala el ítem según sus coordenadas polares
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
            _menuController.activate(id);
          },
        ),
      ),
    );
  }

  Widget buildActivationRibbon(){
    if(_menuController.state != RadialMenuState.activating &&
        _menuController.state != RadialMenuState.dissipating){
      return Container();
    }

    //se encuentra el ítem activado para definir inicio y fin del anillo
    final MenuItem activeItem = widget.menu.items.firstWhere(
            (MenuItem item) => item.id == _menuController.activationId);
    final int activeIndex  = widget.menu.items.indexOf(activeItem);

    Angle startAngle = widget.arc.from;
    Angle endAngle= widget.arc.to;
    double radius = widget.radius;
    double opacity = 1.0;

    if(_menuController.state == RadialMenuState.activating){
      final Angle menuSeewpAngle = widget.arc.sweepAngle();
      final double indexDivisor = menuSeewpAngle == Angle.fullCircle
          ? widget.menu.items.length.toDouble()
          : (widget.menu.items.length -1).toDouble();
      final Angle initialItemAngle = startAngle + (menuSeewpAngle * (activeIndex / indexDivisor));

      if(menuSeewpAngle == Angle.fullCircle){
        //es un círculo
        startAngle = initialItemAngle;
        endAngle = initialItemAngle + (menuSeewpAngle * _menuController.progress);
      } else {
        /*
          cuando solo es un arco ya no puede expandirse dando toda la vuelta sino
          que ahora, a partir de la posición del ítem seleccionado, debe intentar
          expandirse en ambas direcciones hasta cubrir el arco
        */
        startAngle = initialItemAngle - ((initialItemAngle - widget.arc.from) * _menuController.progress);
        endAngle = initialItemAngle + ((widget.arc.to - initialItemAngle) * _menuController.progress);
      }

    } else if(_menuController.state != RadialMenuState.dissipating){
      startAngle = widget.arc.from;
      endAngle = widget.arc.to;

      //al difuminar el anillo animado comenzamos en 100% y crece hasta un 25% más
      final adjustProgress = Interval(0.0, 0.5).transform(_menuController.progress);
      radius = widget.radius * (1.0 + (0.25 * adjustProgress));

      //y a la vez vamos haciéndolo más transparente
      opacity = 1.0 - adjustProgress;
    }

    //se trata de trazar un arco grueso de cierto color y opacidad
    return CenterAbout(
      position: widget.anchor,
      child: Opacity(
        opacity: opacity,
        child: CustomPaint(
          painter: ActivationPainter(
            radius: radius,
            thickness: 50.0,
            color: activeItem.bubbleColor,
            startAngle: startAngle.toRadians(),
            endAngle: endAngle.toRadians(),

          ),
        ),
      ),

    );
  }

  Widget buildActivationBubble(){
    //no se traza nada si no hay un ítem activándose
    if(_menuController.state != RadialMenuState.activating){
      return Container();
    }

    //se encuentra el ítem activado para determinar cuál mostrar y cómo
    final MenuItem activeItem = widget.menu.items.firstWhere(
            (MenuItem item) => item.id == _menuController.activationId);
    final int activeIndex  = widget.menu.items.indexOf(activeItem);

    //localizado el ítem se encuentra el ángulo de su posición inicial
    final Angle sweepAngle = widget.arc.sweepAngle();
    final double indexDivisor = sweepAngle == Angle.fullCircle
        ? widget.menu.items.length.toDouble()
        : (widget.menu.items.length -1).toDouble();
    final Angle initialItemAngle = widget.arc.from + (sweepAngle * (activeIndex / indexDivisor));


    //y entonces, para hacerlo girar con el anillo, se define su nuevo ángulo
    Angle currentAngle;
    if(sweepAngle == Angle.fullCircle){
      //círculo completo
      currentAngle = (sweepAngle * _menuController.progress) + initialItemAngle;
    } else {
      //se elige la opción de que el ítem vaya solo al centro del arco
      final double centerAngle = lerpDouble(widget.arc.from.toRadians(), widget.arc.to.toRadians(), 0.5);
      currentAngle = Angle.fromRadians(lerpDouble(initialItemAngle.toRadians(), centerAngle, _menuController.progress));
    }

    return buildRadialBubble(
      id: activeItem.id,
      angle: currentAngle.toRadians(),
      icon: activeItem.icon,
      bubbleColor: activeItem.bubbleColor,
      iconColor: activeItem.iconColor,
    );

  }

  @override
  Widget build(BuildContext context) {  //*2*
    return Stack(
      children: buildRadialBubbles()
        ..addAll([
          buildCenter(),
          buildActivationRibbon(),
          buildActivationBubble(),
        ]),
    );
  }
}


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


class PolarPosition extends StatelessWidget {
  final Offset origin;
  final PolarCoord coord;
  final Widget child;

  PolarPosition({this.origin = const Offset(0.0, 0.0), this.coord, this.child});

  @override
  Widget build(BuildContext context) {
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
