import 'package:flutter/material.dart';
import 'package:fluttery/animations.dart'; //*1*
import 'package:fluttery/layout.dart'; //*1*
import 'package:learning_flutter/RadialMenu/geometry.dart'; //*2*
import 'package:learning_flutter/RadialMenu/radial_menu_collisions.dart'; //*2*
import 'dart:math';
import 'RadialMenuInplementer.dart';  //*3*

/*
  **************************************************************************************
  Basado en "Flutter Challenge: Radial Menu" https://www.youtube.com/watch?v=HjVaMxONcFw
  **************************************************************************************

  El componente crea menús radiales en ubicaciones variables de la pantalla. El
  menú consiste en un botón central que, al hacer tap sobre él, hace aparecer
  a su alrededor una serie de botones que son los ítemes del menú. Al elegir un
  ítem desaparecen todos los demás bajo un anillo animado que abarca el menú y
  luego se disuelve y en seguida se ejecutan acciones definidas previamente.
  Los menús ubicados junto a alguno de los bordes o en las esquinas se autoajustan
  para no rebasar los bordes de la pantalla.

  Los elementos variables del menú son:
    - Ubicación. En la clase que llame a este componente se crea un widget que se
      pasa en los parámetros y el código lo usará para determinar las coordenadas
      del centro del menú, imprimiéndolo sobre el widget enviado
    - Ítemes: La cantidad y apariencia de cada ítem puede cambiarse si bien su
      tamaño actual por ahora es fijo
    - Acción al seleccionar un ítem: Para esta acción se pasa una función como
      parámetro, de modo que la ejecución es enteramente variable

  Parámetros
  ----------
  menu: conjunto de ítemes del menú de tipo MenuItem, compuestos por
    - id: cadena única para identificar el ítem cuando sea seleccionado
    - icon: IconData que se mostrará al usuario
    - bubbleColor: color de fondo
    - iconColor: color del icono
  radius: radio del círculo o arco que abarca el menú
  startAngle: ángulo en radianes donde inicia el círculo o arco y donde aparece
    el primer ítem; -pi/2 (90 grados) es el punto superior al centro
  endAngle: ángulo en radianes donde termina el círculo o arco y donde aparece
    el último ítem (si es un círculo, primero y último son el mismo item); para
    un circulo completo se usa 3*(pi/2) o 2*pi-(pi/2)
  child: widget que se usa como referencia para determinar la posición final del
    menú usando las coordenadas de dicho child como centro; en otras palabras,
    ésta es la manera indirecta de definir dónde se quiere ubicar el menú
  onSelected: función que se ejecutará cuando un ítem haya sido seleccionado, su
    parámetro itemId es el id del MenuItem

  Clases:
  -------
  - AnchoredRadialMenu: ubica el menú en su posición y en una capa sobre lo demás
    en pantalla; recibe un widget (child) que usará como referencia para
    determinar la posición
  - _AnchoredRadialMenuState: Crea una instancia de AnchoredOverlay la que, a
    partir del child de AnchoredRadialMenu la posición de dicho widget (su anchor)
    y justo sobre su centro, en el overlay, imprime una instancia de
    _CollidingRadialMenu
  - _CollidingRadialMenu recibe los parámetros finales para imprimir el menu
  - _CollidingRadialMenuState realiza los cálculos para determinar cómo se
    mostrará el menú. En caso de que la posición implique rebasar los límites de
    la pantalla calcula un nuevo arco y la posición angular de cada ítem. Además,
    siempre a partir de la posición y el tamaño angular final, calcula la apertura
    del anillo y la dirección en la que debe expandirse


  Notas:
  *1* Para prototipar en el video se usa fluttery; como el paquete original en su
  versión actual (0.0.7) no es compatible con Dart 2.0, el código fuente se
  copió a una carpeta local y luego se cambió su yaml para que admita Dart 2.0
  *2* Del mismo autor se usan directamente (no como librería externa) geometry.dart
  y radial_menu_collisions.dart para facilitar el manejo de ángulos y el cálculo
  de colisiones del menú con los bordes de la pantalla
  *3* Ver la segunda parte de la funcionalidad en el archivo RadialMenuInplementer.dart

*/


class AnchoredRadialMenu extends StatefulWidget{
  final Menu menu;
  final double radius;
  final double startAngle;
  final double endAngle;
  final Widget child;
  final bool showOverlay;
  final Function(String menuItemId) onSelected;

