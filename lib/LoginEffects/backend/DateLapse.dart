import 'package:learning_flutter/LoginEffects/backend/exports.dart';
import 'package:learning_flutter/LoginEffects/backend/enums/exports.dart';

/*
To manage only 4 weeks per month always this way:
  - week 1, from day 1 to day 7
  - week 2, from day 8 to day 14
  - week 3, from day 15 to day 21
  - week 4, from day 22 to last day of the month
Day value:
  - With lapse.day is current day
  - With lapse.week day is given day or in same position that in their original week
  - With lapse.month is in same position that in their original month
  - With lapse.year is in same position that in their original year
 */

class DateLapse{
  int _weekNumber;
  int _month;
  int _year;
  DateTime _initialDay;
  DateTime _day;
  DateTime _finalDay;
  Lapse _lapse;
  bool _isFirstLapseInYear;
  bool _isLastLapseInYear;
  bool _canChangeYear;

  DateLapse.fromWeekDate(int weekNumber, DateTime originDate, bool canChangeYear){
    if(weekNumber == null || weekNumber <= 0){
      _weekNumber = 1;
    } else if(weekNumber > 4){
      _weekNumber = 4;
    } else {
      _weekNumber = weekNumber;
    }

    if(originDate == null){
      _month = 1;
      _year = DateTime.now().year;
    } else {
      _month = originDate.month;
      _year = originDate.year;
    }

    _calculateDatesOnWeek(originDate);
    _lapse = Lapse.week;
    _isFirstLapseInYear = _month == 1 && weekNumber == 1;
    _isLastLapseInYear = _month == 12 && _weekNumber == 4;
    _canChangeYear = canChangeYear;
  }

  DateLapse.fromDate(DateTime date, Lapse lapse, bool canChangeYear){
    if (date.day < 8) {
      this._weekNumber = 1;
    } else if (date.day < 15) {
      this._weekNumber = 2;
    } else if (date.day < 22) {
      this._weekNumber = 3;
    } else {
      this._weekNumber = 4;
    }

    _month = date.month;
    _year = date.year;
    _lapse = lapse;

    if(lapse == Lapse.day){
      _calculateDatesOnDay(date);
      _isFirstLapseInYear = _month == 1 && date.day == 1;
      _isLastLapseInYear = _month == 12 && date.day == 31;

    } else if(lapse == Lapse.week){
      _calculateDatesOnWeek(date);
      _isFirstLapseInYear = _month == 1 && _weekNumber == 1;
      _isLastLapseInYear = _month == 12 && _weekNumber == 4;

    } else if(lapse == Lapse.month){
      _calculateDatesOnMonth(date);
      _isFirstLapseInYear = _month == 1;
      _isLastLapseInYear = _month == 12;

    } else if(lapse == Lapse.year){
      _calculateDatesOnYear(date);
      _isFirstLapseInYear = false;
      _isLastLapseInYear = false;
    }

    _canChangeYear = canChangeYear;
  }

  static DateLapse calculateNextDateLapse(DateLapse origin){
    return calculateNextDateLapseWithLapse(origin, origin.lapse);
  }

  static DateLapse calculateNextDateLapseWithLapse(DateLapse origin, Lapse lapse, ){
    DateLapse nextDateLapse;

    if(lapse == Lapse.day){
      nextDateLapse = DateLapse.fromDate(origin.day.add(Duration(days: 1)),
          lapse, origin.canChangeYear);

    } else if(lapse == Lapse.week){
      DateTime newDate;
      int newWeekNumber;

      if(origin.weekNumber < 4){
        newDate = origin.day.add(Duration(days: 7));
        newWeekNumber = origin.weekNumber + 1;
      } else {
        newDate = getNextMonth(origin.day);
        newWeekNumber = 1;
      }
      nextDateLapse = DateLapse.fromWeekDate(newWeekNumber, newDate, origin.canChangeYear);

    } else if(lapse == Lapse.month){
      nextDateLapse = DateLapse.fromDate(getNextMonth(origin.day), lapse, origin.canChangeYear);

    } else if(lapse == Lapse.year){
      DateTime newDate = DateTime(origin.day.year + 1, origin.day.month, origin.day.day);
      nextDateLapse = DateLapse.fromDate(newDate, lapse, origin.canChangeYear);
    }

    if(!origin.canChangeYear && origin.day.year < nextDateLapse.day.year){
      return null;
    }

    return nextDateLapse;
  }

