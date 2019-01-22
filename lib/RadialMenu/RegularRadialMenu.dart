import 'package:flutter/material.dart';
import 'package:fluttery/layout.dart';
import 'package:fluttery/animations.dart';
import 'package:learning_flutter/RadialMenu/geometry.dart';
import 'dart:math';
import 'dart:ui';
import 'dart:async';
import 'Components.dart';


//Esta clase y su state trazan el menú completo en sí
class RadialMenu extends StatefulWidget{
  final Menu menu;
  final Offset anchor;
  final double radius;

  //la siguiente propiedad permite que el menú pueda ser un arco parcial
  final Arc arc;

  final Function(String menuItemId) onSelected; //el listener

  RadialMenu({
    this.menu,
    this.anchor,
    this.radius = 75.0,
    this.arc = const Arc(
        from: Angle.fromRadians(-pi / 2), //en el top
        to: Angle.fromRadians(3 * pi / 2) //un círculo completo
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

  @override
  void initState() {
    super.initState();

    _menuController = RadialMenuController(
      vsync: this,)
      ..addListener(() => setState(() {}))
      ..addSelectionListener(widget.onSelected);

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
  Widget build(BuildContext context) {
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
