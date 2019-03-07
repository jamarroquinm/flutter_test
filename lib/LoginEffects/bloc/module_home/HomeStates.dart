import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class HomeState extends Equatable {
  HomeState([List props = const []]) : super(props);
}

//Se ha entrado a este módulo
class HomeUninitialized extends HomeState {
  @override
  String toString() => 'HomeUninitialized';
}


//Las variables del HomeBloc se actualizaron y se puede abrir HomePage
class HomeUpdated extends HomeState {
  @override
  String toString() => 'HomeUpdated';
}


//Para abrir PartnerPage
class AddingPartner extends HomeState {
  @override
  String toString() => 'AddingPartner';
}


//Para abrir SharingAlert pasándole un MessageSharable
class Sharing extends HomeState {
  @override
  String toString() => 'Sharing';
}


//Para guardar las variables actuales y luego salir del módulo
class HomeExiting extends HomeState {
  final String route;

  HomeExiting({@required this.route}) : super([route]);
  @override
  String toString() => 'HomeExiting';
}


//For transitions
class HomeLoading extends HomeState {
  @override
  String toString() => 'HomeLoading';
}


class HomeFailure extends HomeState {
  final String error;

  HomeFailure({@required this.error}) : super([error]);

  @override
  String toString() => 'HomeFailure { error: $error }';
}


class HomeLogout extends HomeState {
  @override
  String toString() => 'HomeLogout';
}
