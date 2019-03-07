import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:core';

class CalendarPainter extends CustomPainter {
  final int month;
  final int year;
  double _height;
  double _width;
  Paint _paint;
  Paint _paintFill;

  CalendarPainter({this.month, this.year}){
      _paint = Paint()
        ..color = Colors.black
        ..strokeWidth = 1.0
        ..strokeCap = StrokeCap.round;
      _paintFill = Paint()
        ..color = Colors.green.withOpacity(0.45)
        ..style = PaintingStyle.fill;
    }

  @override
  void paint(Canvas canvas, Size size) {
    _width = size.width;
    _height = size.height;
    int totalWeeks = _getTotalWeeks(month, year);
    int daysInMonth = _daysInMonth(month, year);
    int weekDay = DateTime(year, month, 1).weekday;

    //border lines
    canvas.drawLine(Offset(0.0, 0.0), Offset(_width, 0.0), _paint);
    canvas.drawLine(Offset(0.0, 0.0), Offset(0.0, _height), _paint);
    canvas.drawLine(Offset(0.0, _height), Offset(_width, _height), _paint);
    canvas.drawLine(Offset(_width, 0.0), Offset(_width, _height), _paint);

    //rows lines
    for (int i = 1; i <= totalWeeks + 1; i++) {
      canvas.drawLine(
          Offset(0.0, i * _height / (totalWeeks + 1)),
          Offset(_width, i * _height / (totalWeeks + 1)),
          _paint);
    }
    
    //columns lines
    canvas.drawLine(Offset(_width / 7, 0.0), Offset(_width / 7, _height), _paint);
    canvas.drawLine(Offset(2 * _width / 7, 0.0), Offset(2 * _width / 7, _height), _paint);
    canvas.drawLine(Offset(3 * _width / 7, 0.0), Offset(3 * _width / 7, _height), _paint);
    canvas.drawLine(Offset(4 * _width / 7, 0.0), Offset(4 * _width / 7, _height), _paint);
    canvas.drawLine(Offset(5 * _width / 7, 0.0), Offset(5 * _width / 7, _height), _paint);
    canvas.drawLine(Offset(6 * _width / 7, 0.0), Offset(6 * _width / 7, _height), _paint);

    //days row background color
    canvas.drawRect(
        Rect.fromPoints(
            Offset(0.0, 0.0),
            Offset(_width, _height / (totalWeeks + 1))
        ),
        _paintFill
    );

    //day name cells
    drawText(canvas, size, new Offset(0.0, 0.0), 'Lun');
    drawText(canvas, size, new Offset(_width / 7, 0.0), 'Mar');
    drawText(canvas, size, new Offset(2 * _width / 7, 0.0), 'Mie');
    drawText(canvas, size, new Offset(3 * _width / 7, 0.0), 'Jue');
    drawText(canvas, size, new Offset(4 * _width / 7, 0.0), 'Vie');
    drawText(canvas, size, new Offset(5 * _width / 7, 0.0), 'Sab');
    drawText(canvas, size, new Offset(6 * _width / 7, 0.0), 'Dom');


    //print numbers
    int day = 1;
    for (int w = 1; w <= totalWeeks; w++) {
      for (int d = 1; d <= 7; d++) {
        if((w == 1 && d >= weekDay) || (w > 1 && day <= daysInMonth)){
          Offset offset = Offset((d - 1) * _width / 7, w * _height / (totalWeeks + 1));
          drawText(canvas, size, offset, '$day');
          print('($w,$d): $day');
          day += 1;
        }
      }
    }

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  void drawText(Canvas canvas, Size size, Offset offset,
      String text, [Color color = Colors.black]) {

    int numberOfRowLine = 4;
    TextPainter tp = TextPainter(
        text: TextSpan(style: TextStyle(color: color), text: text),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr
    );
    tp.layout();

    double dx = offset.dx + size.width / 14 - tp.width / 2;
    double dy = offset.dy + size.height / (2 * numberOfRowLine + 2) - tp.height / 2;
    tp.paint(canvas, Offset(dx, dy));
  }

  int _getTotalWeeks(int month, int year){
      int daysAfterFirstWeek = 7 - DateTime(year, month, 1).weekday + 1;
      int remnantDaysInMonth = _daysInMonth(month, year) - daysAfterFirstWeek;
      int totalWeeks = 1 + (remnantDaysInMonth / 7).ceil();

      print('$month/$year  - $totalWeeks');

      return totalWeeks;
  }

  int _daysInMonth(int month, int year){
      if(month == 1 || month == 3 || month == 5 || month == 7 ||
          month == 8 || month == 10 || month == 12){
        return 31;
      } else  if(month == 4 || month == 6 || month == 9 || month == 11){
        return 30;
      } else if(year % 4 == 0){
        return 29;
      } else {
        return 28;
      }
  }
}