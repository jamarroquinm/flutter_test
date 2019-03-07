import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:learning_flutter/LoginEffects/backend/enums/exports.dart';
import 'package:learning_flutter/LoginEffects/model/exports.dart';

abstract class PartnerState extends Equatable {
  PartnerState([List props = const []]) : super(props);
}

class PartnerUninitialized extends PartnerState {
  @override
  String toString() => 'PartnerUninitialized';
}


class PartnerLoading extends PartnerState {
  @override
  String toString() => 'PartnerLoading';
}


class PartnerListing extends PartnerState {
  final PartnerType type;

  PartnerListing({@required this.type}) : super([type]);

  @override
  String toString() => 'PartnerListing { type: ${type.toString()} }';
}


class PartnerEditing extends PartnerState {
  final SubjectBase partner;
  final PartnerType type;

  PartnerEditing({@required this.partner, @required this.type})
      : super([partner, type]);

  @override
  String toString() => 'PartnerEditing { id: ${partner.toString()}, type: ${type.toString()} }';
}


class PartnerEditingFailure extends PartnerState {
  final SubjectBase partner;
  final PartnerType type;

  PartnerEditingFailure({@required this.partner, @required this.type})
      : super([partner, type]);

  @override
  String toString() => 'PartnerEditingFailure { id: ${partner.serverId}, '
      'type: ${type.toString()}, error: ${partner.message} }';
}


class MatcherEditing extends PartnerState {
  final SubjectBase partner;
  final PartnerType partnerType;
  final PartnerType newMatchType;

  MatcherEditing({@required this.partner, @required this.partnerType,
  @required this.newMatchType})
      : super([partner, partnerType, newMatchType]);

  @override
  String toString() => 'MatcherEditing { id: ${partner.serverId}, '
      'type: ${partnerType.toString()}, '
      'Match with: ${newMatchType.toString()} }';
}


class MatcherEditingFailure extends PartnerState {
  final SubjectBase partner;
  final PartnerType partnerType;
  final PartnerType newMatchType;

  MatcherEditingFailure({@required this.partner, @required this.partnerType,
    @required this.newMatchType})
      : super([partner, partnerType, newMatchType]);

  @override
  String toString() => 'MatcherEditingFailure { id: ${partner.serverId}, '
      'type: ${partnerType.toString()}, '
      'Match with: ${newMatchType.toString()} }, '
      'error: ${partner.message}';
}


class PartnerExiting extends PartnerState {
  @override
  String toString() => 'Exiting';
}

