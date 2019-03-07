import 'package:learning_flutter/LoginEffects/backend/exports.dart';
import 'package:learning_flutter/LoginEffects/backend/enums/exports.dart';

import 'SubjectBase.dart';

class Person extends SubjectBase{
  int idCountry;
  int idLanguage;
  String firstName1;
  String firstName2;
  String lastName1;
  String lastName2;
  final Plan plan;
  String genre;
  String email;
  String password;

  Person({
    serverId,
    this.idCountry,
    this.idLanguage,
    this.firstName1,
    this.firstName2,
    this.lastName1,
    this.lastName2,
    birthDate,
    picture,
    this.plan = Plan.free,
    this.genre,
    message,
    status,
    email,
    password,
  }) : super(serverId: serverId,
      message: message,
      status: status,
      birthDate: birthDate,
      picture: picture,
      type: null,
  );

  factory Person.fromMap(Map<String, dynamic> json) => Person(
      serverId: json["serverId"],
      idCountry: json["idCountry"],
      idLanguage: json["idLanguage"],
      firstName1: json["firstName1"],
      firstName2: json["firstName2"],
      lastName1: json["lastName1"],
      lastName2: json["lastName2"],
      birthDate: iso8601ToDateTime(json["birthDate"]),
      picture: json["picture"],
      plan: planEnumValueFromName(json["plan"]),
      genre: json["genre"],
      email: '',
      password: '',
    );


  Map<String, dynamic> toMap() => {
    "serverId": serverId,
    "idCountry": idCountry,
    "idLanguage": idLanguage,
    "firstName1": firstName1,
    "firstName2": firstName2,
    "lastName1": lastName1,
    "lastName2": lastName2,
    "birthDate": birthDate,
    "picture": picture,
    "plan": planNameFromEnumValue(plan),
    "genre": genre,
    "email": email,
    "password": password,
  };

  String fullName() => '$firstName1 '
      '${firstName2 != null ? firstName2 : ""} '
      '$lastName1'
      '${lastName2 != null ? " " + lastName2 : ""}';

  @override
  String toString() => '$firstName1 '
      '${firstName2 != null ? firstName2 : ""} '
      '$lastName1'
      '${lastName2 != null ? " " + lastName2 : ""}, '
      '${dateTimeToShortString(birthDate)}';
}