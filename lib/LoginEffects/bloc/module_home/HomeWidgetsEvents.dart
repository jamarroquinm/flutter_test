import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'package:learning_flutter/LoginEffects/backend/enums/exports.dart';

abstract class HomeWidgetsEvent extends Equatable {
  HomeWidgetsEvent([List props = const []]) : super(props);
}


class ChangeCategoryButtonPressed extends HomeWidgetsEvent {
  final Category category;

  ChangeCategoryButtonPressed({
    @required this.category,}) : super([category]);

  @override
  String toString() => 'ChangeCategoryButtonPressed';
}


class AddPartnerButtonPressed extends HomeWidgetsEvent {
  @override
  String toString() => 'AddPartnerButtonPressed';
}


class RemovePartnerButtonPressed extends HomeWidgetsEvent {
  @override
  String toString() => 'RemovePartnerButtonPressed';

}


class ForwardButtonPressed extends HomeWidgetsEvent {
  @override
  String toString() => 'ForwardButtonPressed';
}


class BackwardButtonPressed extends HomeWidgetsEvent {
  @override
  String toString() => 'BackwardButtonPressed';
}


class ChangeLapseButtonPressed extends HomeWidgetsEvent {
  final Lapse lapse;

  ChangeLapseButtonPressed({@required this.lapse,}) : super([lapse]);

  @override
  String toString() => 'ChangeLapseButtonPressed';
}


class ChangeServiceButtonPressed extends HomeWidgetsEvent {
  final bool isEnergy;

  ChangeServiceButtonPressed({
    @required this.isEnergy,}) : super([isEnergy]);

  @override
  String toString() => 'ChangeServiceButtonPressed';
}


class ShareButtonPressed extends HomeWidgetsEvent {
  @override
  String toString() => 'ShareButtonPressed';
}
