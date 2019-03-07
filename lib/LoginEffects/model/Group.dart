import 'package:learning_flutter/LoginEffects/backend/exports.dart';
import 'package:learning_flutter/LoginEffects/backend/enums/exports.dart';
import 'SubjectBase.dart';

class Group extends SubjectBase{
  String idPersona;
  String name;

  Group({
    serverId,
    this.idPersona,
    this.name,
    birthDate,
    picture,
    message,
    status,
  }) : super(serverId: serverId,
    message: message,
    status: status,
    birthDate: birthDate,
    picture: picture,
    type: PartnerType.group,
  );

  factory Group.fromMap(Map<String, dynamic> json) => Group(
    serverId: json["serverId"],
    idPersona: json["idPersona"],
    name: json["name"],
    birthDate: iso8601ToDateTime(json["birthDate"]),
    picture: json["picture"],
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toMap() => {
    "serverId": serverId,
    "idPersona": idPersona,
    "name": name,
    "birthDate": birthDate,
    "picture": picture,
    "message": message,
    "status": status,
  };

  String fullName() => '$name';

  @override
  String toString() => '$name, ${dateTimeToShortString(birthDate)}';
}