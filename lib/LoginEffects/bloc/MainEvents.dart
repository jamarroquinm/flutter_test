import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class MainEvent extends Equatable {
  MainEvent([List props = const []]) : super(props);
}

class StartingApp extends MainEvent {
  @override
  String toString() => 'StartingApp';
}


class ActivatingStartModule extends MainEvent {
  @override
  String toString() => 'ActivatingStartModule';
}


class ActivatingHomeModule extends MainEvent {
  @override
  String toString() => 'ActivatingHomeModule';
}


class ActivatingPartnerModule extends MainEvent {
  final bool isEdition;

  ActivatingPartnerModule({@required this.isEdition})
      : super([isEdition]);

  @override
  String toString() => 'ActivatingPartnerModule';
}


class ActivatingServicesModule extends MainEvent {
  @override
  String toString() => 'ActivatingServicesModule';
}