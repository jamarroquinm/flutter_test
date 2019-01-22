import 'package:flutter/material.dart';
import 'package:fluttery/animations.dart';
import 'package:learning_flutter/RadialMenu/geometry.dart';
import 'package:learning_flutter/RadialMenu/radial_menu_collisions.dart';
import 'dart:math';
//import 'dart:ui';
//import 'dart:async';
import 'Components.dart';
import 'RegularRadialMenu.dart';

/*
  esta clase y _CollidingRadialMenuState manejan los menús en los bordes para no
   rebasarlos y sustituyen a RadialMenu y _RadialMenuState
*/
class CollidingRadialMenu extends StatefulWidget {
  final Menu menu;
  final Offset anchor;
  final double radius;
  final Arc arc;
  final bool debugMode;
  final void Function(String itemId) onSelected;
  final Widget child;

  CollidingRadialMenu({
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

class _CollidingRadialMenuState extends State<CollidingRadialMenu> {
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