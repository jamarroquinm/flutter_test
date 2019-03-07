import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'package:learning_flutter/LoginEffects/backend/enums/exports.dart';
import 'package:learning_flutter/LoginEffects/model/exports.dart';

abstract class PartnerEvent extends Equatable {
  PartnerEvent([List props = const []]) : super(props);
}


class PartnerInitiated extends PartnerEvent {
  @override
  String toString() => 'PartnerInitiated';
}


class PartnerListItemSelected extends PartnerEvent {
  final String partnerId;
  final PartnerType type;

  PartnerListItemSelected({@required this.partnerId, @required this.type})
      : super([partnerId, type]);

  @override
  String toString() => 'PartnerSelected';
}


class ChangePartnerPageButtonPressed extends PartnerEvent {
  final PartnerType currentType;
  final PartnerType newType;

  ChangePartnerPageButtonPressed({@required this.currentType, @required this.newType})
      : super([currentType, newType]);

  @override
  String toString() => 'ChangePartnerPageButtonPressed';
}


class ExitPartnersListButtonPressed extends PartnerEvent {
  final PartnerType currentType;

  ExitPartnersListButtonPressed({@required this.currentType})
      : super([currentType]);

  @override
  String toString() => 'ExitPartnersListButtonPressed';
}


class PartnerSaveButtonPressed extends PartnerEvent {
  final SubjectBase partner;
  final PartnerType currentType;

  PartnerSaveButtonPressed({@required this.partner, @required this.currentType})
      : super([partner, currentType]);

  @override
  String toString() => 'PartnerSaveButtonPressed';
}


class PartnerDeleteButtonPressed extends PartnerEvent {
  final SubjectBase partner;
  final PartnerType currentType;

  PartnerDeleteButtonPressed({@required this.partner, @required this.currentType})
      : super([partner, currentType]);

  @override
  String toString() => 'PartnerDeleteButtonPressed';
}


class OpenMatcherButtonPressed extends PartnerEvent {
  final String partnerId;
  final PartnerType partnerType;
  final PartnerType newMatchType;

  OpenMatcherButtonPressed({@required this.partnerId,
    @required this.partnerType, @required this.newMatchType})
      : super([partnerId, partnerType, newMatchType]);

  @override
  String toString() => 'OpenMatcherButtonPressed';
}


class ExitPartnerEditionButtonPressed extends PartnerEvent {
  final PartnerType currentType;

  ExitPartnerEditionButtonPressed({@required this.currentType})
      : super([currentType]);

  @override
  String toString() => 'ExitPartnerEditionButtonPressed';
}


class MatchButtonPressed extends PartnerEvent {
  final GroupContact groupContact;
  final PartnerType editingType;

  MatchButtonPressed({@required this.groupContact, @required this.editingType})
      : super([groupContact, editingType]);

  @override
  String toString() => 'MatchButtonPressed';
}


class RemoveMatchButtonPressed extends PartnerEvent {
  final GroupContact groupContact;
  final PartnerType editingType;

  RemoveMatchButtonPressed({@required this.groupContact, @required this.editingType})
      : super([groupContact, editingType]);

  @override
  String toString() => 'RemoveMatchButtonPressed';
}


class ExitMatcherButtonPressed extends PartnerEvent {
  final String partnerId;
  final PartnerType type;

  ExitMatcherButtonPressed({@required this.partnerId, @required this.type})
      : super([partnerId, type]);

  @override
  String toString() => 'ExitMatcherButtonPressed';
}
