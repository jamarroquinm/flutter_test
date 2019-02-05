import 'package:bloc/bloc.dart';
import 'package:learning_flutter/authenticator/backend/Exports.dart';
import 'package:learning_flutter/authenticator/models/Exports.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  Person _person = Person(id: 0);

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationState currentState,
      AuthenticationEvent event,
      ) async* {

    if (event is AppStarted) {
      final Person varPerson = await PersonHelper().getItemFromRepository();

      _person = varPerson;

      if (varPerson != null && varPerson.id > 0) {
        yield AuthenticationAuthenticated();
      } else {
        yield AuthenticationUnauthenticated();
      }

    } else if (event is LoggedIn) {
      yield AuthenticationLoading();
      _person = event.person;
      yield AuthenticationAuthenticated();
    }else if (event is LoggedOut) {
      yield AuthenticationLoading();
      _person = Person(id: 0);
      yield AuthenticationUnauthenticated();
    }
  }

  Person get person => _person;
}