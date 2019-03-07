import 'ModelBase.dart';

class GroupContact extends ModelBase{
  final String idGroup;
  final String idContact;
  final int order;

  GroupContact({
    serverId,
    this.idGroup,
    this.idContact,
    this.order,
    message,
    status,
  }) : super(serverId: serverId, message: message, status: status);

  factory GroupContact.fromMap(Map<String, dynamic> json) => GroupContact(
    serverId: json["serverId"],
    idGroup: json["idGroup"],
    idContact: json["idContact"],
    order: json["order"],
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toMap() => {
    "serverId": serverId,
    "idGroup": idGroup,
    "idContact": idContact,
    "order": order,
    "message": message,
    "status": status,
  };
}