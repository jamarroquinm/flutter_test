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
    Map<DateTime, Color> highlightedDates = {
      DateTime(2019, 2, 3) : Colors.lime,
      DateTime(2019, 2, 3) : Colors.lime,
      DateTime(2019, 2, 25) : Colors.yellow,
      DateTime(2019, 3, 3) : Colors.lime,
    };


    Offset _tapPosition;

    void _handleTapDown(TapDownDetails details) {
      final RenderBox referenceBox = context.findRenderObject();
      setState(() {
        _tapPosition = referenceBox.globalToLocal(details.globalPosition);
        print('${_tapPosition.dx}, ${_tapPosition.dy}');

      });
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Calendario")),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
/*
              GestureDetector(
                onTapUp: selectDate,
                child: CustomPaint(
                  child: Container(height: 200,),
                  painter: CalendarPainter(month: month + 1, year: year),
                ),
              ),
*/
              CustomPaint(
                child: Container(height: 200,),
                painter: CalendarPainter(
                  month: month,
                  year: year,
                  selectionCallback: selectDate,
                  highlightedDates: highlightedDates,
                  backgroundColor: Colors.purple,
                  daysNameFillColor: Colors.deepPurpleAccent,
                  daysNameTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  daysTextStyle: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),

        ),
      ),
    );
  }

  void selectDate(int selectedDay) {
    print('Home: día elegido=$selectedDay');
  }


}