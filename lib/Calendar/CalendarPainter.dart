import 'package:flutter/material.dart';
import 'dart:core';
import 'package:meta/meta.dart';

class CalendarPainter extends CustomPainter {
  final int month;
  final int year;
  final Function selectionCallback;
  final Map<DateTime, Color> highlightedDates;
  final Color backgroundColor;
  final Color lineColor;
  final Color daysNameFillColor;
  final TextStyle daysNameTextStyle;
  final TextStyle daysTextStyle;
  Size _size;
  int _daysInMonth;
  int _weeksInMonth;
  int _dayOneWeekday;


  CalendarPainter({
    @required this.month,
    @required this.year,
    @required this.selectionCallback,
    this.highlightedDates,
    this.backgroundColor = Colors.white,
    this.lineColor = Colors.black,
    this.daysNameFillColor = Colors.lightBlueAccent,
    this.daysNameTextStyle = const TextStyle(color: Colors.black, fontSize: 14.0),
    this.daysTextStyle = const TextStyle(color: Colors.black, fontSize: 14.0),
  }){
      _weeksInMonth = _getTotalWeeks(month, year);
      _daysInMonth = daysInMonth(month, year);
      _dayOneWeekday = DateTime(year, month, 1).weekday;
    }

  @override
  void paint(Canvas canvas, Size size) {
    _size = size;

    //fill background
    if(backgroundColor != null){
      Paint backgroundPaint = Paint()
        ..color = backgroundColor
        ..style = PaintingStyle.fill;
      canvas.drawRect(
          Rect.fromPoints(
              Offset(0.0, 0.0),
              Offset(_size.width, size.height)
          ),
          backgroundPaint
      );
    }

    if(lineColor != null){
      Paint linePaint = Paint()
        ..color = backgroundColor
        ..strokeWidth = 1.0
        ..strokeCap = StrokeCap.round;

      //border lines
      canvas.drawLine(Offset(0.0, 0.0), Offset(_size.width, 0.0), linePaint);
      canvas.drawLine(Offset(0.0, 0.0), Offset(0.0, size.height), linePaint);
      canvas.drawLine(Offset(0.0, size.height), Offset(_size.width, size.height), linePaint);
      canvas.drawLine(Offset(_size.width, 0.0), Offset(_size.width, size.height), linePaint);

      //rows lines
      for (int i = 1; i <= _weeksInMonth + 1; i++) {
        canvas.drawLine(
            Offset(0.0, i * size.height / (_weeksInMonth + 1)),
            Offset(_size.width, i * size.height / (_weeksInMonth + 1)),
            linePaint);
      }

      //columns lines
      canvas.drawLine(Offset(_size.width / 7, 0.0), Offset(_size.width / 7, size.height), linePaint);
      canvas.drawLine(Offset(2 * _size.width / 7, 0.0), Offset(2 * _size.width / 7, size.height), linePaint);
      canvas.drawLine(Offset(3 * _size.width / 7, 0.0), Offset(3 * _size.width / 7, size.height), linePaint);
      canvas.drawLine(Offset(4 * _size.width / 7, 0.0), Offset(4 * _size.width / 7, size.height), linePaint);
      canvas.drawLine(Offset(5 * _size.width / 7, 0.0), Offset(5 * _size.width / 7, size.height), linePaint);
      canvas.drawLine(Offset(6 * _size.width / 7, 0.0), Offset(6 * _size.width / 7, size.height), linePaint);
    }

    if(daysNameFillColor != null){
      //days row background color
      Paint daysNameFillPaint = Paint()
        ..color = daysNameFillColor
        ..style = PaintingStyle.fill;
      canvas.drawRect(
          Rect.fromPoints(
              Offset(0.0, 0.0),
              Offset(_size.width, size.height / (_weeksInMonth + 1))
          ),
          daysNameFillPaint
      );

    }

    //todo cambio de idioma
    //day name cells
    _drawText(canvas, Offset(0.0, 0.0), 'Lun', daysNameTextStyle);
    _drawText(canvas, Offset(_size.width / 7, 0.0), 'Mar', daysNameTextStyle);
    _drawText(canvas, Offset(2 * _size.width / 7, 0.0), 'Mie', daysNameTextStyle);
    _drawText(canvas, Offset(3 * _size.width / 7, 0.0), 'Jue', daysNameTextStyle);
    _drawText(canvas, Offset(4 * _size.width / 7, 0.0), 'Vie', daysNameTextStyle);
    _drawText(canvas, Offset(5 * _size.width / 7, 0.0), 'Sab', daysNameTextStyle);
    _drawText(canvas, Offset(6 * _size.width / 7, 0.0), 'Dom', daysNameTextStyle);


    //print numbers
    int day = 1;
    for (int w = 1; w <= _weeksInMonth; w++) {
      for (int d = 1; d <= 7; d++) {
        if((w == 1 && d >= _dayOneWeekday) || (w > 1 && day <= _daysInMonth)){
          Offset dayPosition = _getPositionFromDay(d, w);
          _drawText(canvas, dayPosition, '$day', daysTextStyle);

          int dayOfMonth = _findDayOfMonth(w, d);
          if(dayOfMonth > 0){
            DateTime date = DateTime(year, month, dayOfMonth);
            Color colorMark = _getColorMark(date);
            if(colorMark != null){
              _drawMark(canvas, dayPosition, colorMark);
            }
          }

          day += 1;
        }
      }
    }

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  @override
  bool hitTest(Offset hitPosition) {
    selectionCallback(_getSelectedDay(hitPosition));

    return null;
  }

  Offset _getPositionFromDay(int dayOfWeek, int weekNumber){
    double dx = (dayOfWeek - 1) * _size.width / 7;
    double dy = weekNumber * _size.height / (_weeksInMonth + 1);

    return Offset(dx, dy);
  }

  int _getSelectedDay(Offset hitPosition){
    /*
    La posición inicial de cada día se define así:
      x = (dayOfWeek - 1) * size.width / 7
      y = weekNumber * size.height / (weeksInMonth + 1)
    por lo que para encontrar el día despejamos:
      dayOfWeek = (x / size.width / 7) + 1
      weekNumber = y * (weeksInMonth + 1) / size.height

  */

    int dayOfWeek, weekNumber;
    dayOfWeek = (hitPosition.dx ~/ (_size.width / 7)) + 1;
    weekNumber = hitPosition.dy * (_weeksInMonth + 1) ~/ _size.height;

    return _findDayOfMonth(weekNumber, dayOfWeek);
  }

  int _findDayOfMonth(int weekNumber, int dayOfWeek){
    int day;

    if(weekNumber == 1 && dayOfWeek >= _dayOneWeekday){
      day = dayOfWeek - _dayOneWeekday + 1;
    } else if(weekNumber > 1) {
      int daysInWeek1 = 8 - _dayOneWeekday;
      int firstDayInSelectedWeek = ((weekNumber - 1) * 7) - daysInWeek1;
      day = firstDayInSelectedWeek + (dayOfWeek - 1);
    } else {
      day = 0;
    }

    return day;
  }

  Color _getColorMark(DateTime date){
    if(date == null || highlightedDates == null){
      return null;
    }

    Color color;
    for(DateTime k in highlightedDates.keys){
      if(k == date){
        color = highlightedDates[k];
        break;
      }
    }

    return color;
  }

  void _drawText(Canvas canvas, Offset offset, String text, TextStyle style) {
    TextPainter tp = TextPainter(
        text: TextSpan(style: style, text: text),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr
    );
    tp.layout();

    double dx = offset.dx + _size.width / 14 - tp.width / 2;
    double dy = offset.dy + _size.height / ((_weeksInMonth + 1) * 2) - tp.height / 2;
    tp.paint(canvas, Offset(dx, dy));
  }

  void _drawMark(Canvas canvas, Offset offset, Color color){
    double cellWidth = _size.width / 7;
    double cellHeight = _size.height / (_weeksInMonth + 1);
    double dx = offset.dx + cellWidth / 2;
    double dy = offset.dy + cellHeight / 2;
    Offset center = Offset(dx, dy);
    double radius;

    if(cellWidth > cellHeight){
      radius = cellHeight / 2 * 0.85;
    } else {
      radius = cellWidth / 2 * 0.85;
    }

    Paint paintFill = Paint()
      ..color = color.withOpacity(0.45)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paintFill);
  }
  
  int _getTotalWeeks(int month, int year){
      int daysAfterFirstWeek = 7 - DateTime(year, month, 1).weekday + 1;
      int remnantDaysInMonth = daysInMonth(month, year) - daysAfterFirstWeek;
      int _weeksInMonth = 1 + (remnantDaysInMonth / 7).ceil();


      return _weeksInMonth;
  }

  int daysInMonth(int month, int year){
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