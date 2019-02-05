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
  String login;
  String password;
  String names;
  String lastName1;
  String lastName2;
  DateTime birthDate;
  String token;
  DateTime tokenUpdate;
  int contactId;
  bool flag;

  Person({
    this.id,
    this.login,
    this.password,
    this.names,
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
    login: json["login"],
    password: json["password"],
    names: json["names"],
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
    "login": login,
    "password": password,
    "names": names,
    "lastName1": lastName1,
    "lastName2": lastName2,
    "birthDate": birthDate,
    "token": token,
    "tokenUpdate": tokenUpdate,
    "contactId": contactId,
    "flag": flag,
  };

  /*
  Future<String> authenticate({
    @required String username,
    @required String password,
  }) async {
      PersonBloc personBloc = PersonBloc();

      await Future.delayed(Duration(seconds: 1));
      return 'token';
    }

  Future<void> deleteToken() async {
    //borrar token al hacer logout
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<void> persistToken(String token) async {
    //éste método podría borrarse
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<bool> hasToken() async {
    //validar que el usuario actual tenga un token vigente
    await Future.delayed(Duration(seconds: 1));
    return false;
  }
  */
}