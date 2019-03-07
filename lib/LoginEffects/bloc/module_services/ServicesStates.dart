import 'package:equatable/equatable.dart';

abstract class ServiceState extends Equatable {
  ServiceState([List props = const []]) : super(props);
}


class ServiceUninitialized extends ServiceState {
  @override
  String toString() => 'ServiceUninitialized';
}


class ServiceLoading extends ServiceState {
  @override
  String toString() => 'ServiceLoading';
}


class ServiceInitial extends ServiceState {
  @override
  String toString() => 'ServiceInitial';
}


class ServiceFailure extends ServiceState {
  @override
  String toString() => 'ServiceFailure';
}
