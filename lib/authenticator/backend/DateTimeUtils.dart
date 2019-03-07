import 'package:intl/intl.dart';

final DateTime defaultDateTime = DateTime(1900, 1, 1);
final String defaultStrDateTime = '19000101T000000';
final String _iso8601Format = 'yyyyMMddThhmmss';
final int daysExpirationToken = 1;

String dateTimeToIso8601(DateTime date){
  if(date == null){
    return defaultStrDateTime;
  }

  var formatter = new DateFormat(_iso8601Format);
  return formatter.format(date);
}

DateTime iso8601ToDateTime(String date){
  if(date == null || date == ''){
    return defaultDateTime;
  }

  return DateTime.parse(date);
}
