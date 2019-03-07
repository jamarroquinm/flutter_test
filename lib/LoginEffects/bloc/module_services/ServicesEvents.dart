import 'package:equatable/equatable.dart';

abstract class ServiceEvent extends Equatable {
  ServiceEvent([List props = const []]) : super(props);
}


class ServiceInitiating extends ServiceEvent {
  @override
  String toString() => 'ServiceInitiated';
}

class ExitServices extends ServiceEvent {
  @override
  String toString() => 'ExitServices';
}
