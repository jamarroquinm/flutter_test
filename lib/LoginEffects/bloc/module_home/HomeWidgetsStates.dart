import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class HomeWidgetsState extends Equatable {
  HomeWidgetsState([List props = const []]) : super(props);
}

class HomeWidgetInitial extends HomeWidgetsState {
  @override
  String toString() => 'CategoryInitial';
}


class HomeWidgetLoading extends HomeWidgetsState {
  @override
  String toString() => 'Loading';
}


class HomeWidgetFailure extends HomeWidgetsState {
  final String error;

  HomeWidgetFailure({@required this.error}) : super([error]);

  @override
  String toString() => 'HomeWidgetFailure { error: $error }';
}