  AnchoredRadialMenu({
    this.menu,
    this.radius = 75.0,
    this.startAngle = -pi / 2,
    this.endAngle = 3 * pi / 2,
    this.child,
    this.showOverlay = true,
    this.onSelected});

  @override
  State createState() => _AnchoredRadialMenuState();
}

class _AnchoredRadialMenuState extends State<AnchoredRadialMenu>{

  @override
  Widget build(BuildContext context) {
    return AnchoredOverlay(   //parte de fluttery que ubica el widget overlay
        showOverlay: widget.showOverlay,
        child: widget.child,
        overlayBuilder: (BuildContext context, Rect rect, Offset anchor) {
          //todo aquí puede usarse RadialMenu
          return _CollidingRadialMenu(
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

class _CollidingRadialMenu extends StatefulWidget {
  final Menu menu;
  final Offset anchor;
  final double radius;
  final Arc arc;
  final bool debugMode;
  final void Function(String itemId) onSelected;
  final Widget child;

  _CollidingRadialMenu({
    this.menu,
    this.anchor,
    this.radius = 75.0,
    this.arc = const Arc(
      from: Angle.fromRadians(-pi / 2),
      to: Angle.fromRadians(2 * pi - (pi / 2)),
      direction: RadialDirection.clockwise,
    ),
    this.onSelected,
    this.debugMode = false,
    this.child,
  });

  @override
  _CollidingRadialMenuState createState() => new _CollidingRadialMenuState();
}

class _CollidingRadialMenuState extends State<_CollidingRadialMenu> {
  Arc radialArc;

  void _findNonCollidingArc(BoxConstraints constraints) {
    final origin = new Point<double>(widget.anchor.dx, widget.anchor.dy);
    final screenSize = new Size(constraints.maxWidth, constraints.maxHeight);
    final centerOfScreen = new Point(constraints.maxWidth / 2, constraints.maxHeight / 2);

    // Find where menu circle intersects the screen boundaries.
    Set<Point> intersections = intersect(
      screenSize,
      origin,
      widget.radius + (50.0 / 2),
    );

    if (intersections.length > 2) {
      print('${intersections.length} POINTS INTERSECTION');
      intersections = _reduceIntersections(intersections, origin, centerOfScreen);
    }

    if (intersections.length == 2) {
      print('Intersection points: ${intersections.first}, ${intersections.last}');

      // Choose a start angle and end angle based on menu points.
      radialArc = _createStartAndEndAnglesFromTwoPoints(
        intersections,
        origin,
        centerOfScreen,
      );

      // Adjust screen intersection points to leave room for bubble radii.
      radialArc = rotatePointsToMakeRoom(
        arc: radialArc,
        origin: origin,
        direction: centerOfScreen,
        radius: widget.radius,
        extraSpace: 50.0 / 2,
      );
    } else {
      radialArc = widget.arc;
    }
  }

  List<Widget> _buildDebugPoints(BoxConstraints constraints, Offset anchor) {
    final origin = new Point<double>(anchor.dx, anchor.dy);

    if (radialArc.sweepAngle() != Angle.fullCircle) {
      // Create debug dots
      Point startPoint = new Point(
        origin.x + (widget.radius * cos(radialArc.from.toRadians())),
        origin.y + (widget.radius * sin(radialArc.from.toRadians())),
      );

      Point endPoint = new Point(
        origin.x + (widget.radius * cos(radialArc.to.toRadians())),
        origin.y + (widget.radius * sin(radialArc.to.toRadians())),
      );

      List<Widget> dots = []..add(_createDot(startPoint))..add(_createDot(endPoint));

      return dots;
    } else {
      return const [];
    }
  }

  Arc _createStartAndEndAnglesFromTwoPoints(
      Set<Point> menuEdgePoints,
      Point origin,
      Point centerOfScreen,
      ) {
    if (menuEdgePoints.length != 2) {
      return const Arc.clockwise(
        from: Angle.zero,
        to: Angle.fullCircle,
      );
    }

    final directionToCenter =
    new Angle.fromRadians(new PolarCoord.fromPoints(origin, centerOfScreen).angle);

    bool isOnLeftSideOfScreen = origin.x < centerOfScreen.x;
    final isClockwise = isOnLeftSideOfScreen;
    print('isClockwise: $isClockwise');

    Angle angle1 =
    new Angle.fromRadians(new PolarCoord.fromPoints(origin, menuEdgePoints.first).angle);
    Arc arc1 = new Arc(
      from: angle1,
      to: directionToCenter,
      direction: isClockwise ? RadialDirection.clockwise : RadialDirection.counterClockwise,
    );
    Angle angle2 =
    new Angle.fromRadians(new PolarCoord.fromPoints(origin, menuEdgePoints.last).angle);
    Arc arc2 = new Arc(
      from: angle2,
      to: directionToCenter,
      direction: isClockwise ? RadialDirection.clockwise : RadialDirection.counterClockwise,
    );

    Angle startAngle;
    Angle endAngle;

    if (isClockwise) {
      // Menu should rotate clockwise.
      print('Menu should radiate clockwise.');
      print('Angle to center of screen is $directionToCenter');

      if (arc1.sweepAngle().toRadians().abs() < arc2.sweepAngle().toRadians().abs()) {
        print('$angle1 is closest to center, its the starting angle.');
        startAngle = angle1;
        endAngle = angle2;
      } else {
        print('$angle2 is closest to center, its the starting angle.');
        startAngle = angle2;
        endAngle = angle1;
      }
    } else {
      // Menu should rotate counter-clockwise.
      print('Menu should radiate counter-clockwise');
      if (arc1.sweepAngle().toRadians().abs() < arc2.sweepAngle().toRadians().abs()) {
        startAngle = angle1;
        endAngle = angle2;
      } else {
        startAngle = angle2;
        endAngle = angle1;
      }
    }
    print('Initial start angle: $startAngle');

    Angle intersectionAngle = startAngle;

    Angle angleToCenterOfScreen =
    new Angle.fromRadians(new PolarCoord.fromPoints(origin, centerOfScreen).angle);

    final Angle centerToIntersectDelta = angleToCenterOfScreen - intersectionAngle;
    print('angleToCenterOfScreen: $angleToCenterOfScreen, intersectionAngle: $intersectionAngle');
    print('centerToIntersectDelta: $centerToIntersectDelta');

    if (!isClockwise) {
      startAngle = new Angle.fromRadians(startAngle.toRadians(forcePositive: true));
      endAngle = new Angle.fromRadians(endAngle.toRadians(forcePositive: true));
    }

    print('Start angle: $startAngle, end angle: $endAngle');
    return isClockwise
        ? new Arc.clockwise(from: startAngle, to: endAngle)
        : new Arc.counterClockwise(from: startAngle, to: endAngle);
  }

  Set<Point> _reduceIntersections(Set<Point> intersections, Point origin, Point centerOfScreen) {
    Set<Point> twoPoints = new Set();

    final Angle directionToCenter =
    new Angle.fromRadians(new PolarCoord.fromPoints(origin, centerOfScreen).angle);

    Point closestClockwise;
    Angle closestClockwiseAngle;
    Point closestCounterClockwise;
    Angle closestCounterClockwiseAngle;

    for (Point intersection in intersections) {
      Angle intersectionAngle =
      new Angle.fromRadians(new PolarCoord.fromPoints(origin, intersection).angle);
      if (closestClockwise == null) {
        closestClockwise = intersection;
        closestClockwiseAngle = intersectionAngle;
      } else if (directionToCenter - intersectionAngle <
          directionToCenter - closestClockwiseAngle) {
        closestClockwise = intersection;
        closestClockwiseAngle = intersectionAngle;
      }

      if (closestCounterClockwise == null) {
        closestCounterClockwise = intersection;
        closestCounterClockwiseAngle = intersectionAngle;
      } else if (intersectionAngle - directionToCenter <
          closestCounterClockwiseAngle - directionToCenter) {
        closestCounterClockwise = intersection;
        closestCounterClockwiseAngle = intersectionAngle;
      }
    }
    twoPoints.add(closestClockwise);
    twoPoints.add(closestCounterClockwise);

    return twoPoints;
  }

  Widget _createDot(Point position) {
    return new Positioned(
      left: position.x,
      top: position.y,
      child: new FractionalTranslation(
        translation: const Offset(-0.5, -0.5),
        child: new Container(
          width: 20.0,
          height: 20.0,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        _findNonCollidingArc(constraints);
        List<Widget> dots = widget.debugMode ? _buildDebugPoints(constraints, widget.anchor) : [];

        return new Stack(
          children: <Widget>[
            new RadialMenu(
              menu: widget.menu,
              anchor: widget.anchor,
              radius: 75.0,
              arc: radialArc ?? widget.arc,
              onSelected: widget.onSelected,
            ),
          ]..addAll(dots),
        );
      },
    );
  }
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

