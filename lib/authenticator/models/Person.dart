import 'dart:convert';

import 'package:learning_flutter/authenticator/backend/Exports.dart';

Person fromJson(String jsonString) {
  final jsonData = json.decode(jsonString);
  return Person.fromMap(jsonData);
}

String clientToJson(Person data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Person {
  int id;
  String userName;
  String password;
  String firstName1;
  String firstName2;
  String lastName1;
  String lastName2;
  DateTime birthDate;
  String token;
  DateTime tokenUpdate;
  int contactId;
  bool flag;

  Person({
    this.id,
    this.userName = '',
    this.password,
    this.firstName1 = '',
    this.firstName2,
    this.lastName1,
    this.lastName2,
    this.birthDate,
    this.token,
    this.tokenUpdate,
    this.contactId,
    this.flag,
  });

  factory Person.fromMap(Map<String, dynamic> json) => Person(
    contactId: json["contactId"],
    userName: json["userName"],
    password: json["password"],
    firstName1: json["firstName1"],
    firstName2: json["firstName2"],
    lastName1: json["lastName1"],
    lastName2: json["lastName2"],
    birthDate: iso8601ToDateTime(json["birthDate"]),
    token: json["token"],
    tokenUpdate: iso8601ToDateTime(json["tokenUpdate"]),
    id: json["id"],
    flag: json["flag"] == 1,
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "userName": userName,
    "password": password,
    "firstName1": firstName1,
    "firstName2": firstName2,
    "lastName1": lastName1,
    "lastName2": lastName2,
    "birthDate": birthDate,
    "token": token,
    "tokenUpdate": tokenUpdate,
    "contactId": contactId,
    "flag": flag,
  };
}