import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class MainState extends Equatable {
  MainState([List props = const []]) : super(props);
}


class NoModuleActivated extends MainState {
  @override
  String toString() => 'NoModuleActivated';
}


class StartModuleActivated extends MainState {
  @override
  String toString() => 'StartModuleActivated';
}


class HomeModuleActivated extends MainState {
  @override
  String toString() => 'HomeModuleActivated';
}


class PartnerModuleActivated extends MainState {
  final bool isEdition;

  PartnerModuleActivated({@required this.isEdition})
  : super([isEdition]);

  @override
  String toString() => 'PartnerModuleActivated';
}


class ServicesModuleActivated extends MainState {
  @override
  String toString() => 'ServicesModuleActivated';
}
