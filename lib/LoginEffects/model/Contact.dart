import 'package:learning_flutter/LoginEffects/backend/exports.dart';
import 'package:learning_flutter/LoginEffects/backend/enums/exports.dart';

import 'SubjectBase.dart';

class Contact extends SubjectBase{
  final String idPerson;
  String firstName1;
  String firstName2;
  String lastName1;
  String lastName2;

  Contact({
    serverId,
    this.idPerson,
    this.firstName1,
    this.firstName2,
    this.lastName1,
    this.lastName2,
    birthDate,
    picture,
    message,
    status,
  }) : super(serverId: serverId,
    message: message,
    status: status,
    birthDate: birthDate,
    picture: picture,
    type: PartnerType.contact,
  );

  factory Contact.fromMap(Map<String, dynamic> json) => Contact(
    serverId: json["serverId"],
    idPerson: json["idPerson"],
    firstName1: json["firstName1"],
    firstName2: json["firstName2"],
    lastName1: json["lastName1"],
    lastName2: json["lastName2"],
    birthDate: iso8601ToDateTime(json["birthDate"]),
    picture: json["picture"],
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toMap() => {
    "serverId": serverId,
    "idPerson": idPerson,
    "firstName1": firstName1,
    "firstName2": firstName2,
    "lastName1": lastName1,
    "lastName2": lastName2,
    "birthDate": birthDate,
    "picture": picture,
    "message": message,
    "status": status,
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