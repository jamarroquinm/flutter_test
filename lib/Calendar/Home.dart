import 'package:flutter/material.dart';
import 'CalendarPainter.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    int month = 2;
    int year = 2019;
    Offset _tapPosition;
    CalendarPainter painter = CalendarPainter(month: month, year: year);

    GestureDetector touch = GestureDetector(
      onTapUp: selectDate,
      child: Container(height: 300,),
    );


    void _handleTapDown(TapDownDetails details) {
      final RenderBox referenceBox = context.findRenderObject();
      setState(() {
        _tapPosition = referenceBox.globalToLocal(details.globalPosition);
      });
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Calendario")),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: CustomPaint(
            child: touch,
            painter: painter,
          ),
        ),
      ),
    );
  }

  void selectDate(TapUpDetails position) {
    print('${position.globalPosition.dx}, ${position.globalPosition.dy}');
/*
      painter.select(Offset(
          position.globalPosition.dx - 16.0, position.globalPosition.dy - 247.0));
*/
  }


}