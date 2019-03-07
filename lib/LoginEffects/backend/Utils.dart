import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart' as intl_local_date_data;

import 'package:learning_flutter/LoginEffects/backend/enums/exports.dart';
import 'package:learning_flutter/LoginEffects/model/ModelBase.dart';
import 'Settings.dart';

LanguageCode getLanguageCode(){
  //todo implement how to catch

  return LanguageCode.es;

}

String dateTimeToIso8601(DateTime date){
  if(date == null){
    return defaultStrDateTime;
  }

  var formatter = DateFormat(iso8601Format);
  return formatter.format(date);
}

String dateTimeToShortString(DateTime date) {
  if(date == null){
    return "";
  }

  intl_local_date_data.initializeDateFormatting();

  String pattern;
  String locale;
  LanguageCode code = getLanguageCode();

  if(code == LanguageCode.es){
    pattern = "d'/'MM'/'yyyy";
    locale = "es-mx";
  } else if (code == LanguageCode.en){
    pattern = "MM'/'d'/'yyyy";
    locale = "en-us";
  } else {
    pattern = "d'/'MM'/'yyyy";
    locale = "es-mx";
  }

  var formatter = DateFormat(pattern, locale);
  return formatter.format(date);
}

String dateTimeToLongString(DateTime date) {
  if(date == null){
    return "";
  }

  intl_local_date_data.initializeDateFormatting();

  String pattern;
  String locale;
  LanguageCode code = getLanguageCode();

  if(code == LanguageCode.es){
    if(date.year >= 2000){
      pattern = "d 'de' MMMM 'del' yyyy";
    } else {
      pattern = "d 'de' MMMM 'de' yyyy";
    }
    locale = "es-mx";

  } else if (code == LanguageCode.en){
    pattern = "MMMM d',' yyyy";
    locale = "en-us";

  } else {
    if(date.year >= 2000){
      pattern = "d 'de' MMMM 'del' yyyy";
    } else {
      pattern = "d 'de' MMMM 'de' yyyy";
    }
    locale = "es-mx";
  }

  var formatter = DateFormat(pattern, locale);
  return formatter.format(date);
}

String lapseToLongString(DateTime initialDate, DateTime finalDate) {
  if(initialDate == null || finalDate == null){
    return "";
  }

  if(initialDate == finalDate){
    return dateTimeToLongString(initialDate);
  }

  String range;
  if(initialDate.isBefore(finalDate)){
    range = '${initialDate.day}-${finalDate.day}';
  } else {
    range = '${finalDate.day}-${initialDate.day}';
  }

  intl_local_date_data.initializeDateFormatting();

  String pattern;
  String locale;
  LanguageCode code = getLanguageCode();

  if(code == LanguageCode.es){
    locale = "es-mx";
    if(initialDate.year >= 2000){
      pattern = "'@ de' MMMM 'del' yyyy";
    } else {
      pattern = "'@ de' MMMM 'de' yyyy";
    }

  } else if (code == LanguageCode.en){
    pattern = "MMMM @, yyyy";
    locale = "en-us";

  } else {
    locale = "es-mx";
    if(initialDate.year >= 2000){
      pattern = "'@ de' MMMM 'del' yyyy";
    } else {
      pattern = "'@ de' MMMM 'de' yyyy";
    }
  }


  var formatter = DateFormat(pattern, locale);
  String result = formatter.format(initialDate);

  return result.replaceFirst('@', range);
}

String monthToLongString(DateTime date) {
  if(date == null){
    return "";
  }

  intl_local_date_data.initializeDateFormatting();

  String pattern;
  String locale;
  LanguageCode code = getLanguageCode();

  if(code == LanguageCode.es){
    locale = "es-mx";
    if(date.year >= 2000){
      pattern = "MMMM 'del' yyyy";
    } else {
      pattern = "MMMM 'de' yyyy";
    }
  } else if (code == LanguageCode.en){
    pattern = "MMMM yyyy";
    locale = "en-us";
  } else {
    if(date.year >= 2000){
      pattern = "MMMM 'del' yyyy";
    } else {
      pattern = "MMMM 'de' yyyy";
    }
    locale = "es-mx";
  }

  var formatter = DateFormat(pattern, locale);
  return formatter.format(date);
}

