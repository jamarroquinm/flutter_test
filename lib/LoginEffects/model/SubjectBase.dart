import 'package:learning_flutter/LoginEffects/backend/enums/exports.dart';
import 'KeyNumbers.dart';
import 'ModelBase.dart';

abstract class SubjectBase extends ModelBase{
  DateTime birthDate;
  String picture;
  KeyNumbers numbers;
  final PartnerType type;

  SubjectBase({
    serverId,
    message,
    status,
    this.birthDate,
    this.picture,
    this.type,
  }) : super(serverId: serverId, message: message, status: status);

  String fullName();
}