import 'package:flutter/foundation.dart';
import 'dart:convert';

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
  String login;
  String password;
  String names;
  String lastName1;
  String lastName2;
  int birthDate;
  bool flag;

  Person({
    this.id,
    this.login = '',
    this.password = '',
    this.names = '',
    this.lastName1 = '',
    this.lastName2 = '',
    this.birthDate = 19000101,
    this.flag = false,
  });

  factory Person.fromMap(Map<String, dynamic> json) => Person(
    id: json["id"],
    login: json["login"],
    password: json["password"],
    names: json["names"],
    lastName1: json["lastName1"],
    lastName2: json["lastName2"],
    birthDate: json["birthDate"],
    flag: json["flag"] == 1,
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "login": login,
    "password": password,
    "names": names,
    "lastName1": lastName1,
    "lastName2": lastName2,
    "birthDate": birthDate,
    "flag": flag,
  };

  Future<String> authenticate({
    @required String username,
    @required String password,
  }) async {
    await Future.delayed(Duration(seconds: 1));
    return 'token';
  }

  Future<void> deleteToken() async {
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<void> persistToken(String token) async {
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<bool> hasToken() async {
    await Future.delayed(Duration(seconds: 1));
    return false;
  }
}