DateTime iso8601ToDateTime(String date){
  if(date == null || date == ''){
    return defaultDateTime;
  }

  DateTime result;
  try{
    result = DateTime.parse(date);
  } catch(e){
    result = defaultDateTime;
  }

  return result;
}

bool existRegister(ModelBase instance){
  return instance != null && instance.serverId != null && instance.serverId != '';
}

int lastDayOfMonth(DateTime date){
  int month = date.month;

  if(month == 1 || month == 3 || month == 5 || month == 7 || month == 8
      || month == 10 || month == 12){
    return 31;
  } else if(date.month == 4 || month == 6 || month == 9 || month == 11) {
    return 30;
  } else if(date.year % 4 == 0){
    return 29;
  } else {
    return 28;
  }
}

DateTime getNextMonth(DateTime date){
  DateTime nextDate;
  if(date.month < 12){
    nextDate = DateTime(date.year, date.month + 1, date.day);
  } else {
    nextDate = DateTime(date.year + 1, 1, date.day);
  }

  return nextDate;
}

DateTime getPreviousMonth(DateTime date){
  DateTime nextDate;
  if(date.month > 1){
    nextDate = DateTime(date.year, date.month - 1, date.day);
  } else {
    nextDate = DateTime(date.year - 1, 12, date.day);
  }

  return nextDate;
}


//enums
Category categoryEnumValueFromName(String name){
  if(name == null || name == ''){
    return Category.love;
  }

  Category type;
  try{
    type = Category.values.firstWhere((e) => e.toString() == name);
  } catch(ex) {
    try{
      type = Category.values.firstWhere((e) => e.toString() == 'Category.' + name);
    } catch(ex2){
      type = null;
    }
  }

  return type == null ? Category.love : type;
}

String categoryNameFromEnumValue(Category value){
  if(value == null){
    return null;
  }

  return value.toString().substring(value.toString().indexOf('.') + 1);
}

LanguageCode languageCodeEnumValueFromName(String name){
  LanguageCode type;
  try{
    type = LanguageCode.values.firstWhere((e) => e.toString() == name);
  } catch(ex) {
    try{
      type = LanguageCode.values.firstWhere((e) => e.toString() == 'LanguageCode.' + name);
    } catch(ex2){
      type = null;
    }
  }

  return type == null ? LanguageCode.es : type;
}

String languageCodeNameFromEnumValue(LanguageCode value){
  if(value == null){
    return null;
  }

  return value.toString().substring(value.toString().indexOf('.') + 1);
}

Lapse lapseEnumValueFromName(String name){
  Lapse type;
  try{
    type = Lapse.values.firstWhere((e) => e.toString() == name);
  } catch(ex) {
    try{
      type = Lapse.values.firstWhere((e) => e.toString() == 'Lapse.' + name);
    } catch(ex2){
      type = null;
    }
  }

  return type == null ? Lapse.day : type;
}

String lapseNameFromEnumValue(Lapse value){
  if(value == null){
    return null;
  }

  return value.toString().substring(value.toString().indexOf('.') + 1);
}

Plan planEnumValueFromName(String name){
  Plan type;
  try{
    type = Plan.values.firstWhere((e) => e.toString() == name);
  } catch(ex) {
    try{
      type = Plan.values.firstWhere((e) => e.toString() == 'Plan.' + name);
    } catch(ex2){
      type = null;
    }
  }

  return type == null ? Plan.free : type;
}

String planNameFromEnumValue(Plan value){
  if(value == null){
    return null;
  }

  return value.toString().substring(value.toString().indexOf('.') + 1);
}

PartnerType partnerTypeEnumValueFromName(String name){
  PartnerType type;
  try{
    type = PartnerType.values.firstWhere((e) => e.toString() == name);
  } catch(ex) {
    try{
      type = PartnerType.values.firstWhere((e) => e.toString() == 'UserType.' + name);
    } catch(ex2){
      type = null;
    }
  }

  return type == null ? PartnerType.contact : type;
}

String partnerTypeNameFromEnumValue(PartnerType value){
  if(value == null){
    return null;
  }

  return value.toString().substring(value.toString().indexOf('.') + 1);
}