  static DateLapse calculatePreviousDateLapse(DateLapse origin){
    return calculatePreviousDateLapseWithLapse(origin, origin.lapse);
  }

  static DateLapse calculatePreviousDateLapseWithLapse(DateLapse origin, Lapse lapse){
    DateLapse previousDateLapse;

    if(lapse == Lapse.day){
      previousDateLapse = DateLapse.fromDate(origin.day.add(Duration(days: -1)),
          lapse, origin.canChangeYear);

    } else if(lapse == Lapse.week){
      DateTime newDate;
      int newWeekNumber;

      if(origin.weekNumber > 1){
        newDate = origin.day.add(Duration(days: -7));
        newWeekNumber = origin.weekNumber - 1;
      } else {
        newDate = getPreviousMonth(origin.day);
        newWeekNumber = 4;
      }
      previousDateLapse = DateLapse.fromWeekDate(newWeekNumber, newDate, origin.canChangeYear);

    } else if(lapse == Lapse.month){
      previousDateLapse = DateLapse.fromDate(getPreviousMonth(origin.day), lapse, origin.canChangeYear);

    } else if(lapse == Lapse.year){
      DateTime newDate = DateTime(origin.day.year - 1, origin.day.month, origin.day.day);
      previousDateLapse = DateLapse.fromDate(newDate, lapse, origin.canChangeYear);
    }

    if(!origin.canChangeYear && origin.day.year > previousDateLapse.day.year){
      return null;
    }

    return previousDateLapse;
  }


  void _calculateDatesOnDay(DateTime originDate){
    _initialDay = originDate;
    _day = originDate;
    _finalDay = originDate;
  }

  void _calculateDatesOnWeek(DateTime originDate){
    if(_weekNumber == 1){
      _initialDay = DateTime(_year, _month, 1);
      _day = DateTime(_year, _month, originDate.weekday);
      _finalDay = DateTime(_year, _month, 7);
    } else if(_weekNumber == 2){
      _initialDay = DateTime(_year, _month, 8);
      _day = DateTime(_year, _month, originDate.weekday + 7);
      _finalDay = DateTime(_year, _month, 14);
    } else if(_weekNumber == 3){
      _initialDay = DateTime(_year, _month, 15);
      _day = DateTime(_year, _month, originDate.weekday + 14);
      _finalDay = DateTime(_year, _month, 21);
    } else {
      _initialDay = DateTime(_year, _month, 22);
      _day = DateTime(_year, _month, originDate.weekday + 21);
      _finalDay = DateTime(_year, _month, lastDayOfMonth(_initialDay));
    }

  }

  void _calculateDatesOnMonth(DateTime originDate){
    _initialDay = DateTime(_year, _month, 1);
    _day = originDate;
    _finalDay = DateTime(_year, _month, lastDayOfMonth(_initialDay));
  }

  void _calculateDatesOnYear(DateTime originDate){
    _initialDay = DateTime(_year, 1, 1);
    _day = originDate;
    _finalDay = DateTime(_year, 12, 31);
  }


  int get weekNumber => _weekNumber;
  int get month => _month;
  int get year => _year;
  DateTime get initialDay => _initialDay;
  DateTime get day => _day;
  DateTime get finalDay => _finalDay;
  Lapse get lapse => _lapse;
  bool get isFirstLapseInYear => _isFirstLapseInYear;
  bool get isLastLapseInYear => _isLastLapseInYear;
  bool get canChangeYear => _canChangeYear;
}