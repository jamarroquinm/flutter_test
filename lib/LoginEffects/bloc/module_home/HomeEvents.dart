import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class HomeEvent extends Equatable {
  HomeEvent([List props = const []]) : super(props);
}

//command bloc to recover variables from shared preferences or their default values
class HomeInitiate extends HomeEvent {
  @override
  String toString() => 'HomeInitiate';
}


//command bloc to notify that HomePage must be opened
class HomeUpdate extends HomeEvent {
  @override
  String toString() => 'HomeUpdate';

}


//command bloc to notify that PartnerPage must be opened
class AddPartner extends HomeEvent {
  @override
  String toString() => 'AddPartner';
}


//command bloc to notify that SharingAlert must be opened
class Share extends HomeEvent {
  @override
  String toString() => 'Share';
}


//command bloc to save variables and then notify that close Home Module
class HomeExit extends HomeEvent {
  final String route;

  HomeExit({@required this.route}) : super([route]);

  @override
  String toString() => 'HomeExit to $route';
}


class HomeFailing extends HomeEvent {
  final String error;

  HomeFailing({@required this.error}) : super([error]);

  @override
  String toString() => 'HomeFailing, error: $error';
}


class HomeLoggingOut extends HomeEvent {
  @override
  String toString() => 'HomeLoggingOut';
}
